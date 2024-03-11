1、buildx 用于docker交叉编译  
  -（1）安装：sudo apt-get install docker-buildx  
  - （2）查看docker 驱动： docker buildx ls  
  - （3）默认的驱动为docker，需要，创建一个 docker-container的驱动： docker buildx create --name buildx-builder
  -  (4) 设定 默认builder为 buildx-builder: docker buildx use buildx-builder 
  -  (5) docker交叉编译： docker buildx build --platform linux/arm,linux/arm64,linux/amd64 -t mds/mds-alpine . 
        使用：--load 可以导入到本地 docker，但是--platform参数后只能有一个