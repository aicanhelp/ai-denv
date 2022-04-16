#### 修改模块URL  
- (1) 修改'.gitmodules'文件中对应模块的”url“属性;  
- (2) 使用 git submodule sync 命令，将新的URL更新到文件.git/config；  
```
git submodule sync 
git commit -am "Update submodule url."

```
