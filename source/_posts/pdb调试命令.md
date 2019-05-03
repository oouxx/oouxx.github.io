---
title: pdb调试命令
date: 2018-12-02 17:10:13
tags:
  - Python
  - debug

categories:
  - Python
---
### instructions
|instruction|comment|
|-----------|-------|
|break/b    |设置断点|
|continue/c |继续执行程序|
|list/l     |查看当前行附近代码段|
|step/s     |进入函数|
|return/r   |执行代码直到当前函数返回|
|exit/q     |中止并退出|
|next/n     |执行下一行|
|pp         |打印变量值|
|help       |帮助|

### how can i use it ? just write this instruction.
```shell
$ python/python3 -m pdb filename.py
```
