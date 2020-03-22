---
title: django中URLConf的设计哲学
date: 2018-12-12T12:47:56+08:00
tags: ['django']
categories: ['Python', 'django']
---

### django中URLConf的设计哲学
一个干净的,优雅的URL方案是一个高质量Web应用程序的重要细节,django鼓励开发者使用漂亮的URL设计,并且不鼓励把没必要的东西放到URL中.

为了给一个 app 设计 URLs,你需要创建一个 Python 模块叫做 URLconf。这是一
个你的 app 内容目录, 它包含一个简单的 URL 匹配模式与 Python 回调函数间的
映射关系。这有助于解耦 Python 代码和 URLs 。
这是针对上面 Reporter/Article 例子所配置的URLConf大概是下面的样子
```Python
from django.conf.urls import patterns
urlpatterns = patterns('',
    (r'^articles/(\d{4})/$', 'news.views.year_archive'),
    (r'^articles/(\d{4})/(\d{2})/$', 'news.views.month_archive')
    ,
    (r'^articles/(\d{4})/(\d{2})/(\d+)/$', 'news.views.article_d
    etail'),
)
```
如果用户请求一个url,类似"articles/2018/12/10",django会调用`news.views.month_archive_detail
(request, '2018', '12', '10')`,request对象,正则表达式子组所匹配到的信息都会作为参数传递到视图函数或者视图类中.


### 总结
哲学思想一:解耦Python代码和URL配置
哲学思想二:预编译URL配置中的正则表达式,加快匹配速度



