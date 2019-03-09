## 清单分发系统
[![Build Status](https://travis-ci.com/dongmingchao/vue-todo.svg?branch=master)](https://travis-ci.com/dongmingchao/vue-todo)

## 需求分析

1. 用户是老师和学生
2. 基本的打勾确认
3. 完成时的通知

### 开发进度

#### 目前的问题

1. 管理用户的点击队列
2. 设置手机端返回的api，在有子界面（比如设置）的时候点返回会退出子界面而不是退出app，退出app为点两次返回
3. <s>标题部分不滚动</s>
4. 标题部分的功能列表，在屏幕小的手机上应该将多余的按钮收归到更多里面，不能挡到日期
5. push notify插件要求不同的id来控制对应的通知，且id必为数字
6. 设计一个图标(需要帮助。。)

#### 本地功能

   - [ ] 子任务
   - [x] 添加新列表
   - [x] 设置todo的详细信息
   - [ ] pwa service worker
   - [x] 设置及时通知
   - [ ] 插件化，发布api创造插件市场，以插件形式实现markdown,mermaid以及其他方向功能
   - [ ] 设置智能清单：比如今天的列表，收藏的列表

#### 互联功能

   - [ ] 任务清单可分享