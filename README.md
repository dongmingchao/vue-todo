## 清单分发系统
[![Build Status](https://travis-ci.com/dongmingchao/vue-todo.svg?branch=master)](https://travis-ci.com/dongmingchao/vue-todo)

老师统一制作课程每周ToDo List，然后分发给学生。学生完成后相应任务打勾，老师可进行统计查看以支持下一步决策，系统可自动根据学生完成情况发送相关支撑材料（比如链接、文档）发送给学生。进阶：要求Todo List中的某个任务可以有子任务。
网页版
小程序版
手机客户端版
参考资料：<https://todo.microsoft.com/zh-cn>

要求有码云的运用，包括选题的确定（NABCD），需求分析报告，开发过程报告，测试报告，用户反馈报告，项目总结报告。

## 需求分析报告

1. 用户是老师和学生
2. 基本的打勾确认
3. 完成时的通知
4. 类似群投票？

### 开发进度

#### 本地功能

   - [x] 子任务
   - [ ] 添加新列表
   - [x] 设置todo的详细信息
   - [x] pwa service worker
   - [ ] 设置及时通知

#### 互联功能

老师-学生模型  ||   团队-成员模型

老师制定todo，分发给学生