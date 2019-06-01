---
title: 计算机科学
date: 2019-03-31 07:38:33
tags: 人，工具
categories: 资料整理
---
# 程序计算机系统
人发明此工具，在于其能复用且更复杂地处理事情。
计算机，开始于键盘，作一些简单计算。
自从加入可编程性，能计算更复杂的数学运算。
加入了磁盘，便能放置更多的数据。
加入了显示器，其能显示一些动画，作出游戏。
加入了音频，便能播放优美的音乐。
加入了网，便能跟其他计算机交流通信。
交流通信用到了握手的方法。
计算机的沟通需要借助有说服力的简单，不变的符号，便用到了二进制。
二进制作出了代码，数字，小数，文字，图片，图像，声音，信号....
二进制的数字运算是布尔算术，包含 与，非，或，异或 [门和触发器的发明解决了硬件问题]
二进制的运算用到了处理器( CPU )
虽然可以把所有处理都放在CPU里，但模块化便于配置个人电脑。

当前数据常以独立的文件构成，文件是树下的节点。
操作系统，使使用程序更方便。
为了更好的利用数据片段，便有人设计了数据库。
文字，图片，视频构建了相对丰富的网络页面,浏览器充当渲染器。
编程也更趋向于自然语言。
算法,是研究解决计算问题的一门学科了。
压缩技术为了节约磁盘。
多任务，产生了进程问题。进程切换的死锁问题，还有进程通信问题。
分布式网络更复杂，但更稳定。
网络安全问题也需要重视。

软件工程，有质量,有规范地设计，编写软件。
计算机图形学。
人工智能技术.
## 基础
### 信息表示 [ 二进制,位 ] 
[CPU,IO[显示器，键盘，鼠标，话筒，音响,存储器,网卡]在做功]
信息存储 [ 最小单位 字节 ]
类型长度 sizeof

#### 浮点数
#### 字符串 [ASCII ,Unicode(统一字符编码)]
### 信息处理
#### 布尔代数
C 中位运算  ~(NOT),^(EXCLUSIVE-OR),&(AND),|(OR)
#### 移位操作 (算术 ，逻辑)
左移 << 
右移 >>
#### 数学运算
加法 [ 补码 ]
## 硬件 [ 组成部件 ]
### CPU [ 计算执行器 ]
   * 程序计数器
   *  指令解码器
   * 数据总线
   * 通用寄存器
   * 算术逻辑单元
   * I/O(接收或输出到外部部件) 
### 存储器 [ ram,rom,random,寄存器 (处理数据)]
### IO [ 外设(输入输出数据) ]
* 键盘
* 鼠标
* 显示器
### 其他计算器 [ 专用计算器 ]
* DMA 控制器
* 定时/计数器 
## 软件 [ 程序部件 ] 
