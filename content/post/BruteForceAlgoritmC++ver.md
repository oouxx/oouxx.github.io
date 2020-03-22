---
title: BF算法C++版
date: 2018-12-04T10:25:50+08:00
tags: ['C++', 'algorithm', '字符串匹配']
categories: ['C++']
---
### 这是字符串暴力匹配算法的C_++版本
暴力匹配的思路:使用穷举的方法,目标串和模式串进行匹配,一旦失配,目标串指针(或者说数组索引值)回退到下一位,模式串从头开始

#### SqString的定义
```C++
typedef struct
{
  char data[MaxSize];
  int length;
}SqString;
```
#### 具体的匹配过程
```C++
int BF(SqString s, SqString t)   //SqString表示字符串在内存中以顺序结构存储
{
  int i=0,j=0;
  while(i<s.length && j<t.length) 
  {
    if(s.data[i] == t.data[i])
    {
      i++;j++;
    } 
    else
    {
      i = i+j-1;j=0;  //如果失配,i回退,子串从头开始
    }
  }
  if(j>=t.length)    //j超界,表示t是s的子串
  {
    return(i-t.length);
  }
  else
  {
    return -1;
  }
}

```

#### 参考
参考自:<<数据结构教程第五版>>李春葆

