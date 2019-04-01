---
title: 在vue中集成markdown
date: 2018-11-30 21:20:33
tags:
  - 前端
  - Vue
  - markdown
categories:
  - 前端
  - Vue
---

为了在自己的vue中集成markdown真的试遍了所有的方法,终于成功了,特此发布博文记录一下.

### 我的失败经历

1. 使用vue-markdown + highlightjs 
放弃原因只支持渲染markdown不支持编辑,并且试遍了网上的方法无法实现高亮,具体错误是无法解析"el"

2. 使用vue-markdown-highlight + highlightjs 
这个也是只支持渲染,按照官方的做法也无法实现高亮

3. mavonEditor插件
这个插件可实现markdown的编辑和单独渲染,但是貌似有一些小bug.设置props的`defaultOpen`为`preview`,`preview`无法解析,这就意味着没法单独渲染markdown,所以放弃

4. tui.editor
我的评价只能说,完美且强大
[原版](https://github.com/nhnent/tui.editor)
[vue版](https://github.com/nhnent/toast-ui.vue-editor)

### 使用
#### 安装插件
```shell
$ npm install --save @toast-ui/vue-editor
$ npm install --save highlight.js

```
#### main.js
```JavaScript
import 'codemirror/lib/codemirror.css' // codemirror
import 'tui-editor/dist/tui-editor.css' // editor ui
import 'tui-editor/dist/tui-editor-contents.css' // editor content
import 'highlight.js/styles/github.css' // code block highlight
```

#### viewer.vue
```JavaScirpt
<template>
    <editor v-model="detail"/>
</template>

<script>
import Viewer from '@toast-ui/vue-editor/src/Viewer.vue'
export default {
  name: 'Viewer',
  data (){
    return {
      detail: "",
    }
  },
  components: {
    'editor': Viewer
  }
}
</script>
<style scoped>

</style>

```
#### editor.vue
```JavaScript
<template>
  <div>
    <editor v-model="detail"/>
  </div>
</template>

<script>
import Editor from '@toast-ui/vue-editor/src/Editor.vue'
export default {
  name: 'Editor',
  data (){
    return {
      detail: "",
    }
  },
  components: {
    'editor': Editor
  }

}
</script>
<style scoped>

</style>

```

