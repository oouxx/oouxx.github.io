---
title: privoxy真全局代理
date: 2019-05-31 17:00:43
tags:
- 代理
categoriess:
- 杂谈
---

## 使用privoxy实现真全局代理

在Linux上实现真全局代理

1. 安装

以ubuntu为例

```shell
sudo apt-get install privoxy
```

2. 修改配置文件

```shell
sudo vim /etc/privoxy/config
```

找到4.1 listen-address 确认监听的的地址和端口号

找到5.2 forward-socks4, forward-socks4a, forward-socks5 and forward-socks5t

在最后加上

```
forward-socks5 / 127.0.0.1:1080 .
```

注意最后有个点号

3. 修改自己的代理设置

```
echo 'export http_proxy="127.0.0.1:8118"' >> .bashrc
echo 'export https_proxy="127.0.0.1:8118"' >> .bashrc

```
其中`8118`是privoxy的默认端口号，可以改为在修改配置文件过程中自己设定的端口号

4. 重启privoxy服务

```shell
sudo systemctl restart privoxy
```
