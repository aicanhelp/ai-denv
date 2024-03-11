# Helm Charts
      Charts是helm使用的kubernetes程序包打包的格式，一个charts就是一个描述一组kubernetes资源文件的集合，Charts是一个遵循特定规范的目录结构，它能够打包成为一个可用于部署的版本化归档文件。

## 1、Charts文件组织结构
       一个Charts就是按特定格式组织的目录结构，目录名即为Charts名，目录名称本身不包含版本信息，一个Charts中每个目录及文件的基本作用如下：

       （1）Chart.yaml：当前Charts的描述信息

       （2）LICENSE：当前Charts的许可证信息文件，可选

       （3）requirements.yaml：当前Charts的依赖关系描述文件，可选

       （4）README.md：易读格式的README文件      

       （5）values.yaml：当前charts用到的默认配置值

       （6）cahrts/目录：存放当前Charts依赖到的所有Charts文件

       （7）templates/目录：存放当前Charts用到的模板文件，可应用于Charts生成有效的 Kuber-netes清单文件

       （8）templaets/NOTES.txt：纯文本文件，Template简单实用注解

## 2、Chart.yaml文件组织格式
       Chary.yaml用于提供Charts相关的各种元数据，如名称、版本、关键词、维护者信息、实用的模板引擎等，它是一个Charts必备的核心文件，主要包含如下字段：

       （1）name：当前Charts的名称

       （2）version：遵循语义化版本规范第二版的版本号

       （3）description：当前项目的单语句描述信息，可选字段

       （4）keyword：当前项目的关键词列表，可选字段

       （5）home：当前项目主页URL，可选字段

       （6）sources：当前项目用到的源码的URL列表，可选字段

       （7）maintainers：项目维护者信息，可选字段

       （8）engine：模板引擎的名称

       （9）icon：为URL，指向当前项目的图标，可选字段

       （10）appVersion：本项目用到的应用程序的版本号，可选字段

       （11）deprecated：当前Charts是否已经废弃，可选字段

       （12）tillerVersion：当前Charts依赖的Tiller版本号，可选字段

## 3、Charts中的依赖关系
       Helm中Charts的依赖关系可经requirements.yaml进行动态链接，也可直接存储于charts/目录中进行手动管理，建议使用动态管理。

### （1）erquirements.yaml文件

       Requirements.yaml文件本质上只是一个简单的依赖关系表，其中包含的主要字段如下：

       1）name：被依赖的Charts的名称

       2）version：被依赖的Charts的版本

       3）repository：被依赖的Charts所属的仓库及URL

       4）alias：为被依赖的Charts创建一个别名

       5）tags：默认情况下，所有的Charts都会被装载，若给定了tags则仅装载那些匹配到 的Charts

       6）condition：类似于tags字段，但需要通过自定义的条件来指明要装载的charts

       7）import-values：导入子charts中的值，被导入的值需要在子charts中导出。

       依赖关系配置完成后，可使用“helm dependency update”命令更新依赖关系，并自动下载被依赖的charts到charts/目录中。

### （2）Charts目录

       若需要对依赖关系进行更多的控制，则所有被依赖到的Charts都能以手工方式复制到Charts目录中。

## 4、模板和值
       Helm Charts模板模板遵循Go模板语言格式，所有的模板文件都存储于Template目录中，在当前的Charts被Helm引用时，此目录中的所有模板文件都会传递给模板引擎进行处理。模板文件中用到的值可由values.yaml文件提供或在运行helm install命令时传递包含所需要的自定义值得YAML文件。

## 5、自定义Charts
### （1）生成一个空的Charts

       创建一个Charts时可通过“helm create”命令创建，它能够在一个新的目录中创建初始化一个空的Charts目录结构，并包含所需要的各个核心文件

#### 创建初始化一个名为mychart的charts
```
[root@master01 helm]# helm create mychart
Creating mychart
[root@master01 helm]# tree mychart/
mychart/
├── charts
├── Chart.yaml
├── templates
│   ├── deployment.yaml
│   ├── _helpers.tpl
│   ├── ingress.yaml
│   ├── NOTES.txt
│   └── service.yaml
└── values.yaml
```
### （2）修改Charts以部署自定义服务
```
#### 修改values.yaml的一些基本配置
# cat mychart/values.yaml 
# Default values for mychart.
# This is a YAML-formatted file.
# Declare variables to be passed into your templates.
 
replicaCount: 1
 
image:
  repository: nginx
  tag: 1.12
  pullPolicy: IfNotPresent
 
service:
  type: ClusterIP
  port: 80
# 修改完配置后通过helm lint命令确认修改的Charts模板格式是否良好

]# helm lint mychart
==> Linting mychart
[INFO] Chart.yaml: icon is recommended

# 配置完成后可通过“helm install”命令调试运行
]# helm install --name mynginx --dry-run --debug ./mychart --set service.type=NodePort
# 测试无误后
```
### （3）Charts仓库

       一个基于本地的Charts设定完成后，他仅用于本地访问。同时也可将它通过”helm package”打包成tar包后分享。
```
# 打包自定义的charts
]# helm package ./mychart/
Successfully packaged chart and saved it to: /root/job/helm/mychart-0.1.0.tgz
# 搜索本地的charts
]# helm search local
NAME                 CHART VERSION     APP VERSION       DESCRIPTION                
local/mychart       0.1.0              1.0                A Helm chart for Kubernetes
```
### （4）、配置依赖关系

      当构建存在依赖关系的Charts时。还需要为其定义依赖项，依赖项定义在requirements.yaml文件中，定义完依赖项后通过运行“helm dependency update”命令更新依赖关系。用户也可以手动将依赖到的程序包直接放置于mycahrt/charts目录中定义依赖关系，此时不再必要使用requirements.yaml文件。