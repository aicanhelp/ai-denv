
## 出现证书问题，可以禁用证书
export NODE_TLS_REJECT_UNAUTHORIZED=0

## 构建 electron 应用
```shell
nativefier \
  --insecure \
  --ignore-certificate \
  --name "doubao-ai" \
  --icon "./doubao-icon.png" \
  --width 1200 \
  --height 800 \
  --min-width 800 \
  --min-height 600 \
  --x 100 \
  --y 50 \
  --background-color "#ffffff" \
  --fast-load \
  --internal-urls "doubao\.com|bytedance\.com" \
  --disk-cache-size 1073741824 \
  --inject "./custom-style.css" \
  --user-agent "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 Safari/537.36 Edg/122.0.2365.92" \
  --tray \
  --counter \
  --bounce \
  --honest \
  "https://www.doubao.com"
```

```css
/* 自定义豆包应用样式 */
body {
    font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, Cantarell, sans-serif;
}

/* 隐藏不必要的页面元素 */
.ad-banner,
.promotion-panel,
.download-tips {
    display: none !important;
}

/* 优化聊天界面 */
.chat-container {
    max-width: 100% !important;
    padding: 10px !important;
}

.message-bubble {
    border-radius: 12px !important;
    box-shadow: 0 2px 4px rgba(0,0,0,0.1) !important;
}

/* 响应式调整 */
@media (max-width: 768px) {
    .sidebar {
        width: 60px !important;
    }
    
    .main-content {
        margin-left: 60px !important;
    }
}
```