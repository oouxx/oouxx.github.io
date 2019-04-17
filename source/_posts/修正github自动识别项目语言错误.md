---
title: 修正github自动识别项目语言错误
date: 2019-04-17 10:49:34
tags:
- github
categories:
- 杂谈
---
我在GitHub上提交了一个Python爬虫项目，我将爬取的结果保存为`.html` 文件，其他全部为Python文件，然而GitHub将我的项目语言自动识别为HTML语言，这真的让人很不爽诶。
网上查了下解决办法，现在来分享一下：
### 第一步：
Create New File ，文件名为`.gitattributes`
### 第二步：
里面写下如下内容：
```
*.py linguist-language=python
*.html linguist-language=python
```
### 第三步
保存提交
