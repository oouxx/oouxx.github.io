---
title: tornado多进程存在的问题
date: 2019-04-15 04:11:27
tags:
  - tornado
---
### tornado
tornado是一个非常高性能的轻量级web服务框架，但是tornado使用tornado.httpserver.HTTPServer()启动多进程的话会存在一定的问题
这里牵扯到了操作系统进程，线程相关的知识

原因有三：
### 第一
每个子进程都会从父进程中复制一个IOLopp的实例（相当于fork*()）,如果在创建子进程钱修改了了IOLoop,所有子进程都会改变。
### 第二
所以进程都是由一个命令启动即`python tornado_demo.py`,无法做到在不停止服务的情况下修改代码。
### 第三
所有进程共享一个端口，分别对进程进行监控变得很困难。
