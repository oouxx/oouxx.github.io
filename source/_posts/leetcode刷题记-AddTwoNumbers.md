---
title: leetcode-AddTwoNumbers.md
date: 2018-11-23 20:08:55
tags: 
    - Python
    - algorithm
categories:
    - Python
    - leetcode
---
You are given two non-empty linked lists representing two non-negative integers. The digits are stored in reverse order and each of their nodes contain a single digit. Add the two numbers and return it as a linked list.

You may assume the two numbers do not contain any leading zero, except the number 0 itself.

Example:
```
Input: (2 -> 4 -> 3) + (5 -> 6 -> 4)
Output: 7 -> 0 -> 8
Explanation: 342 + 465 = 807.
```
<!-- more -->

My Answer
```Python
# Definition for singly-linked list.
class ListNode:
    def __init__(self, x=None):
        self.val = x
        self.next = None

class Solution:
    def addTwoNumbers(self, l1, l2):
        """
        :type l1: ListNode
        :type l2: ListNode
        :rtype: ListNode
        """
        list1 = []
        list2 = []
	# 取出链表中的各个元素放到list中并反转list
        while(l1.next is not None)
        {
            l1 = l1.next
            list1.append(l1.val)
        }
        list1.reverse()
        while(l2.next is not None)
        {
            l2 = l2.next
            list2.append(l2.val)
        }
        list2.reverse()

	# 导入我最擅长的高级函数reduce......
        try:
            from functools import reduce
        except:

	num1 = reduce(lambda x,y: 10*x+y,list1)
	num2 = reduce(lambda x,y: 10*x+y,list2)
	num3 = num1 + num2 
	# 相加后的数字转化为字符窜为了能够进行迭代
	string = str(num3)
	# 建立一个头结点
	"""
	头结点是一个value为None的特殊结点,在链表中使用头结点主要是为了方便,他和首结点不同,首节点是头结点紧挨着后面的结点,是真正意义上的第一个结点.
	"""
	head = ListNode()
	# 下面采用头插法,最后返回头结点
	for i in range(string.__len__()):
	    l = ListNode(int(string[i]))
	    l.next = head.next 
	    head.next = l
        return head
```

> 我在上面的代码中改了原题的数据结构,上面代码未经测试,应该是对的,最起码思路是对的.


这是我在评论区找的大佬的代码对比分析一下,学习一下人家是怎么编程的
```Python

class Solution:
    def addTwoNumbers(self, l1, l2):
        """
        :type l1: ListNode
        :type l2: ListNode
        :rtype: ListNode
        """
	# ans 最后的总和
        ans = 0
        unit = 1
	# 若l1为真表达式直接为真,若l1为假,l2为真时表达式为真, 意思就是只要一个为真就可以运行下面的循环体.下面的代码主要考虑的是两个链表不一样长的问题.
        while l1 or l2:
            if l1:
                ans += l1.val * unit
                l1 = l1.next
            if l2:
                ans += l2.val * unit
                l2 = l2.next
	    # 权重倒置(我上面的方法是数字倒置,权重倒置more clever)
            unit *= 10
	# 对头结点做备份
        alpha = cur = ListNode(0)
	# 尾插法 
        for n in reversed(str(ans)):
            cur.next = ListNode(int(n))
            cur = cur.next
    
        return alpha.next
```


