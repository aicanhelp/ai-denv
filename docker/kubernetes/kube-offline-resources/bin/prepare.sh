   #!/bin/bash

# Python version

source ./config.sh

KUBESPRAY_TARBALL=kubespray-${KUBESPRAY_VERSION}.tar.gz
KUBESPRAY_DIR=./cache/kubespray-${KUBESPRAY_VERSION}
FILES_DIR=outputs/files

function set_locale() {
    export LANG=C.UTF-8
    for i in en_US.UTF-8 en_US.utf8 C.utf8; do
        if locale -a | grep $i >/dev/null; then
            export LANG=$i
            break
        fi
    done
    export LC_ALL=$LANG
}

function prepare_common()
{
   dnf check-update
   dnf install -y rsync gcc libffi-devel createrepo git podman
}

function prepare_py() {
   set_locale
   pip3 install -r requirements.txt
}

function get_kubespray() {
    mkdir -p ./cache
    mkdir -p outputs/files/

    curl -SL https://github.com/kubernetes-sigs/kubespray/archive/refs/tags/v${KUBESPRAY_VERSION}.tar.gz >outputs/files/${KUBESPRAY_TARBALL}

    echo "===> Extract ${KUBESPRAY_TARBALL}"
    tar xzf outputs/files/${KUBESPRAY_TARBALL}

    mv kubespray-${KUBESPRAY_VERSION} ${KUBESPRAY_DIR}
    # Apply patches
    patch_dir=${CURRENT_DIR}/target-scripts/patches/${KUBESPRAY_VERSION}
    if [ -d $patch_dir ]; then
        for patch in ${patch_dir}/*.patch; do
            echo "===> Apply patch $patch"
            (cd $KUBESPRAY_DIR && patch -p1 < $patch) || exit 1
        done
    fi
}

function pypi_mirror() {
    #set -x
    pip3 install -U pip python-pypi-mirror

    DEST="-d outputs/pypi/files"
    PLATFORM="--platform manylinux2014_x86_64"  # PEP-599

    REQ=requirements.tmp
    #sed "s/^ansible/#ansible/" ${KUBESPRAY_DIR}/requirements.txt > $REQ  # Ansible does not provide binary packages
    cp ${KUBESPRAY_DIR}/requirements.txt $REQ
    echo "PyYAML" >> $REQ  # Ansible dependency
    echo "ruamel.yaml" >> $REQ # Inventory builder

    for pyver in 3.11 3.12; do
        echo "===> Download binary for python $pyver"
        pip download $DEST --only-binary :all: --python-version $pyver $PLATFORM -r $REQ || exit 1
    done
    /bin/rm $REQ

    echo "===> Download source packages"
    pip download $DEST --no-binary :all: -r ${KUBESPRAY_DIR}/requirements.txt

    echo "===> Download pip, setuptools, wheel, etc"
    pip download $DEST pip setuptools wheel || exit 1
    pip download $DEST pip setuptools==40.9.0 || exit 1  # For RHEL...

    echo "===> Download additional packages"
    PKGS=selinux  # need for SELinux (#4)
    PKGS="$PKGS flit_core"  # build dependency of pyparsing (#6)
    PKGS="$PKGS cython<3"  # PyYAML requires Cython with python 3.10 (ubuntu 22.04)
    pip download $DEST pip $PKGS || exit 1

    pypi-mirror create $DEST -m outputs/pypi

    echo "pypi-mirror done"
}

function create_repo() {
    # packages
    PKGS=$(cat pkglist/rhel/*.txt pkglist/rhel/${VERSION_MAJOR}/*.txt | grep -v "^#" | sort | uniq)

    dnf install 'dnf-command(download)'

    CACHEDIR=cache/cache-rpms
    mkdir -p $CACHEDIR

    RT="dnf download --resolve --alldeps --downloaddir $CACHEDIR"

    echo "==> Downloading: " $PKGS
    $RT $PKGS || {
        echo "Download error"
        exit 1
    }

    # create rpms dir
    RPMDIR=outputs/rpms/local
    if [ -e $RPMDIR ]; then
        /bin/rm -rf $RPMDIR || exit 1
    fi
    mkdir -p $RPMDIR
    /bin/cp $CACHEDIR/*.rpm $RPMDIR/
    /bin/rm $RPMDIR/*.i686.rpm

    echo "==> createrepo"
    createrepo $RPMDIR || exit 1

    echo "create-repo done."
}

function decide_relative_dir() {
    local url=$1
    local rdir
    rdir=$url
    rdir=$(echo $rdir | sed "s@.*/\(v[0-9.]*\)/.*/kube\(adm\|ctl\|let\)@kubernetes/\1@g")
    rdir=$(echo $rdir | sed "s@.*/etcd-.*.tar.gz@kubernetes/etcd@")
    rdir=$(echo $rdir | sed "s@.*/cni-plugins.*.tgz@kubernetes/cni@")
    rdir=$(echo $rdir | sed "s@.*/crictl-.*.tar.gz@kubernetes/cri-tools@")
    rdir=$(echo $rdir | sed "s@.*/\(v.*\)/calicoctl-.*@kubernetes/calico/\1@")
    rdir=$(echo $rdir | sed "s@.*/\(v.*\)/runc.amd64@runc/\1@")
    if [ "$url" != "$rdir" ]; then
        echo $rdir
        return
    fi

    rdir=$(echo $rdir | sed "s@.*/calico/.*@kubernetes/calico@")
    if [ "$url" != "$rdir" ]; then
        echo $rdir
    else
        echo ""
    fi
}

function get_url() {
    url=$1
    filename="${url##*/}"

    rdir=$(decide_relative_dir $url)

    if [ -n "$rdir" ]; then
        if [ ! -d $FILES_DIR/$rdir ]; then
            mkdir -p $FILES_DIR/$rdir
        fi
    else
        rdir="."
    fi

    if [ ! -e $FILES_DIR/$rdir/$filename ]; then
        echo "==> Download $url"
        for i in {1..3}; do
            curl --location --show-error --fail --output $FILES_DIR/$rdir/$filename $url && return
            echo "curl failed. Attempt=$i"
        done
        echo "Download failed, exit : $url"
        exit 1
    else
        echo "==> Skip $url"
    fi
}

# execute offline generate_list.sh
function generate_list() {
    #if [ $KUBESPRAY_VERSION == "2.18.0" ]; then
    #    export containerd_version=${containerd_version:-1.5.8}
    #    export host_os=linux
    #    export image_arch=amd64
    #fi
    LANG=C /bin/bash ${KUBESPRAY_DIR}/contrib/offline/generate_list.sh || exit 1

    #if [ $KUBESPRAY_VERSION == "2.18.0" ]; then
    #    # check roles/download/default/main.yml to decide version
    #    snapshot_controller_tag=${snapshot_controller_tag:-v4.2.1}
    #    sed -i "s@\(.*/snapshot-controller:\)@\1${snapshot_controller_tag}@" ${KUBESPRAY_DIR}/contrib/offline/temp/images.list || exit 1
    #fi
}

function  get_kubespray_files() {
   generate_list

   mkdir -p $FILES_DIR

   cp ${KUBESPRAY_DIR}/contrib/offline/temp/files.list $FILES_DIR/
   cp ${KUBESPRAY_DIR}/contrib/offline/temp/images.list $IMAGES_DIR/

   # download files
   files=$(cat ${FILES_DIR}/files.list)
   for i in $files; do
       get_url $i
   done
}

function start() {
    prepare_common
    prepare_py
    get_kubespray
    pypi_mirror
    create_repo
    get_kubespray_files
}

start