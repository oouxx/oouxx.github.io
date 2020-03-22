---
title: leetcode刷题记--TwoSum
date: 2018-10-22T09:23:40+08:00

tags: []
categories: ['leetcode']
---
Given an array of integers, return indices of the two numbers such that they add up to a specific target.

You may assume that each input would have exactly one solution, and you may not use the same element twice.

Example:
```
Given nums = [2, 7, 11, 15], target = 9,

Because nums[0] + nums[1] = 2 + 7 = 9,
return [0, 1].
```

My answer:
```Python
class Solution:
    def twoSum(self, nums, target):
        """
        :type nums: List[int]
        :type target: int
        :rtype: List[int]
        """
        length = len(nums)
        for i in range(0,length):
            for j in range(i+1,length):
                if nums[i]+nums[j] == target:
                    return [i,j]

```

