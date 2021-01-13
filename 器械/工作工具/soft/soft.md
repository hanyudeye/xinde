title: ubuntu下实用软件

## 下载youtube 视频
youtube-dl-gui 图形界面
youtube-dl --proxy socks5://127.0.0.1:42428  https://www.youtube.com/watch?v=pKauTcfL-AE&feature=youtu.be

## appimage 软件管理 
AppimageLauncher： 用来更好的使用以 appimage 为拓展名的应用程序。

## 设计软件
 - krita 绘图
 - gimp 图片修理
 - 
## 影视处理
### 录制视频短片 peek
      sudo add-apt-repository ppa:peek-developers/stable
      sudo apt update
      sudo apt install peek
### 像素识别
      sudo snap install pick-colour-picker 
### 屏幕录制
sudo apt install simplescreenrecorder
## 编辑器 
- emacs
- vscode

## 网络
### natapp 内网穿透
./natapp -authtoken=e5eb817e91aeee83

由于微信屏蔽了natapp的三级域名，所以如果需要进行微信支付或者微信小程序的联调时需要注册一个二级域名
如果用于联调微信小程序的话，则需要注册带有SSL证书的，因为微信小程序仅支持https协议。

## 字幕
## 添加字母软件
### 迅捷视频剪辑软件
https://link.zhihu.com/?target=https%3A//www.xunjieshipin.com/download-video-crop%3Fzhczk


## 修改 wine-qq 字体大小
env WINEPREFIX="$HOME/.deepinwine/Deepin-QQ" winecfg

在显示一栏设置 dpi 大小
