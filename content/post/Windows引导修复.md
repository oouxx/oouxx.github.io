---
title: Windows引导修复
date: 2019-04-17T10:40:02+08:00
tags: ['Windows', '引导修复']
categories: ['Windows']
---
首先，先介绍一下我的状况：双系统，Windows10引导被误删，然后在网上各种Google教程，然并卵......直到我看到这篇文章，让我对操作系统的启动有了更加深刻的认识，下面说一下我的理解，希望能帮到更多小白。
### 来自：http://m.cfan.com.cn/pcarticle/128212

---
下面请先看这张图
![Windows的开机过程](https://img-blog.csdn.net/20180430182103621?watermark/2/text/aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L29vdXh4/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70)
从上面可以看出，面前主流的电脑基本都支持两种开机引导模式**UEFI** 和 **BIOS** （在BIOS界面可以设置）接下来按照两种引导模式来具体介绍如何修复。
### BIOS
出错情况一：由于病毒或者误操作，将`C:\bootmgr`，`C:\boot\bcd`，`C:\windows\system32\winload.exe` 任一文件删除，可想而知，肯定无法启动啦。
解决方法：从网上下载，或者从别人电脑上将此文件复制进自己U盘，通过winPE进入系统，将这些文件放到相应位置。
出错情况二：上述文件都还在，但是一不小心将开机引导条目删除，双系统的同学知道，开机时会让你选进哪个系统，就是指那个，单系统的话就一个系统，不会让你选直接就进了。

解决方法：用U盘制作PE进入系统（设置U盘为首选启动项，或者按f12）
进去后应该会有引导修复工具，用`bootice引导修复工具`,菜单栏选择BCD编辑，新建BCD,选择`C:\boot\bcd`,进入编辑界面后，按照下图填写（以Windows10为例）。然后重启就能正常进入系统了。
![这里写图片描述](https://img-blog.csdn.net/20180430183920180?watermark/2/text/aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L29vdXh4/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70)
### UEFI（我未实践因为我电脑只支持BIOS，老机器了）
首先检查主板BIOS设置是否有误。如果用户人为设置关闭UEFI引导（这样会导致仅UEFI引导的电脑引导错误，因为找不到“\EFI\Bootbootx64.efi”引导文件），或者仅UEFI启动（这样会导致BIOS引导电脑出错，因为找不到“C:\bootmgr”引导文件。）

如果还是不行，那么就用win10核心的PE（我用的微PE），进入系统，里面有个UEFI引导修复工具，进入命令提示符，输入`bcdboot C:\Windows  /s S: /f uefi /l zh-cn`
1.  BIOS+MBR 常用
`bcdboot C:\Windows /l zh-cn`
解释：从系统盘C:\Windows目录中复制启动文件，并创建BCD（中文）启动菜单，从而修复系统启动环境。
2. UEFI+GPT 常用
`bcdboot C:\Windows  /s S: /f uefi /l zh-cn`
解释：用DG等工具先将ESP分区装载为S盘，从系统盘C:\Windows目录中复制UEFI格式的启动文件到ESP分区中，修复系统。

`c:\windows` 系统安装目录，打开我的电脑，查看你的系统是安装在那个盘，就输入相应的盘符和目录。 
```
/s S: 指定esp分区所在磁盘，小编指定ESP分区为t盘。 
/f uefi 指定启动方式为uefi，注意之间的空格一定要输入。 
/l zh-cn 指定uefi启动界面语言为简体中文
```
以上命令正确执行的前提为：
1. 启动分区存在 
2. windows安装盘中启动文件存在

关于怎么查看具体的分区况状请使用`dispart` 命令（自行百度）

如果你是多系统的话上面方法只能修复Windows引导，你可以使用上面提到的`bootice` 工具进行添加条目，或者你进了Windows之后使用`easyBCD`这个软件添加。

