---
title: Linux时间同步问题.md
date: 2018-10-10 09:01:14
tags: 
	- linux
	- 时间同步
categories: 
	- linux
---

### Linux时间同步问题
一般是win和linu双系统用户可能遇到此烦恼，造成两个系统时间不一样的原因是，linux自动将硬件时间识别为UTC时间，UTC时间是世界统一时间，可以认为是格林尼治时间。而我们所在的时区为东八区，要比那个时间早8个小时，所以win和linux时间总是差8小时。

我以前要到过这样的问题都是一条命令解决的
```bash
sudo timedatectl set-rtc-local 1
```
这次遇到的尴尬问题是我的时间跟标准时间差16个小时，原因在于硬件时间都是错着的

```bash
// 查看timedatectl 命令的帮助文档
$ timedatectl --help
// 查看time 信息
$ timedatectl [status]
// 使用管理员权限关闭ntp同步,linux系统一般自带ntp服务，但是从来没同步对过。。。
$ sudo timedatectl set-ntp [on/off ,1/0 ,true/false]
// 设置rtc time 和 local同步
$ sudo timedatectl set-rtc-local 1
// 设置rtc time
$ sudo hwclock --set --date="2018-10-10 09:43:44"
// 根据rtc time设置system time
$ sudo hwclock -s
// 根据 system time 设置 rtc time
$ sudo hwclock -w
```
**hwclock**命令的具体用发参见帮助文档

就这样时间同步就设置好了，仅仅是个人的经验总结，可能有些步骤不对，但是解决了我的问题。博客第一次搬运到github上有点小鸡冻，欢迎在下方评论（需翻墙）
