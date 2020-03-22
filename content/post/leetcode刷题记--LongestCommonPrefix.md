---
title: leetcode刷题记--LongestCommonPrefix
date: 2018-10-25T15:49:35+08:00
tags: ['Python', 'algorithm']
categories: ['leetcode']
---

Write a function to find the longest common prefix string amongst an array of strings.

If there is no common prefix, return an empty string "".

Example 1:
```
Input: ["flower","flow","flight"]
Output: "fl"
```

Example 2:
```
Input: ["dog","racecar","car"]
Output: ""
Explanation: There is no common prefix among the input strings.
```

Note:
All given inputs are in lowercase letters a-z.
<!-- more -->

My Answer:
```Python
class Solution:
    def longestCommonPrefix(self, strs):
        """
        :type strs: List[str]
        :rtype: str
        """
		# 以下两个if 增加鲁棒性 
        if len(strs)==0:
            return ""
        if len(strs)==1:
            return strs[0]
		# 初值为空
        common_prefix = ""
        min_length = len(strs[0])
        for str in strs:
            length = len(str)
            if length<=min_length:
				# 获取最短长度
                min_length = length
				# 将最短字符串赋值给common_prefix		
                common_prefix = str
		# 设立一个flag用于跳出循环
        flag = False
        for i  in range(min_length):
            for j in range(len(strs)-1):
                # 字母不相等时取第一个字符串的切片
                if strs[j][i] != strs[j+1][i]:
                    common_prefix = strs[0][0:i]
                    flag = True
                    break
            if flag:
                break
        return common_prefix
```

有点严重怀疑leetcode对于难度的设定，这个题难度等级为简单，但是做着还是很吃力。可能我编程水平太菜了！！！

这一题思路上来说挺简单的。二位数组，按列比较，遇到不相等的的时候直接对前面已经比较过得字符进行切片，得到最终结果。
现在真的发现leetcode的testcase好严格,emmmm,以前写代码就是瞎鸡儿凑，能把结果怼出来就行，现在要考虑代码的严密性，鲁棒性，普适性，反正要考虑蛮多的。

明天再写一下续篇总结一下解法





