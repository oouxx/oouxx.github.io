---
title: 编译安装VIM8.0以及安装YouCompleteMe
date: 2019-04-17 10:42:20
tags:
- VIM
- YouCompleteMe
- 编译
categories:
- Linux
- VIM
---
今天心血来潮想搞一搞VIM，然后就不停的Google......，找各种教程，遇到了各种问题麻烦（心累并快乐着）......通过这篇文章,希望能让大家的VIM折腾之路更平坦一点。

先报一下机型Ubuntu16.04TLS，自带VIM是7.4版本
### 第一步
##### 卸载自带VIM
```
$ dkpg -l | grep vim
$ sudo dpkg -P vim vim-tiny vim-common #这里不限于这几个，看上一步命令列出来的内容，如果报依赖问题，不能卸载，用下面命令（我的就是报了依赖）
$ sudo apt-get remove vim-tiny vim-common
```
### 第二步
##### 安装依赖
```
$ sudo apt-get install libncurses5-dev libgnome2-dev libgnomeui-dev \
libgtk2.0-dev libatk1.0-dev libbonoboui2-dev \
libcairo2-dev libx11-dev libxpm-dev libxt-dev python-dev \
python3-dev ruby-dev lua5.1 lua5.1-dev git
```
### 第三步
##### 下载VIM源码并编译安装
```
$ cd ~
$ git clone https://github.com/vim/vim.git
$ cd vim
$ ./configure --with-features=huge \
--enable-multibyte \
--enable-rubyinterp=yes \
--enable-pythoninterp=yes \
--with-python-config-dir=/usr/lib/python2.7/config-x86_64-linux-gnu  \
--enable-python3interp=yes \
--with-python3-config-dir=/usr/lib/python3.5/config-x86_64-linux-gnu  \
--enable-perlinterp=yes \
--enable-luainterp=yes \
--enable-gui=gtk2 --enable-cscope --prefix=/usr
$ make VIMRUNTIMEDIR=/usr/share/vim/vim80 #重新编译了几次每次都把这句给忘了，太注重上面的参数了QAQ
$ sudo make install  
```
> 其中参数说明如下：  
--with-features = huge：支持最大特性  
--enable-multibyte：多字节支持可以在Vim中输入中文  
--enable-rubyinterp：启用Vim对ruby编写的插件的支持  
--enable-pythoninterp：启用Vim对python2 编写的插件的支持
--enable-python3interp:   启用Vim对python3 编写的插件的支持
--enable-luainterp：启用Vim对于lua 编写的插件的支持  
--enable-perlinterp：启用Vim对perl编写的插件的支持  
--enable-cscope：Vim对cscope支持  
--with-python-config-dir=/usr/lib/python2.7/config-x86_64-linux-gnu :指定python路径 
--enable-gui = gtk2：gtk2支持，也可以使用gnome，表示生成gvim  
-prefix = / usr：编译安装路径
### 第四步（非必须）
##### 安装checkinstall工具
可以安装checkinstall工具将从源码安装的软件变得像用deb包安装的一样，方便以后可以直接用sudo dpkg -P vim删除vim：
```
$ sudo apt-get install checkinstall
$ cd vim
$ sudo checkinstall
```
### 第五步
##### 设置VIM为默认编辑器
```
$ sudo update-alternatives --install /usr/bin/editor editor /usr/bin/vim 1
$ sudo update-alternatives --set editor /usr/bin/vim
$ sudo update-alternatives --install /usr/bin/vi vi /usr/bin/vim 1
$ sudo update-alternatives --set vi /usr/bin/vim
```
---
下面开始安装VIM插件
### 第一步
##### 安装Vundle插件管理器
```
$ git clone https://github.com/gmarik/Vundle.vim.git ~/.vim/bundle/Vundle.vim
```
### 第二步
##### 配置.vimrc
```
$ vim ~/.vimrc#这个还是网上找大佬的吧,复制粘贴一下，我用VIM也没多久。
```
```
set nocompatible "be iMproved, required
filetype off " required
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
call vundle#end()
filetype plugin indent on
#这些基本就是.vimrc文件必须的语句，其中插件必须放在`call vundle#begin()`
和`call vundle#end()` 之间
```
### 第三步
##### 安装YouCompleteMe
写入.vimrc文件
```
Plugin 'Valloric/YouCompleteMe'
$ vim
:PluginInstall
```
完成之后
```
$ cd ~/.vim/bundle/YouCompleteMe
./install.py --clang-completer 
#当我运行这个语句的时候去使用vim结果一直给我报错（the ycmd server shut down(restart......记不太清了)）
$sudo python3 install.py --clang-completer
#我再issue上找到了答案（https://github.com/Valloric/YouCompleteMe/issues/914）
```


