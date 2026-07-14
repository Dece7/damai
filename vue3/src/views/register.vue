<template>
  <div class="app-container">
    <Header></Header>
    <div class="main">
      <div class="main-center">
        <el-form ref="registerRef" :model="registerForm" :rules="registerRules" label-width="100px">
          <el-form-item label="手机号码" prop="mobile">
            <el-input v-model="registerForm.mobile" maxlength="11" placeholder="请输入手机号码">
              <template #prepend>
                <el-select v-model="select" style="width: 145px">
                  <el-option label="中国大陆 +86" value="1"/>
                </el-select>
              </template>
            </el-input>
          </el-form-item>
          <el-form-item label="输入密码" prop="password">
            <el-input
                v-model="registerForm.password"
                type="password"
                placeholder="请输入密码"
                show-password
            />
          </el-form-item>
          <el-form-item label="确认密码" prop="confirmPassword">
            <el-input
                v-model="registerForm.confirmPassword"
                type="password"
                placeholder="请再次输入密码"
                show-password
            />
          </el-form-item>
          <el-form-item :style="chkStyle">
            <el-checkbox v-model="checkBox" @change="boxChange"/>
            <span class="chx">{{ agreeOpt }}</span>
          </el-form-item>
          <el-form-item>
            <el-button
                type="primary"
                class="btn"
                @click.prevent="handleAgreeLogin"
            >
              同意并注册
            </el-button>
          </el-form-item>
        </el-form>
      </div>
    </div>
    <Verify
        mode="pop"
        :captchaType="captchaType"
        :imgSize="{width:'400px',height:'200px'}"
        ref="verify"
        @update:value="handleValueFromChild"

    ></Verify>
    <Footer></Footer>
  </div>
</template>

<script setup>
import Header from '@/components/header/index'
import Footer from '@/components/footer/index'
import Verify from '@/components/verifition/Verify'
import {ref, reactive} from 'vue'
import {isCaptcha, register} from '@/api/login'
import {getCurrentInstance} from 'vue'
import {ElMessage} from 'element-plus'
import {useRouter} from 'vue-router'
import $bus from '../utils/bus'
import CryptoJS from 'crypto-js'
import {aesEncrypt} from "../components/verifition/utils/ase";

const {proxy} = getCurrentInstance();
const router = useRouter();

const code = ref('86')
const select = ref('1')
const agreeOpt = ref('我已阅读接受《大麦会员服务协议》《隐私权政策》《订票服务条款》并同意自动注册成为会员')
const checkBox = ref(false)
const chkStyle = ref({})
const registerForm = ref({
  password: '',
  confirmPassword: '',
  captchaId: '',
  mobile: ''
})
//手机号校验
const validatePhone = (rule, value, callback) => {
  const reg = /^1[3-9]\d{9}$/;
  if (!value) {
    return callback(new Error('手机号码不能为空'));
  } else if (!reg.test(value)) {
    return callback(new Error('请输入正确的手机号码'));
  } else {
    callback();
  }
};
//密码校验
const equalToPassword = (rule, value, callback) => {
  if (registerForm.value.password !== value) {
    callback(new Error("两次输入的密码不一致"));
  } else {
    callback();
  }
};
const registerRules = reactive({
  mobile: [{required: true, trigger: "blur", validator: validatePhone}],
  password: [{
    required: true,
    pattern: /^(?![\d]+$)(?![a-zA-Z]+$)(?![^\da-zA-Z]+$)([^\u4e00-\u9fa5\s]){6,20}$/,
    message: '6-20位英文字母、数字或者符号（除空格），且字母、数字和标点符号至少包含两种',
    trigger: ['blur', 'focus']
  }],
  confirmPassword: [
    {required: true, trigger: "blur", message: "请再次输入您的密码"},
    {required: true, validator: equalToPassword, trigger: "blur"}
  ],
});


/**检查是否需要验证码：如果true需要验证码，如果是false就不需要验证码
 * 获取验证码id，注册用
 */
