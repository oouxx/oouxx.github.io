---
title: numpy学习笔记
date: 2018-12-04T21:59:55+08:00
tags: ['机器学习', 'numpy']
categories: ['机器学习', 'numpy']
---
### numpy介绍
NumPy是使用Python进行科学计算的基础包。它包含其他内容：
- 一个强大的N维数组对象
- 复杂的（广播）功能
- 用于集成C / C ++和Fortran代码的工具
- 有用的线性代数，傅立叶变换和随机数功能
### numpy的安装
```shell
$ pip/pip3 install numpy
```
### numpy使用
```Python
import numpy as np
```
### 属性

- shape:行数和列数
- size:元素个数
- ndim:维度

### 列表转化为矩阵
```Python
array = np.array([[1,2,3],[2,3,4]])  # 列表转化为矩阵
print(array)
"""
array([[1, 2, 3],
       [2, 3, 4]])
"""
```
### 矩阵的创建
```python
a = np.array([2,3,4], dtype=np.int) # dtype表示数值类型,默认为int64
a = np.zeros((3,4)) # 全为0
a = np.ones((3,4), dtype=np.int16) # 全为1
a = np.empty((3,4)) # 生成非常接近于零的数字
a = np.arange(begin,end,step) #创建指定范围的数据,类似于python中的range
a = np.linespace(1,10,20)  #生成线段
```
### numpy运算
```python
c = a+b # 矩阵的加法
c = a-b # 矩阵的减法
c = a*b # 对应元素相乘(而非矩阵的乘法)
c = a**n # 矩阵的乘方
c = np.sin(a) # 矩阵的三角函数运算
print(b<3) # 矩阵做逻辑判断,output:array([True, False, True,...]) 
```

```python
c_dot = np.dot(a, b) # 矩阵乘法运算
c_dot = a.dot(b)   # 矩阵乘法运算
np.sum(a, axis=0) # 求和,axis参数指定维度,当axis为1的时候,将会以行作为查找单元,为0的时候以列作为查找单元
np.min(a, axis=1) # 求最小值
np.max(a, axis=0) # 求最大值
```

```python
np.argmin(a) # 求最小值的索引值
np.argmax(a)  # 求最大值的索引值
np.mean(a) # 求均值
np.average(a) # 求均值
np.median(a)  # 求中位数
np.cumsum(a) # 类似matlab累加函数(每项为前n项和)

"""
a = np.array([1,2],
             [3,4],
             [5,6])
print(np.cumsum(a))
array([1,3,6,10,15,21])
"""

np.diff(a) # 做累差运算
np.nonzero(a) # 这个函数将所有非零元素的行与列坐标分割开，重构成两个分别关于行和列的矩阵
"""
a = np.array([[1,2],[0,0]])
a.nonzero()
(array([0, 0]), array([0, 1]))
"""
```

```python
np.transpose(a ) # 矩阵转置
a.T              # 矩阵转置
np.sort(a)       # 矩阵排序,支持axis参数
np.clip(a,5,9)   # 这个函数的格式是clip(Array,Array_min,Array_max)，顾名思义，Array指的是将要被执行用的矩阵，而后面的最小值最大值则用于让函数判断矩阵中元素是否有比最小值小的或者比最大值大的元素，并将这些指定的元素转换为最小值或者最大值

```
### numpy矩阵索引

```Python
"""
for rowOfA in a: # 默认按行迭代
    print(rowOfA)
for colOfA in a.T: 
    print(colOfA)
"""
np.flatten(a) # 将多维数组展开成一行的数列
a.flat        # 生成一个迭代器numpy.flatiter 

```
### numpy矩阵合并

```
A = np.array([1,1,1])
B = np.array([2,2,2])
np.vstack((A,B))  # vertical stack 竖直合并
np.hstack((A,B))  # horizontal stack 水平合并
print(A[np.newaxis,:]) #横向增加一个维度
# [[1 1 1]]

print(A[np.newaxis,:].shape)
# (1,3)

print(A[:,np.newaxis])
"""
[[1]
[1]
[1]]
"""

print(A[:,np.newaxis].shape)
# (3,1)
np.concatenate((A,B,A,B)) # concatenate()类似于vstack(),hstack()可以用axis指定维度
np.split(A, 2, axis=1) # 纵向分割为两列
np.split(A, 3, axis=0) # 横向分割为三行
np.array_split(A,2, axis=1) # 纵向不均等分割
np.hsplit(A, 3)      # 水平分割
np.vsplit(A, 2)      # 竖直分割
```
### numpy的copy
numpy中默认的赋值操作室友关联性的,即改变最初的值,后面的值全部都会改变.如果要去除关联性要进行深拷贝
```
a = np.array([1,2,3])
b = a.copy()  # deep copy
```


参考:[周莫烦机器学习](https://morvanzhou.github.io)



