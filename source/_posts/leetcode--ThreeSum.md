---
title: leetcode--ThreeSum.md
date: 2018-11-17 18:38:54
tags:
    - Python
    - algorithm
categories:
- leetcode
---
Given an array nums of n integers, are there elements a, b, c in nums such that a + b + c = 0? Find all unique triplets in the array which gives the sum of zero.

Note:

The solution set must not contain duplicate triplets.

Example:

Given array nums = [-1, 0, 1, 2, -1, -4],

A solution set is:
[
  [-1, 0, 1],
  [-1, -1, 2]
]

```Python
#!/bin/env python
#-*-coding: utf-8 -*-

def ThreeSum(nums):
    """
    :type nums: List[int]
    :rtype: List[List[int]]
    """
    length = nums.__len__()
    rlist = []
    nums.sort()
    for i in range(0,length-2):
        for j in range(i+1,length-1):
            for k in range(j+1,length):
                if (nums[i]<0 and nums[j]<0 and nums[k]<0) or (nums[i]>0 and nums[j]>0 and nums[k]>0):
                    continue
                if nums[i]+nums[j]+nums[k] == 0:
                    list = [nums[i],nums[j], nums[k]]
                    if list in rlist:
                        continue
                    rlist.append(list)
    return rlist

def threeSum(nums):
    res = []
    # 对list进行排序能为后面带来很多方便
    # 1. 去重的时候不用排序
    # 2. 返回结果值的时候不用排序
    # 3. 相邻位置上数字可能相等,可以直接跳过
    nums.sort()
    for i in range(len(nums)-2):
        # 从第二个数开始,紧挨着的两个数相等直接跳过对这个数的判断,仅仅判断一个
        if i > 0 and nums[i] == nums[i-1]:
            continue
        # l 为紧挨着i的后面一个数字(必然大于i), r为固定的最后一个数的索引值
        l, r = i+1, len(nums)-1
        # 当l==r即只剩下两个数的时候停止循环,因为此时无法构成三个数之和
        while l < r:
            s = nums[i] + nums[l] + nums[r]
            # s<0 代表l还不够大,向右移动一位(假设这个数组从左到右由小到大排列)
            if s < 0:
                l +=1 
            # 否则r向左移动一位
            elif s > 0:
                r -= 1
            else:
                res.append((nums[i], nums[l], nums[r]))
                # 处理和i类似的情况,遇到相等直接跳过
                while l < r and nums[l] == nums[l+1]:
                    l += 1
                while l < r and nums[r] == nums[r-1]:
                    r -= 1
                l += 1; r -= 1
    return res 



if __name__ == "__main__":
    list = [8,5,3,9,12,-9,8,-9,13,-10,-14,-13,5,-15,-4,2,8,-11,-6,12,9,-15,13,11,13,13,6,-12,-15,-4,-6,0,-14,5,-14,5,3,2,4,2,7,5,4,-10,-3,7,7,-9,4,-14,10,-2,-13,8,-6,7,-1,7,11,-9,-12,-10,6,12,10,7,2,-9,-6,13,8,9,3,-11,14,-14,11,-2,14,0,-1,1,6,-7,-5,7,-14,9,0,4,7,-5,1,-2,14,-3,12,-6,-5,14,-8,-12,0,3,-8,-1]
    ret = threeSum(list)
    print(ret)
```
上面的是我的解决办法,我想这应该是像我这样笨的人的解决办法,没能通过leetcode的测试(250/313)......下面的是大佬的代码,附上了个人的分析.

