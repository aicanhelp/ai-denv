## **1 Vim全键盘键位图**

### **1.1 英文版**

![](https://ask.qcloudimg.com/http-save/yehe-5949197/57cbaf4d4db0e734254abe2717da0360.jpeg)

- 绿色键：**motion**，移动光标，或定义操作的范围
- 黄色键：**command**，直接执行的命令，红色命令进入编辑模式
- 橙色键：**operator**，后面跟随表示操作范围的指令
- 灰色键：**extra**，特殊功能，需要额外的输入

### **中文版**

![](https://ask.qcloudimg.com/http-save/yehe-5949197/ef212f2fffd7e47327c6b217a23dcd90.jpeg)

## **2 Vim不同编辑模式下的键位图**

### **2.1 基础编辑（basic editing）**

![](https://ask.qcloudimg.com/http-save/yehe-5949197/788c5086194cc519ca41c308a899bc20.jpeg)

#### **上下左右移动光标**

- `h`：左
- `l`：右
- `j`：下
- `k`：上

#### **行首行尾移动**

- `0`：行首（第0个字符）
- `$`：行尾（类似正则表达式语法）

#### **单词间移动**

- `w`：下一个单词（**w**ord）
- `b`：上一个单词
- `e`：单词尾（**e**nd）

### **2.2 操作&重复（operators & repetition）**

![](https://ask.qcloudimg.com/http-save/yehe-5949197/47d13a53c185ea60334a50bea8a47bf4.jpeg)

#### **剪切（删除）**

- `dd`：**剪切当前行**
- `d$`：剪切当前行**光标**所在的位置到**行尾**
- `d^`：剪切当前行**光标**所在的位置到**行首**
- `ndd`：从当前行起，**剪切n行**

### **2.3 复制&粘贴（yank & paste）**

![](https://ask.qcloudimg.com/http-save/yehe-5949197/fb2425d7c96b42ba7bc7c20b017c2418.jpeg)

#### **复制**

- `yy`：**复制当y前行**
- `y$`：复制当前行**光标**所在的位置到**行尾**
- `y^`：复制当前行**光标**所在的位置到**行首**
- `nyy`：从当前行起，**复制n行**

#### **粘贴**

- `p`：在**此行之后**粘贴
- `P`：在**此行之前**粘贴

### **2.4 搜索（searching）**

![](https://ask.qcloudimg.com/http-save/yehe-5949197/0e9e82b7274ba6e29692a42512575e2f.jpeg)

### **2.5 标记&宏（marks & macros）**

![](https://ask.qcloudimg.com/http-save/yehe-5949197/a377956661411915b4ddd23373989971.jpeg)

### **2.6 各类移动（various motions）**

![](https://ask.qcloudimg.com/http-save/yehe-5949197/f3cd5b138f7c8b4635645324d54bba8c.jpeg)

#### **文档范围内移动**

- `gg`:文档顶部
- `G`:文件底部或行号（如果在G前面放置数字）

#### **当前可见页面内移动**

- `H`：将光标移动到当前可见页面的顶部（**H**igh）
- `M`：将光标移到当前可见页面的中间（**M**iddle）
- `L`：将光标移动到当前可见页面的底部（**L**ow）

### **2.7 各类命令（various commands）**

![](https://ask.qcloudimg.com/http-save/yehe-5949197/28d458542481f1f9f644a5ce59b25bae.jpeg)
