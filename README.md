# 大麦高并发票务系统

真实还原大麦网高并发抢票场景的全栈微服务项目，涵盖用户注册登录、节目浏览、座位选择、订单创建、支付、退款等完整票务流程。

## 技术栈

| 层面 | 技术 | 版本 |
|------|------|------|
| JDK | Java | 17 |
| 后端框架 | Spring Boot | 3.3.0 |
| 微服务 | Spring Cloud Alibaba | 2023.0.1.0 |
| 注册/配置中心 | Nacos | 2.0.3 |
| 网关 | Spring Cloud Gateway | - |
| 限流/熔断 | Sentinel + Hystrix | - |
| ORM | MyBatis-Plus | 3.5.7 |
| 分库分表 | ShardingSphere | 5.3.2 |
| 缓存 | Redis + Redisson | 3.32.0 |
| 消息队列 | Kafka | - |
| 搜索引擎 | Elasticsearch | - |
| 分布式ID | Baidu UID (Snowflake) | - |
| 延迟队列 | Redisson DelayQueue | - |
| 分布式锁 | Redisson Lock | - |
| 布隆过滤器 | Redisson BloomFilter | - |
| 验证码 | 自研拼图/旋转验证码 | - |
| 支付 | 支付宝 SDK | 4.38.197 |
| 接口文档 | Knife4j (OpenAPI 3.0) | 4.3.0 |
| 前端框架 | Vue 3 + Vite | 3.2.45 |
| UI组件库 | Element Plus | 2.2.27 |
| 状态管理 | Pinia | 2.0.22 |

## 项目结构

```
damai/
├── damai-common                     # 公共基础模块
├── damai-spring-cloud-framework     # Spring Cloud 框架封装
├── damai-redis-tool-framework       # Redis 工具框架
├── damai-redisson-framework         # Redisson 分布式工具
├── damai-elasticsearch-framework    # Elasticsearch 封装
├── damai-id-generator-framework     # 分布式 ID 生成器
├── damai-thread-pool-framework      # 线程池框架
├── damai-captcha-manage-framework   # 验证码框架
│
├── damai-server/                    # 微服务模块
│   ├── damai-gateway-service        # API 网关（6085）
│   ├── damai-user-service           # 用户服务
│   ├── damai-program-service        # 节目/演出服务（核心）
│   ├── damai-order-service          # 订单服务
│   ├── damai-pay-service            # 支付服务
│   ├── damai-base-data-service      # 基础数据服务
│   ├── damai-customize-service      # 自定义规则服务
│   └── damai-admin-service          # 后台管理服务
│
├── damai-server-client/             # Feign Client 模块
│   ├── damai-user-client
│   ├── damai-program-client
│   ├── damai-order-client
│   ├── damai-pay-client
│   ├── damai-base-data-client
│   ├── damai-customize-client
│   └── damai-job-client
│
├── vue3/                            # 前端项目（Vue 3 + Element Plus）
├── sql/                             # 数据库脚本
└── docs/                            # 项目文档
```

## 核心功能

- **用户模块**：注册/登录（JWT + 验证码）、购票人管理、实名认证
- **节目模块**：节目浏览/搜索（Elasticsearch）、座位选择、票价查看、演出场次
- **订单模块**：高并发抢购（多级缓存 + 分布式锁 + 限流）、订单创建、超时自动取消
- **支付模块**：支付宝支付、退款、支付回调
- **网关模块**：统一入口、路由转发、限流、API 访问控制

## 高并发手段

| 手段 | 实现 |
|------|------|
| 多级缓存 | 本地缓存(Caffeine) + Redis + 布隆过滤器 |
| 限流 | Sentinel + Redis Lua 令牌桶 + 多级规则 |
| 异步解耦 | Kafka 消息队列 |
| 分布式锁 | Redisson Lock |
| 分库分表 | ShardingSphere（order/pay/program/user 各 2 库） |
| 搜索引擎 | Elasticsearch（节目搜索） |
| 分布式ID | Baidu UID Generator（Snowflake） |
| 延迟队列 | Redisson DelayQueue（订单超时取消） |

## 设计模式

- **策略模式**：下单策略 V1-V4、支付渠道策略
- **组合模式**：下单校验链、用户注册校验、应用初始化
- **模板方法**：支付/退款基类

## 启动条件

- JDK 17
- MySQL 8.0+
- Redis 6.0+
- Nacos 2.0+
- Kafka
- Elasticsearch 7.x+

## 启动步骤

1. 导入 `sql/cloud/` 下的数据库脚本
2. 启动中间件：Nacos、Redis、Kafka、Elasticsearch
3. 启动后端微服务：Gateway → User → Program → Order → Pay
4. 进入 `vue3/` 目录执行 `npm install && npm run dev`

## 项目文档

详见 `docs/大麦高并发票务系统项目报告.md`