function handleAgreeLogin() {
  isCaptcha().then(response => {
    let {verifyCaptcha, captchaId} = response.data
    if (verifyCaptcha == false) {
      //如果是false直接登录，如果是true验证码
      registerForm.value.captchaId = captchaId
      //此处勾选协议接口为传参，前端进行校验
      if (checkBox.value == false) {
        chkStyle.value = {color: 'red'}
      } else {
        chkStyle.value = {color: '#666666'}

        registerInfo()
      }
    } else {
      if (checkBox.value == false) {
        chkStyle.value = {color: 'red'}
      } else {
        chkStyle.value = {color: '#666666'}
        proxy.$refs.registerRef.validate(valid => {
          if (valid) {
            onShow('blockPuzzle')
          }
        })
      }

    }
  })
}

function boxChange(val) {
  if (val == true) {
    chkStyle.value = {color: '#666666'}
  }
}

function registerInfo() {
  proxy.$refs.registerRef.validate(valid => {
    if (valid) {
      //去掉86区号
      //registerForm.value.mobile = code.value + registerForm.value.mobile
      register(registerForm.value).then(response => {
        if ( response.code == '0') {
          ElMessage({
            message: '注册成功',
            type: 'success',
          })
          router.push({path: "./login"});
          reset()

        }
      }).catch(() => {

      });
    }

  })

}


function reset() {
  registerForm.value = {
    password: '',
    confirmPassword: '',
    captchaId: '',
    mobile: ''
  }
}

//认证
const verify = ref(null)
const captchaType = ref('')
//滑块为例
//
const onShow = (type) => {
  captchaType.value = type
  verify.value.show()
}
let secretKey = ref('')
let captchaVerify= ref('')


$bus.on('res', (data) => {
  captchaVerify.value = data.repData.captchaVerification
})


//此处是关闭验证码后，提示注册成功跳转到登录页面
function handleValueFromChild(value) {
  if (value == '关闭') {
    registerForm.value.captchaVerification =captchaVerify.value
    isCaptcha().then(res => {
      let {captchaId} = res.data
      registerForm.value.captchaId = captchaId
      //去掉86区号
      //registerForm.value.mobile = code.value + registerForm.value.mobile
      register(registerForm.value).then(response => {
        if (response.code == '0'&&response.data === true) {
          ElMessage({
            message: '注册成功',
            type: 'success',
          })
          router.push({path: "./login"});
          reset()
        }else{
          ElMessage({
            message:response.message,
            type: 'error',
          })
        }
      }).catch(() => {

      });
    })
  }
}
</script>

<style scoped lang="scss">
.app-container {
  width: 100%;
  min-height: 100vh;
  background: #f5f5f5;

  .main {
    padding: 40px 0 60px;

    .main-center {
      width: 600px;
      background: #ffffff;
      border-radius: 12px;
      box-shadow: 0 4px 20px rgba(0, 0, 0, 0.08);
      padding: 40px 60px;
      margin: 0 auto;

      .el-form {
        color: #666;

        .el-input {
          height: 42px;
        }

        .el-select {
          .el-input {
            height: 42px;
          }
        }

        .chx {
          font-size: 13px;
          color: #999;
          line-height: 1.5;
        }
      }
    }
  }
}

:deep(.el-input-group--prepend .el-input-group__prepend .el-select .el-input .el-input__wrapper) {
  height: 42px !important;
}

:deep(.el-form-item) {
  margin-bottom: 24px;
}

:deep(.el-form-item:last-child) {
  margin-bottom: 0;
}

:deep(.el-form-item__content) {
  flex-wrap: nowrap;
}

:deep(.el-form-item__label) {
  font-size: 14px;
  color: #333;
}

.btn {
  background: rgba(255, 55, 29, 0.85);
  border: none;
  border-radius: 8px;
  font-size: 16px;
  height: 44px;
  color: #fff;
  width: 100%;
  cursor: pointer;
  transition: all 0.3s ease;

  &:hover {
    background: rgba(255, 55, 29, 1);
    transform: translateY(-1px);
    box-shadow: 0 4px 12px rgba(255, 55, 29, 0.3);
  }
}
</style>
