---
title: mysql安装问题
date: 2018-10-15 08:39:21
tags:
  - linux
  - MySQL
categories:
  - linux
  - MySQL
---
### 运行环境
XUbuntu 18.04LTS

MySQL 5.7

### 问题描述
运行了下面命令后
```bash
$ sudo apt-get install mysql-server mysql-client libmysqlclient-dev
```
无法登陆mysql。
### 解决办法
因为在安装过程中并未提示设置root密码，就想着查看一下默认密码
```bash
$ cat /var/log/mysql/error.log | grep password
```
结果提示密码是空的，那她丫的我为啥登不进去！！！

修改mysql权限,无密码登陆
```bash
sudo vim /etc/mysql/mysql.conf.d/mysqld.cnf
```
在**[mysqld]** 条目下加上`skip-grant-tables`,无密码进入MySQL。
我在网上找到了三种方法修改密码
```
mysql> update mysql.user set authentication_string=password('123') where user='root' and Host = 'localhost';
// affected 1; changed 0 ; warning 1; 
mysql> alter user 'root'@'localhost' identified by '123';
// auth-plugin problem
mysql> set password for 'root'@'localhost'=password('123');
// auth-plugin problem
```
一开始我试着运行第一种，发现运行完之后根本没用，还是登陆不进去，
后来找到了方法二三，抛出了错误，尝试用下面命令解决了
```
mysql> update user set plugin="mysql_native_password" where User='root';
```
后来就能用了，记住改完密码后要记得
```bash 
mysql> flush privileges;
$ sudo vim /etc/mysql/mysql.conf.d/mysqld.cnf //将skip-grant-tables那行注释掉或者删掉
$ systemctl restart mysql  //重启mysql服务，让改动生效
```

### 总结
瞎鸡儿折腾，日常踩坑。









