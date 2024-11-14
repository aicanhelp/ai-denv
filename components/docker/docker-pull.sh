#!/bin/bash
# shellcheck shell=bash
# shellcheck disable=SC2086

# 确保使用 UTF-8 编码
export LC_ALL=C.UTF-8

# 设置 PATH 变量
PATH=${PATH}:/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin:/opt/homebrew/bin
export PATH

# 定义终端输出颜色
Blue="\033[1;34m"
Green="\033[1;32m"
Red="\033[1;31m"
Yellow="\033[1;33m"
NC="\033[0m"
INFO="[${Green}信息${NC}]"
ERROR="[${Red}错误${NC}]"
WARN="[${Yellow}警告${NC}]"

# 打印信息的函数
function INFO() {
	echo -e "${INFO} ${1}"
}

# 打印错误信息的函数
function ERROR() {
	echo -e "${ERROR} ${1}"
}

# 打印警告信息的函数
function WARN() {
	echo -e "${WARN} ${1}"
}

# 从指定镜像源拉取 Docker 镜像的函数
function docker_pull() {
	local image_name=$1
	local config_dir=${2:-"/etc/images"}

	# 创建配置目录（如果不存在）
	mkdir -p "${config_dir}"

	# 定义 Docker 镜像源
	local mirrors=("docker.io" "docker.fxxk.dedyn.io" "docker.m.daocloud.io" "docker.adysec.com" "registry-docker-hub-latest-9vqc.onrender.com" "docker.chenby.cn" "dockerproxy.com" "hub.uuuadc.top" "docker.jsdelivr.fyi" "docker.registry.cyou" "dockerhub.anzu.vip")

	# 检查是否存在自定义镜像源文件，如果存在则读取其中的镜像源
	if [ -s "${config_dir}/docker_mirrors.txt" ]; then
		mirrors=()
		while IFS= read -r line; do
			mirrors+=("$line")
		done < "${config_dir}/docker_mirrors.txt"
	else
		# 如果不存在则使用默认镜像源并写入文件
		for mirror in "${mirrors[@]}"; do
			printf "%s\n" "$mirror" >> "${config_dir}/docker_mirrors.txt"
		done
	fi

# 测试镜像源连接性的函数
function test_mirror() {
	local mirror=$1
	INFO "测试与 ${mirror} 的连接..."
	timeout 30 docker pull "${mirror}/library/hello-world:latest" &> /dev/null
	return $?
}

# 并行测试镜像源
for mirror in "${mirrors[@]}"; do
	test_mirror "${mirror}" &
	done
wait

# 遍历每个镜像源并尝试拉取 Docker 镜像
for mirror in "${mirrors[@]}"; do
	if test_mirror "${mirror}"; then
		INFO "与 ${mirror} 的连接测试成功！从 ${mirror} 拉取 ${image_name}..."
		for i in {1..2}; do
			if timeout 300 docker pull "${mirror}/${image_name}"; then
				INFO "${image_name} 拉取成功！"
				# 将成功的镜像源移到列表首位
				sed -i "/${mirror}/d" "${config_dir}/docker_mirrors.txt"
				sed -i "1i ${mirror}" "${config_dir}/docker_mirrors.txt"
				break 2
			else
				WARN "${image_name} 拉取失败。重试中..."
			fi
		done
		# 如果使用默认的 docker.io 镜像源，清理 hello-world 镜像
		if [[ "${mirror}" == "docker.io" ]]; then
			docker rmi "library/hello-world:latest"
			[ -n "$(docker images -q "${image_name}")" ] && return 0
		else
			docker rmi "${mirror}/library/hello-world:latest"
			[ -n "$(docker images -q "${mirror}/${image_name}")" ] && break
		fi
	fi
done

	# 如果成功拉取镜像，则标记并清理临时镜像
	if [ -n "$(docker images -q "${mirror}/${image_name}")" ]; then
		docker tag "${mirror}/${image_name}" "${image_name}"
		docker rmi "${mirror}/${image_name}"
		return 0
	else
		# 如果所有镜像源都失败，打印错误信息并退出
		ERROR "从所有镜像源拉取 ${image_name} 的尝试均失败。请检查您的网络并重试。"
		exit 1
	fi
}

# 主脚本开始
function usage() {
	echo "使用方法: $0 <镜像名称> [配置目录]"
	echo " <镜像名称> 要拉取的 Docker 镜像名称"
	echo " [配置目录] 可选，存放配置文件的目录"
	exit 1
}

if [ -n "$1" ]; then
	docker_pull "$1" "$2"
else
	# 如果没有提供镜像名称，则提示用户输入
	while :; do
		read -erp "请输入要拉取的 Docker 镜像名称 (例如: ailg/alist:latest): " pull_img
		[ -n "${pull_img}" ] && break
	done
	docker_pull "${pull_img}" "~/.docker_pull"
fi