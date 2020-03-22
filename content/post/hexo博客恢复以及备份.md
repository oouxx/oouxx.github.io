---
title: hexo博客创建以及备份
date: 2019-04-02T05:30:34+08:00
tags: ['hexo']
categories: []
---
### hexo博客创建以及备份
首先确保本地环境已经安装`node`。
#### 创建
1. 环境安装
```
npm -g install hexo-cli 
npm -g install hexo-deployer-git
npm install
```
2. 初始化博客
```
hexo init myblog
```
3. 修改配置文件
```
cd myblog
vim _config.yml # 详细参考官方文档
```
4. 下载主题并解压的博客根目录下的`themes`目录(以`next`主题为例)
```
cd themes/
git clone https://github.com/theme-next/hexo-theme-next.git
mv hexo-theme-next-master next
cd next
vim _config.yml # 详细参考官方文档
```
#### 备份
确保目前目录在博客的根目录
1. 初始化git仓库
```
git init
```
git会自动创建合适的`.gitignore`文件,所以不必担心啦，如果你想额外的添加也是可以的哦。
```
.DS_Store
Thumbs.db
b.json
*.log
node_modules/
public/
deploy*/
```
2. 设置远程仓库
```
git remote add origin https://github.com/username/repository_name  
```
3. 查看本地文件的状态
```
git status
```
4. 推送本地分支
```
git add *
git commit -m "backup"
git push origin local_branch:remote_branch
```
