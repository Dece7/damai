# 全栈项目 header 组件修改方案

## 文件位置
D:\damai\vue3\src\components\header\index.vue

## 修改内容

### 1. 在登录按钮旁边添加AI客服按钮

在 `<ul class="loginInfo">` 中添加：

```html
<li @click="openAIChat" v-if="isHasToken">
  <span class="aiChat">AI客服</span>
</li>
```

### 2. 添加 openAIChat 函数

```javascript
// 打开AI客服
function openAIChat() {
  const token = getToken()
  if (token) {
    // 将Token传递给AI项目
    window.open(`http://localhost:8000?token=${token}`)
  } else {
    ElMessage.warning('请先登录')
  }
}
```

### 3. 添加样式

```css
.aiChat {
  cursor: pointer;
  color: #409eff;
}
.aiChat:hover {
  color: #66b1ff;
}
```
