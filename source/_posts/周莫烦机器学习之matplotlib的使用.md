---
title: matplotlib的使用
date: 2018-12-05 21:14:31
tags:
  - linux
  - matplotlib
  - 数据可视化
  - Python
categories:
  - 机器学习
  - matplotlib
---
### 安装
```shell
$ pip3 install matplotlib 
// 在用的时候会报错ModuleNotFoundError: No module named 'tkinter'
$ sudo apt-get install python3-tk
```
### 简单使用
```Python
x = np.linspace(-1, 1, 50)  # 生成线段
y = 2*x+1
plt.figure()  # 定义一个窗口, num=窗口编号, figsize=窗口大小
plt.plot(x, y)  # 画(x, y)2D曲线, color=线段颜色, linewidth=线段宽度, linestyle=线段样式
plt.show()   # 显示图像
```

```Python
plt.xlim((-1,2)) # x坐标轴的范围
plt.ylim((-2,3)) # y坐标轴的范围
plt.xlabel('I am x') # x坐标轴名称
plt.ylabel('I am y') # y坐标轴名称
```
```Python
new_ticks = np.linspace(-1, 2, 5)
print(new_ticks)
plt.xticks(new_ticks)  # 将已有的线段设置为x的刻度
plt.yticks([-2, -1.8, -1, 1.22, 3],[r'$really\ bad$', r'$bad$', r'$normal$', r'$good$', r'$really\ good$'])
plt.show()
```
```Python
ax = plt.gca() # 获取当前坐标轴的信息
ax.spines['right'].set_color('none') # 设置边框
ax.spines['top'].set_color('none')
ax.xaxis.set_ticks_position('bottom') # 使用.xaxis.set_ticks_position设置x坐标刻度数字或名称的位置：bottom.（所有位置：top，bottom，both，default，none）

"""
使用.spines设置边框：x轴；使用.set_position设置边框位置：y=0的位置；（位置所有属性：outward，axes，data）
"""
ax.spines['bottom'].set_position(('data', 0))
ax.yaxis.set_ticks_position('left')
```
### legend图例
```
# set line syles
l1, = plt.plot(x, y1, label='linear line')
l2, = plt.plot(x, y2, color='red', linewidth=1.0, linestyle='--', label='square line')
plt.legend(loc='upper right')  # 自动添加图例
plt.legend(handles=[l1, l2], labels=['up', 'down'],  loc='best') # 为label分配有用的变量,并自动分配最佳图例位置
"""
# loc的参数
 'best' : 0,
 'upper right'  : 1,
 'upper left'   : 2,
 'lower left'   : 3,
 'lower right'  : 4,
 'right'        : 5,
 'center left'  : 6,
 'center right' : 7,
 'lower center' : 8,
 'upper center' : 9,
 'center'       : 10,
"""
```

### annotation 标注
```
# 在某个位置做标注
plt.annotate(s="a simple annotate", xy=(0, 0))
# plt.text用法与annotate基本一致,withdash means  Creates a `~matplotlib.text.TextWithDash` instance instead of a
        `~matplotlib.text.Text` instance.
plt.text(point, point, text, fontdict=None, withdash=False)
```


