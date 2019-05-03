---
title: KMP算法C++版
date: 2018-12-04 10:25:50
tags:
  - C++
  - algorithm
  - 字符串匹配
categories:
  - C++
---
### KMP算法C++版本
KMP算法基本思路:构造next[]减少回溯
#### next的构造
```C++
void GetNext(SqString t, int next[]){
  int j,k;
  j=0;k=-1;
  next[0] = -1;
  while(j < t.length-1){
    if(k==-1 || t.data[j]==t.data[k]){
      j++;k++;
      next[i]=k;
    }
    else k = next[k]; 
  }
} 
```
#### 分析
假设t=abcabba, condition = (k==-1 || t.data[j]==t.data[k])

|condition|j   |k   | next[]    |
|---------|----|----|-----------|
|         |0   |-1  |next[0]==-1|
| k== -1  |1   |0    |next[1]==0|
|false    |    |k=next[0]=-1|   |
|k==-1    |2   |0    |next[2]==0|
|false    |    |k=next[0]=-1|   |
|k==-1    |3   |0    |next[3]==0|
|t.data[j] == t.data[k]|4  |1  |next[4]==1|
|t.data[j] == t.data[k]|5  |2  |next[5]==2|
|false    |    |k=next[2]=0|    |
|false    |    |k=-1   |        |
|k==-1    |6   |0      |next[6]=0|
|t.data[j] == t.data[k]|7 |1    |next[7]=1|

没办法人笨就只能用最笨的办法分析了.人在思考构建next[]数组的时候思维过程很简单,只需找到指定字符前面从前往后和从后往前相同的子串,那么子串的长度就是字符所在next[]数组的值
但是计算机很笨,他没办法这样做.所以要编一个这么复杂的程序让计算机理解该怎么做.所以计算机永远不能超过人类啊.

#### KMP算法
```C++
int KMPIndex(SqString s, SqString t){
  int next[MaxSize],i=0,j=0;
  GetNext(t,next);
  while(i<s.length && j<t.length){
    if(j==-1 || s.data[i] == t.data[j]){
      i++;
      j++;
    }
    else j = next[j];
  }
  if(j>=t.length)
    return (i-t.length);
  else
    return(-1);
}
```
#### 发现
通过比较发现next数组的构造其实跟BF算法暴力匹配没什么区别,其实就是多了`next[j]=k`,填充next数组值.

由此看来KMP算法的核心思想:将前面匹配得到的信息保存在next[]中从而减少回溯.

#### 总结
对于长的字符串来说适合用KMP算法,但是对于短的字符串BF算法貌似更合理一点.既然大家都要进行暴力匹配为何要多进行那么多操作呢?
