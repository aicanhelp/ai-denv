## Linux 证书问题

### Steam 信任证书 ( Chrome 内核浏览器 )
  由于 Steam 使用 Chrome 内核浏览器，使用自管理证书库。   
  需要使用 Chrome 打开 设置 - 隐私设置和安全性 - 安全 - 管理证书 选择 授权机构( Authorities )
  在 Watt Toolkit 的设置 - 通用设置 - 存储空间 - 打开 AppData 目录中的 Plugins/Accelerator 目录下
  SteamTools.Certificate.pem文件 导入
  注：如文件不存在可修改 SteamTools.Certificate.cer 为 SteamTools.Certificate.pem勾选 信任该证书，以标识网站身份
#### 火狐浏览器
  打开 设置 - 隐私与安全 - 安全 - 证书 - 查看证书
  选择 证书颁发机构( Authorities )
  在 Watt Toolkit 的设置 - 通用设置 - 存储空间 - 打开 AppData 目录中的 Plugins/Accelerator 目录下
  SteamTools.Certificate.pem文件 ( 火狐支持 cer 或者 pem 格式导入 )
  勾选 信任由此证书颁发机构来标识网站
#### 存储空间 参考
- AppData 
  - Microsoft Store %USERPROFILE%\AppData\Local\Packages\4651ED44255E.47979655102CE_k6txddmbb6c52\LocalState
  - Windows 程序目录\AppData or %LocalAppData%\Steam++
  - macOS ~/Library/Steam++
  - Linux $XDG_DATA_HOME/Steam++ or $HOME/.local/share/Steam++
  - Android /data/data/net.steampp.app/files
- Cache
  - Microsoft Store %USERPROFILE%\AppData\Local\Packages\4651ED44255E.47979655102CE_k6txddmbb6c52\LocalCache
  - Windows 程序目录\Cache or %Tmp%\Steam++
  - macOS ~/Library/Caches/Steam++
  - Linux $XDG_CACHE_HOME/Steam++ or $HOME/.cache/Steam++
  - Android /data/data/net.steampp.app/cache
- Logs
  - Microsoft Store %USERPROFILE%\AppData\Local\Packages\4651ED44255E.47979655102CE_k6txddmbb6c52\LocalCache\Logs
  - Windows 程序目录\Cache\Logs
  - macOS ~/Library/Caches/Steam++/Logs
  - Linux $XDG_CACHE_HOME/Steam++/Logs or $HOME/.cache/Steam++/Logs
  - Android /data/data/net.steampp.app/cache/Logs