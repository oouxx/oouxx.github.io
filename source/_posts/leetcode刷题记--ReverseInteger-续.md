---
title: leetcode刷题记--ReverseInteger-续
date: 2018-10-24 08:30:00
tags:
	- Python
	- algorithm
categories: 
	- Python
	- leetcode

---
```Python
class Solution:
    def reverse(self, x):
		# 取出符号位
        sign = -1 if x<0 else 1
		# 把x化为正数	
        x*=sign
        rev = 0
        while not x==0:
            rev*=10
            rev += x%10
            x = x//10
        if not -2**31<=rev<=2**31-1:
            return 0
        return rev*sign

```

上面代码是在leetcode官网讨论区随便选的一个解决方案，感觉还是挺新颖的。

对比代码之后我的不足之处在于：

1. 对于数字每一位的截取采用数学方法而非采用转化为可迭代对象一次迭代,前者无论从时间复杂度还是空间复杂度都要明显要优于后者。
2. 对于符号位的处理要灵活运用"-1","1"。

上一篇文章代码的简化版本为
```Python
def ReverseInteger(num):
	if num < 0:
		num = -1*num
		num = -1*int(str(num)[::-1])
	else:
		num = int(str(num)[::-1])
	if num <= -2**31 or num >= 2**31-1:
        return 0
	return num
```
今天刚学会了**逆序切片**一下子大大简化了代码呢

