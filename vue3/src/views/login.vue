<template>
  <div class="app-container login-page-container">
    <div class="login-header"><Header></Header></div>
    
    <div class="main">
      <div class="login">
        <!-- 左侧装饰区 -->
        <div class="main-left">
          <div class="brand-content">
            <div class="brand-icon">🎫</div>
            <h1>大麦票务系统</h1>
            <p>真实还原高并发抢票场景</p>
            <div class="tech-tags">
              <span>Spring Cloud</span>
              <span>Redis</span>
              <span>Kafka</span>
              <span>Vue 3</span>
            </div>
          </div>
        </div>
        
        <!-- 右侧登录表单 -->
        <div class="main-right">
          <div class="welcome-text">
            <h2>欢迎回来</h2>
            <p>请登录您的账号</p>
          </div>
          
          <el-tabs v-model="activeName" @tab-click="handleClick">
            <el-tab-pane label="密码登录" name="first">
              <el-form ref="loginRef" :model="loginForm" :rules="loginRules" class="login-form">
                <div class="error-tips" v-if="isTips">
                  <el-icon><WarningFilled /></el-icon>
                  {{ tipsContent }}
                </div>
                
                <el-input v-model="userName" placeholder="请输入手机号或邮箱" prop="userName">
                  <template #prepend>
                    <el-icon :size="18"><User /></el-icon>
                  </template>
                </el-input>
                
                <el-input type="password" show-password v-model="loginForm.password" placeholder="请输入密码" prop="password">
                  <template #prepend>
                    <el-icon :size="18"><Lock /></el-icon>
                  </template>
                </el-input>
                
                <el-button :loading="loading" size="large" type="primary" class="btn" @click.prevent="handleLogin">
                  <span v-if="!loading">登 录</span>
                  <span v-else>登录中...</span>
                </el-button>
                
                <div v-show="experienceAccountFlag != 1" class="register" v-if="register">
                  <router-link class="link-type" :to="'/register'">立即注册</router-link>
                </div>
                <div v-show="experienceAccountFlag == 1" class="experienceAccount" v-if="register">
                  <a class="link-type" @click="getExperienceAccount">获取体验账号</a>
                </div>
              </el-form>
            </el-tab-pane>
            
            <el-tab-pane label="短信登录" name="second">功能开发中...</el-tab-pane>
            <el-tab-pane label="扫码登录" name="third">功能开发中...</el-tab-pane>
          </el-tabs>
        </div>
      </div>
    </div>
    
    <Footer></Footer>
  </div>
</template><script setup>
import Header from '@/components/header/index'
import Footer from '@/components/footer/index'
import {isPhoneNumber, isEmailAddress} from '@/utils/index'
import {ref, getCurrentInstance, onMounted, onUnmounted} from 'vue'
import useUserStore from '@/store/modules/user'
import {useRouter} from 'vue-router'

const userStore = useUserStore()
const router = useRouter()
const {proxy} = getCurrentInstance()

const loading = ref(false)
const activeName = ref('first')
const isTips = ref(false)
const tipsContent = ref('')
const userName = ref('')

const loginForm = ref({
  email: '',
  mobile: '',
  password: '',
  code: '0001'
})

const loginRules = ref({})

// 登录页加载时隐藏 body 背景
onMounted(() => {
  document.body.style.backgroundColor = 'transparent'
  document.body.classList.add('login-page')
})

onUnmounted(() => {
  document.body.style.backgroundColor = ''
  document.body.classList.remove('login-page')
})

const handleClick = (tab, event) => {
  console.log(tab, event)
}

const handleLogin = () => {
  proxy.$refs.loginRef.validate(valid => {
    if (valid) {
      if (!userName.value) {
        isTips.value = true
        tipsContent.value = '请输入邮箱或者手机号'
        return
      }
      if (!loginForm.value.password) {
        isTips.value = true
        tipsContent.value = '请输入密码'
        return
      }
      isTips.value = false
      identifyType(userName.value)
      loading.value = true
      userStore.login(loginForm.value).then(() => {
        router.push({path: "/"})
      }).catch(() => {
        loading.value = false
      })
    }
  })
}

function identifyType(value) {
  if (isPhoneNumber(value)) {
    loginForm.value.mobile = value
  } else if (isEmailAddress(value)) {
    loginForm.value.email = value
  }
}
</script>


<style scoped lang="scss">

// 登录页容器覆盖全局样式
.login-page-container {
  width: 100vw !important;
  max-width: 100vw !important;
  height: 100vh;
  margin: 0 !important;
  padding: 0 !important;
}
.login-header {
  :deep(.app-header) {
    background: transparent !important;
    box-shadow: none !important;
  }
}

.app-container {
  width: 100vw;
  height: 100vh;
  position: relative;
  overflow: hidden;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  margin: 0;
  padding: 0;
  
  &::before {
    content: '';
    position: absolute;
    top: -100px;
    right: -100px;
    width: 400px;
    height: 400px;
    border-radius: 50%;
    background: rgba(255, 255, 255, 0.1);
  }
  
  &::after {
    content: '';
    position: absolute;
    bottom: -150px;
    left: -150px;
    width: 500px;
    height: 500px;
    border-radius: 50%;
    background: rgba(255, 255, 255, 0.08);
  }
}

