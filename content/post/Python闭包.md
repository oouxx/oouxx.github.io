---
title: Python闭包
date: 2019-05-21T01:22:40+08:00
tags: ['Python', '闭包']
categories: ['Python']
---

闭包(closure)是函数式编程的重要的语法结构。闭包也是一种组织代码的结构，它同样提高了代码的可重复使用性。

当一个内嵌函数引用其外部作作用域的变量,我们就会得到一个闭包. 总结一下,创建一个闭包必须满足以下几点:

1. 必须有一个内嵌函数
2. 内嵌函数必须引用外部函数中的变量
3. 外部函数的返回值必须是内嵌函数

下面一段代码帮助来理解闭包

这是一个标准的闭包

```Python
def adder(x):
    def wrapper(y):
        print(x + y)

    return wrapper


if __name__ == '__main__':
    my_adder = adder(5)
    my_adder(6)  # output: 11
    my_adder(7)  # output: 12

```

Python也提供了访问被闭包封装的变量的接口,可以通过__closure__(一个元组)获取`cell`对象，再通过`cell_contents`获取闭包内容，值得注意的是`cell_contents`是不可写的，不能随意进行修改.

```Python
def adder(x):
    def wrapper(y):
        print(x + y)

    return wrapper


if __name__ == '__main__':
    my_adder = adder(5)
    my_adder(6)  # output: 11
    my_adder(7)  # output: 12
    cell_contents = my_adder.__closure__[0].cell_contents
    print(cell_contents) # output: 5
    # my_adder.__closure__[0].cell_contents = 6
    # exception: attribute 'cell_contents' of 'cell‘ is not writable
```

当你尝试在wrapper内部对闭包的变量进行修改的时候也会报错

```Python
def adder(x):
    def wrapper(y):
        # x = 1
        # x = x + 1
        print(x + y)

    return wrapper


if __name__ == '__main__':
    my_adder = adder(5)
    my_adder(6)  # output: 11
    my_adder(7)  # output: 12
```

例如你想对x进行赋值，那么`my_adder(6)`会正常运行，`my_adder(7)`报错，`x = x + 1`这也算是对闭包变量的保护吧.