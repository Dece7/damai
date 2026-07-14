<template>
  <div class="footer">
    <div class="footer-sec">
      <ul class="footer-links">
        <li><a href="https://github.com/Dece7/damai" target="_blank">GitHub</a></li>
      </ul>
      <div class="footer-rt">
        <div class="footer-details-info">
          <p>大麦票务系统 - 学习项目</p>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
</script>

<style scoped lang="scss">
.footer {
  background-color: #f8f8f8;
  width: 100%;
  height: 150px;

  .footer-sec {
    width: 1200px;
    margin: 20px auto 0 auto;

    .footer-links {
      display: flex;
      align-items: center;
      justify-content: center;
      padding: 36px 0;
      text-align: center;
      list-style: none;
      font-size: 13px;
      color: #111;

      li {
        margin: 0 12px;
        
        a {
          color: #666;
          text-decoration: none;
          
          &:hover {
            color: #ff371d;
          }
        }
      }
    }

    .footer-rt {
      padding-bottom: 10px;

      .footer-details-info {
        width: 1200px;
        text-align: center;
        font-size: 14px;
        color: #999;
        margin-top: 10px;
      }
    }
  }
}
</style>