.main {
  width: 100%;
  height: calc(100vh - 72px);
  display: flex;
  align-items: center;
  justify-content: center;
  position: relative;
  z-index: 1;

  .login {
    display: flex;
    width: 900px;
    min-height: 480px;
    background: #fff;
    border-radius: 16px;
    box-shadow: 0 20px 60px rgba(0, 0, 0, 0.2);
    overflow: hidden;

    .main-left {
      flex: 1;
      background: linear-gradient(135deg, #ff371d 0%, #ff6b4a 100%);
      display: flex;
      flex-direction: column;
      align-items: center;
      justify-content: center;
      padding: 40px;
      position: relative;
      overflow: hidden;
      
      &::before {
        content: '';
        position: absolute;
        top: 20%;
        left: -20%;
        width: 200px;
        height: 200px;
        border: 3px solid rgba(255, 255, 255, 0.3);
        border-radius: 50%;
        animation: float 6s ease-in-out infinite;
      }
      
      &::after {
        content: '';
        position: absolute;
        bottom: 15%;
        right: -10%;
        width: 150px;
        height: 150px;
        border: 3px solid rgba(255, 255, 255, 0.2);
        border-radius: 50%;
        animation: float 8s ease-in-out infinite reverse;
      }
      
      .brand-content {
        text-align: center;
        color: #fff;
        z-index: 1;
        
        .brand-icon {
          width: 80px;
          height: 80px;
          background: rgba(255, 255, 255, 0.2);
          border-radius: 20px;
          display: flex;
          align-items: center;
          justify-content: center;
          margin: 0 auto 24px;
          font-size: 36px;
        }
        
        h1 {
          font-size: 28px;
          font-weight: 600;
          margin-bottom: 12px;
        }
        
        p {
          font-size: 16px;
          opacity: 0.9;
          margin-bottom: 32px;
        }
        
        .tech-tags {
          display: flex;
          flex-wrap: wrap;
          gap: 8px;
          justify-content: center;
          
          span {
            padding: 6px 14px;
            background: rgba(255, 255, 255, 0.2);
            border-radius: 20px;
            font-size: 13px;
          }
        }
      }
    }

    .main-right {
      width: 380px;
      padding: 48px 40px;
      display: flex;
      flex-direction: column;
      justify-content: center;
      
      .welcome-text {
        margin-bottom: 32px;
        
        h2 {
          font-size: 24px;
          font-weight: 600;
          color: #1a1a1a;
          margin-bottom: 8px;
        }
        
        p {
          font-size: 14px;
          color: #8a8a8a;
        }
      }
    }
  }
}

@keyframes float {
  0%, 100% { transform: translateY(0); }
  50% { transform: translateY(-20px); }
}

.el-form {
  .el-input {
    margin-bottom: 20px;
    
    :deep(.el-input-group__prepend) {
      width: 48px;
      height: 48px;
      line-height: 48px;
      text-align: center;
      color: #fff;
      background: linear-gradient(135deg, #ff371d 0%, #ff6b4a 100%);
      border: none;
      box-shadow: none;
      border-radius: 8px 0 0 8px;
      
      .el-icon {
        font-size: 18px;
      }
    }
    
    :deep(.el-input__wrapper) {
      height: 48px;
      border-radius: 0 8px 8px 0;
      box-shadow: none;
      border: 1px solid #e8e8e8;
      transition: all 0.2s;
      
      &:hover,
      &.is-focus {
        border-color: #ff371d;
      }
    }
  }
}

.btn {
  width: 100%;
  height: 48px;
  font-size: 16px;
  font-weight: 500;
  border-radius: 8px;
  background: linear-gradient(135deg, #ff371d 0%, #ff6b4a 100%);
  border: none;
  box-shadow: 0 4px 12px rgba(255, 55, 29, 0.3);
  transition: all 0.2s;
  margin-top: 8px;
  
  &:hover {
    transform: translateY(-2px);
    box-shadow: 0 6px 16px rgba(255, 55, 29, 0.4);
  }
  
  &:active {
    transform: translateY(0);
  }
}

.register {
  text-align: right;
  margin-top: 20px;
  
  a {
    font-size: 14px;
    color: #ff371d;
    text-decoration: none;
    
    &:hover {
      text-decoration: underline;
    }
  }
}

.experienceAccount {
  text-align: right;
  margin-top: 16px;
  
  a {
    font-size: 13px;
    color: #8a8a8a;
    cursor: pointer;
    
    &:hover {
      color: #ff371d;
    }
  }
}

.error-tips {
  display: flex;
  align-items: center;
  gap: 8px;
  padding: 12px;
  background: #fff7e6;
  border: 1px solid #ffd591;
  border-radius: 8px;
  color: #faad14;
  font-size: 13px;
  margin-bottom: 20px;
}

:deep(.el-tabs__header) {
  margin-bottom: 24px;
}

:deep(.el-tabs__nav-wrap::after) {
  display: none;
}

:deep(.el-tabs__item) {
  font-size: 15px;
  height: 40px;
  line-height: 40px;
  
  &.is-active {
    color: #ff371d;
    font-weight: 500;
  }
}

:deep(.el-tabs__active-bar) {
  background-color: #ff371d;
}

@media (max-width: 992px) {
  .main .login .main-left {
    display: none;
  }
  
  .main .login .main-right {
    width: 100%;
  }
}

@media (max-width: 768px) {
  .main {
    padding: 16px;
    
    .login {
      width: 100%;
      min-height: auto;
      border-radius: 12px;
    }
  }
}

</style>

