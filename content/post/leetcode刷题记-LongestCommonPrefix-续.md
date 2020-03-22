---
title: leetcode刷题记--LongestCommonPrefix-续
date: 2018-10-26T21:36:42+08:00
tags: ['Python', 'algorithm']
categories: ['leetcode']
---

### 解法剖析
来自[leetcode](https://leetcode.com/problems/longest-common-prefix/solution/)

具体的内容我就不复制粘贴了，只讲一下我对每种解法的理解

### Horizontal scanning
```Java
 public String longestCommonPrefix(String[] strs) {
    if (strs.length == 0) return "";
    String prefix = strs[0];
    for (int i = 1; i < strs.length; i++)
        while (strs[i].indexOf(prefix) != 0) {
            prefix = prefix.substring(0, prefix.length() - 1);
            if (prefix.isEmpty()) return "";
        }
    return prefix;
}
```
这种方法之所以能够如此简洁得益于**indexOf()**方法

- public int indexOf(int ch): 返回指定字符在字符串中第一次出现处的索引，如果此字符串中没有这样的字符，则返回 -1。

- public int indexOf(int ch, int fromIndex): 返回从 fromIndex 位置开始查找指定字符在字符串中第一次出现处的索引，如果此字符串中没有这样的字符，则返回 -1。

- int indexOf(String str): 返回指定字符在字符串中第一次出现处的索引，如果此字符串中没有这样的字符，则返回 -1。

- int indexOf(String str, int fromIndex): 返回从 fromIndex 位置开始查找指定字符在字符串中第一次出现处的索引，如果此字符串中没有这样的字符，则返回 -1。

indexOf()方法能够返回指定字符在字符串中第一次出现的位置，即出现了就为0，未出现就为-1。
<!-- more -->

#### 解析

```
// 当在strs[i]后面字符串中找不到公共子串时
while (strs[i].indexOf(prefix) != 0) {
	// prefix 长度减一位，前面的比较仍然是成立的，因为减过长度的字符串是原来字符串的子集
    prefix = prefix.substring(0, prefix.length() - 1);
	//　prefix为空返回""
    if (prefix.isEmpty()) return "";
}
```

### Vertical scanning
```Java
public String longestCommonPrefix(String[] strs) {
    if (strs == null || strs.length == 0) return "";
    for (int i = 0; i < strs[0].length() ; i++){
        char c = strs[0].charAt(i);
        for (int j = 1; j < strs.length; j ++) {
            if (i == strs[j].length() || strs[j].charAt(i) != c)
                return strs[0].substring(0, i);
        }
    }
    return strs[0];
}
```

#### 解析
这个解题的思路与我用Python实现的解题思路是一致的，只不过java提供的处理字符串的方法是真的好用实现起来也很简单。


后面的方法可以作为了解。
