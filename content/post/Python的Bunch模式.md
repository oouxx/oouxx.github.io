---
title: Python的Bunch模式
date: 2018-10-30T21:41:57+08:00
tags: ['Python', 'algorithm']
categories: ['Python', 'algorithm']
---

### Python的Bunch模式
今天在看**Python algorithm**，看到了这个东西，感觉会很有用，赶快拿起vim码起字来分享给大家。我也粗略的在网上浏览了一下也有一些Python爱好者分享但是都没对**Python CookBook**做介绍只是把书上的代码码了上来。最初Bunch这个词来自于**Python CookBook**，这本书是一本Python的进阶书，讲了很多Python的奇淫巧技，是一本非常值得读的经典书籍。

Bunch的基本要素
```Pyhton
class Bunch(dict):
    def __init__(self, *args, **kwds):
	super(Bunch, self).__init__(self, *args, **kwds)
	self.__dict__ = self
```
该模式主要有几个有用的作用：
１.　允许命令行参数的形式创建对象，并设置属性
２.　获得dict的相关特性

```Python
>>> x = Bunch(name = "wxx", sex="male")
>>> x.name
'wxx'
```

```Python
>>> T = Bunch
>>> t= T(left=T(left = "a", right = "b"), right=T(left = "c"))
>>> t.left
{'left':a, 'right':b}
>>> t.left.left
'a'
>>> t['left']['right']
'b'
>>> "left" in t.right
True
>>> "right" in t.right
False
```

该模式不仅可用于树形结构，只要希望获得一个灵活的对象，其属性可以从构造器动态设置就可以用这种方法。

