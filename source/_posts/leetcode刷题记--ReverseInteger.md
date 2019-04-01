---
title: leetcode刷题记--ReverseInteger
date: 2018-10-23 22:10:36
tags: [algorithm,Python]
categories: [Python,leetcode]

---
Given a 32-bit signed integer, reverse digits of an integer

Example 1:
```
Input: 123
Output: 321
```

Example 2:
```
Input: -123
Output: -321
```

Example 3:
```
Input: 120
Output: 21
```

Note:

Assume we are dealing with an environment which could only store integers within the 32-bit signed integer range: [−2\*\*31,  2\*\*31 − 1]. For the purpose of this problem, assume that your function returns 0 when the reversed integer overflows.

<!-- more-->

My Answer:
```Python
    def reverse(self, x):
        """
        :type x: int
        :rtype: int
        """
        try:
            from functools import reduce
        except:
            print("你确定你用的是Python3？")
        if x <= -2**31 or x >= 2**31-1:
            return 0

        if x < 0:                
            list = [i for i in str(x)][1:]
            list = [int(i) for i in list]
            list.reverse()
            x = reduce(lambda x,y: 10*x+y ,list)
            if x <= -2**31 or x >= 2**31-1:
                return 0
            return -x

        else:
            list = [int(i) for i in str(x)]
            list.reverse()
            x = reduce(lambda x,y: 10*x+y ,list)
            if x <= -2**31 or x >= 2**31-1:
                return 0
            return x
```

上面的代码是我没看大神们的代码自己写的，思路我就不说了，太渣了。看完大神们的代码感觉自己就是个渣渣。WTF？！

有一点需要注意的是对于输入，输出的x要进行一波验证是否在[-2\*\*31,2\*\*31-1]区间内。一开始没写输出的验证，测试的时候总是通不过，现在虽然没进行过测试驱动的开发，但是这一次也让我意识到了测试代码的重要性。
