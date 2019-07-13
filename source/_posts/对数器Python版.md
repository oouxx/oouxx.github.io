---
title: 对数器Python版
date: 2019-05-22 18:38:17
tags: [Python, 对数器]
categories: [Python]
---
最近跟左神学算法然后才听说有对数器这么个东西，特地实现了个Python版跟大家一起分享

```Python
import random


# 交换两个值
def swap(l, arg1, arg2):
    l[arg1], l[arg2] = l[arg2], l[arg1]
    return arg1, arg2


def comparator(l):
    l = sorted(l)
    return l


def generate_random_list(max_size, max_value):
    my_list = []
    random_size = random.randint(1, max_size)
    for i in range(random_size):
        my_list.append(random.randint(-max_value, max_value))
    return my_list


def copy_list(l):
    return l[:]


def print_list(l):
    for i in range(len(l)):
        print(l[i], end=' ')


def main():
    max_size = 20
    max_value = 100
    my_list = generate_random_list(max_size, max_value)
    print_list(my_list)
    ordered_list = comparator(my_list)
    print('\n')
    print_list(ordered_list)


if __name__ == '__main__':
    main()
```
