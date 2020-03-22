---
title: proxychains-ng代理上網
date: 2019-05-31T17:00:43+08:00
tags: ['代理']
categories: ['杂谈']
---

## 使用proxychains-ng实现真全局代理
- 安装和使用
```shell
sudo pacman -S proxychains-ng
sudo echo "socks5 127.0.0.1 1080" >> /etc/proxychains.conf
```
- 验证

```shell
proxychains curl -I www.google.com
```
返回200就说明代理成功啦
