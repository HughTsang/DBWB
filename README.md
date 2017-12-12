## 用Swift 3.0写的微博,实现了查看和发布微博功能

![示例图片.png](http://upload-images.jianshu.io/upload_images/2764759-481324e1e3e13f73.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

### 调用新浪开放平台API,实现首页数据的展示
```
1. 仿微博照片浏览器
2. MVVM思想应用
3. 图文混排
4. 表情键盘
5. 自定义转场动画
6. 正则表达式的使用
```
`项目使用了cocoapods,项目clone之后执行pod install即可`

```
 1.在WBOAuthViewController.swift中fillItemClick方法中设置默认的账号密码,在登录页面使用"填充"按钮可使用,不设置也可以.
 2.在Common.swift中,可以填写自己的app_key,app_secret和redirect_uri.
 具体参数的获取可以登录新浪开放平台自己获取http://open.weibo.com
```
