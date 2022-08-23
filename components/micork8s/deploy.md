

#### 1. Install the Juju client

On Linux, install `juju` via [snap](https://snapcraft.io/docs/installing-snapd) with the following command:

```bash
snap install juju --classic
```

Alternatively, `brew install juju` on macOS or [download the Windows installer](https://launchpad.net/juju/2.8/2.8.5/+download/juju-setup-2.8.5-signed.exe).

#### 2. Connect Juju to your Kubernetes cluster

In order to operate workloads in your Kubernetes cluster with Juju, you have to add your cluster to the list of *clouds* in juju via the `add-k8s` command.

If your Kubernetes config file is in the standard location (`~/.kube/config` on Linux), and you only have one cluster, you can simply run:

```bash
juju add-k8s myk8s
```

If your kubectl config file contains multiple clusters, you can specify the appropriate one by name:

```bash
juju add-k8s myk8s --cluster-name=foo
```

Finally, to use a different config file, you can set the `KUBECONFIG` environment variable to point to the relevant file. For example:

```bash
KUBECONFIG=path/to/file juju add-k8s myk8s
```

For more details, see the [Juju documentation](https://juju.is/docs/clouds).

#### 3. Create a controller

To operate workloads on your Kubernetes cluster, Juju uses controllers. You can create a controller with the `bootstrap` command:

```bash
juju bootstrap myk8s my-controller
```

This command will create a couple of pods under the `my-controller` namespace. You can see your controllers with the `juju controllers` command.

You can read more about controllers in the [Juju documentation](https://juju.is/docs/olm/controllers).

#### 4. Create a model

A model in Juju is a blank canvas where your operators will be deployed, and it holds a 1:1 relationship with a Kubernetes namespace.

You need to create a model and give it the name `kubeflow`, with the `add-model` command:

```bash
juju add-model kubeflow
```

You can list your models with the `juju models` command.

#### 5. Deploy Kubeflow

Requirements: The minimum resources required to deploy `kubeflow` are: 50Gb disk space, 14Gb RAM and 2 CPUs available to your Linux machine or VM. If you have fewer resources, please deploy `kubeflow-lite`.

Once you have a model, you can simply `juju deploy` any of the provided [Kubeflow bundles](https://charmed-kubeflow.io/docs/operators-and-bundles) into your cluster. For example, for the Kubeflow lite bundle, run:

```bash
juju deploy kubeflow-lite --trust
```

**Congratulations, Kubeflow is now installing !**

You can observe your Kubeflow deployment getting spun-up with the command:

```bash
watch -c juju status --color
```

#### 6. Add RBAC role

Currently, in order to setup Kubeflow with Istio correctly *when RBAC is enabled*, you need to provide the `istio-ingressgateway` operator access to Kubernetes resources. The following command will create the appropriate role:

```bash
kubectl patch role -n kubeflow istio-ingressgateway-operator -p '{"apiVersion":"rbac.authorization.k8s.io/v1","kind":"Role","metadata":{"name":"istio-ingressgateway-operator"},"rules":[{"apiGroups":["*"],"resources":["*"],"verbs":["*"]}]}'
```

#### 7. Set URL in authentication methods

A final step to enable your Kubeflow dashboard access is to provide the istio-ingressgateway public URL to dex-auth and oidc-gatekeeper via the following commands:

```bash
juju config dex-auth public-url=http://<URL>
juju config oidc-gatekeeper public-url=http://<URL>
```

Where `<URL>` is the hostname that the Kubeflow dashboard responds to. For example, in a typical MicroK8s installation, this URL is `http://10.64.140.43.nip.io`. Note that when you have set up DNS, you should use the resolvable address used by istio-ingressgateway.

MicroK8s: When evaluating Charmed Kubeflow using MicroK8s, you can enable the MetalLB add-on in order to expose the istio-ingressgateway: `microk8s enable storage dns metallb:10.64.140.43-10.64.140.49`#### 1. Install the Juju client

On Linux, install `juju` via [snap](https://snapcraft.io/docs/installing-snapd) with the following command:

```bash
snap install juju --classic
```

Alternatively, `brew install juju` on macOS or [download the Windows installer](https://launchpad.net/juju/2.8/2.8.5/+download/juju-setup-2.8.5-signed.exe).

#### 2. Connect Juju to your Kubernetes cluster

In order to operate workloads in your Kubernetes cluster with Juju, you have to add your cluster to the list of *clouds* in juju via the `add-k8s` command.

If your Kubernetes config file is in the standard location (`~/.kube/config` on Linux), and you only have one cluster, you can simply run:

```bash
juju add-k8s myk8s
```

If your kubectl config file contains multiple clusters, you can specify the appropriate one by name:

```bash
juju add-k8s myk8s --cluster-name=foo
```

Finally, to use a different config file, you can set the `KUBECONFIG` environment variable to point to the relevant file. For example:

```bash
KUBECONFIG=path/to/file juju add-k8s myk8s
```

For more details, see the [Juju documentation](https://juju.is/docs/clouds).

#### 3. Create a controller

To operate workloads on your Kubernetes cluster, Juju uses controllers. You can create a controller with the `bootstrap` command:

```bash
juju bootstrap myk8s my-controller
```

This command will create a couple of pods under the `my-controller` namespace. You can see your controllers with the `juju controllers` command.

You can read more about controllers in the [Juju documentation](https://juju.is/docs/olm/controllers).

#### 4. Create a model

A model in Juju is a blank canvas where your operators will be deployed, and it holds a 1:1 relationship with a Kubernetes namespace.

You need to create a model and give it the name `kubeflow`, with the `add-model` command:

```bash
juju add-model kubeflow
```

You can list your models with the `juju models` command.

#### 5. Deploy Kubeflow

Requirements: The minimum resources required to deploy `kubeflow` are: 50Gb disk space, 14Gb RAM and 2 CPUs available to your Linux machine or VM. If you have fewer resources, please deploy `kubeflow-lite`.

Once you have a model, you can simply `juju deploy` any of the provided [Kubeflow bundles](https://charmed-kubeflow.io/docs/operators-and-bundles) into your cluster. For example, for the Kubeflow lite bundle, run:

```bash
juju deploy kubeflow-lite --trust
```

**Congratulations, Kubeflow is now installing !**

You can observe your Kubeflow deployment getting spun-up with the command:

```bash
watch -c juju status --color
```

#### 6. Add RBAC role

Currently, in order to setup Kubeflow with Istio correctly *when RBAC is enabled*, you need to provide the `istio-ingressgateway` operator access to Kubernetes resources. The following command will create the appropriate role:

```bash
kubectl patch role -n kubeflow istio-ingressgateway-operator -p '{"apiVersion":"rbac.authorization.k8s.io/v1","kind":"Role","metadata":{"name":"istio-ingressgateway-operator"},"rules":[{"apiGroups":["*"],"resources":["*"],"verbs":["*"]}]}'
```

#### 7. Set URL in authentication methods

A final step to enable your Kubeflow dashboard access is to provide the istio-ingressgateway public URL to dex-auth and oidc-gatekeeper via the following commands:

```bash
juju config dex-auth public-url=http://<URL>
juju config oidc-gatekeeper public-url=http://<URL>
```

Where `<URL>` is the hostname that the Kubeflow dashboard responds to. For example, in a typical MicroK8s installation, this URL is `http://10.64.140.43.nip.io`. Note that when you have set up DNS, you should use the resolvable address used by istio-ingressgateway.

MicroK8s: When evaluating Charmed Kubeflow using MicroK8s, you can enable the MetalLB add-on in order to expose the istio-ingressgateway: `microk8s enable storage dns metallb:10.64.140.43-10.64.140.49`



*NOTE: 通过juju status来查看app的安装情况，如果有异常先用 juju remove-application 命令删除，然后用命令juju deploy重新安装*
