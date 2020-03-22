---
title: Python中的拷贝
date: 2019-05-21T04:38:01+08:00
tags: ['Python', '深浅拷贝']
categories: ['Python']
---

```Python
import copy
a = [1, 2, 3, 4, ['a', 'b']]  #原始对象

b = a  #赋值，传对象的引用
c = copy.copy(a)  #对象拷贝，浅拷贝
d = copy.deepcopy(a)  #对象拷贝，深拷贝

a.append(5)  #修改对象a
a[4].append('c')  #修改对象a中的['a', 'b']数组对象

print 'a = ', a
print 'b = ', b
print 'c = ', c
print 'd = ', d

输出结果：
a =  [1, 2, 3, 4, ['a', 'b', 'c'], 5]
b =  [1, 2, 3, 4, ['a', 'b', 'c'], 5]
c =  [1, 2, 3, 4, ['a', 'b', 'c']]
d =  [1, 2, 3, 4, ['a', 'b']]
```

下面用图来展示一下他们之间的关系

1. 引用赋值

![引用赋值](/images/python_copy/reference_assignment.png)

2. 浅拷贝

![浅拷贝](/images/python_copy/light_copy.png)

3. 深拷贝

![深拷贝](/images/python_copy/deep_copy.png)

> 浅拷贝只拷贝父对象，不拷贝父对象的子对象，深拷贝全都会拷贝