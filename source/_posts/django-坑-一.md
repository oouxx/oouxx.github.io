---
title: django天坑总结(一)
date: 2018-10-18 22:39:13
tags: 
	- django
categories: 
	- Python
	- django
---

### user表上的外键要允许设置为空
最近一段时间一直在学Python的一个重量级Web框架django，接下来的几篇博文中会总结一下我遇到的坑。

看到标题的话应该很好理解，user表上的外键要设置为空，我先来粘贴一下我的代码

``` python
class UserProfile(AbstractUser):
    """
    用户
    """
    category = (
        (0,"无分类"),
        (1,"局长"),
        (2, "副局长"),
        (3, "科长"),
        (4, "副科长"),
    )
    fun = (
        (0,"无分类" ),
        (1, "绩效办管理员"),
        (2, "被考核对象"),
        (3, "驾驶舱管理者"),
    )
    basic_info = models.OneToOneField(BasicInfo, null=True, blank=True, verbose_name="用户基本信息", on_delete=models.CASCADE)
    position = models.IntegerField(choices=category, verbose_name="职位", default=0)
    funct = models.IntegerField(choices=fun, verbose_name="职能", default=0)
    # 设置related_name 为lower_downs可以通过上级找到他的下级
    higher_ups = models.ForeignKey("self", verbose_name="上级", null=True, blank=True, related_name="lower_downs", on_delete=models.CASCADE)

    class Meta:
        verbose_name = "用户信息"
        verbose_name_plural = verbose_name

    def __unicode__(self):
      return self.username

```
上面代码可以看到这个用户信息表继承了`AbstracterUser`,然后我将另一些牵扯到个人隐私的信息放在了另一张表`BasicInfo`里作为在这张表的外键，当然是一对一的关系。当我用`manage.py`，`createsuperuser`时出现了问题`FOREIGN KEY constraint failed`,然后我就把所有牵扯到外键的model全都检查了一遍，始终找不到问题，然后从图书馆会宿舍的路上突然想到在创建用户的时候还没有`BasicInfo`,必须得设置为可以为空，否则的话可能不满足约束条件。

其实我调bug的过程远比我描述的曲折，因为我刚开始遇到是另一个bug,`not null constraint failed`, 这个我想有可能是没设置默认值造成的（但是我以前写的时候也没写过默认值啊！！！）， 就把默认值全都给设置了，然后这个错误就消失了，后来才遇到`FOREIGN KEY constraint failed`。




