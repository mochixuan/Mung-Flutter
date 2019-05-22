## [React版Mung](https://github.com/mochixuan/Mung-React)
## [React-Native版Mung](https://github.com/mochixuan/Mung)
## [Flutter版Mung](https://github.com/mochixuan/Mung-Flutter)

# Mung-Flutter

### 1. Mung-Flutter：是一个基于Flutter编写，使用豆瓣开源API开发的一个项目。

![image](https://github.com/mochixuan/Mung/blob/master/Ui/ui/ic_launcher.png?raw=true)

### 2. 功能概述

- **启动页**：添加了启动页主要是让最开始进入时不至于显示白屏。
- **数据保存** ：支持断网加载缓存数据。
- **主题换肤** ：现在只支持切换主题颜色，本项目没几张图片。
- **查看电影详情** ：支持查看电影详情包括评论。
- **一键搜索**： 支持标签和语句查找相关的电影。
- **查看剧照**: 支持缩放图片。
- **适配iphonx及以上**:适配了IphoneX及以上的头部和底部的安全区域问题。

### 3.1 动态演示(Android版)
![](https://user-gold-cdn.xitu.io/2019/5/22/16add3b749fe8761?w=240&h=400&f=gif&s=4173548)

### 3.2 运行结果图

![image](https://github.com/mochixuan/Mung/blob/master/Ui/ppt/icon_ppt1.png?raw=true)
![image](https://github.com/mochixuan/Mung/blob/master/Ui/ppt/icon_ppt2.png?raw=true)

### 4. 使用到的框架

- **flutter_swiper** ：Banner栏图片轮播的效果。
- **rxdart** ：和Rxjava、RxJs、RxSwift差不多，这里主要用它的BehaviorSubject配合Bloc模式实现状态管理。
- **shared_preferences** ：简单的数据保存，比较细致的数据存储如列表等还是建议使用数据库。
- **dio** ：实现网络请求，一个非常不错的三方网络包，功能非常多，如果刚入门或者项目比较急建议使用这个。
- **flutter_spinkit** : 加载时显示的加载组件，挺不错，建议看下。
- **photo_view**： 图片缩放组件，因为安卓里的photoview正好选了，使用了一个简单的功能，暂时没发现问题。

### 5. 项目全局状态管理
现在据我了解的比较成熟的状态管理有。

- 1. InheritedWidget(自带的其他三方好像都是基于它开发，只是封装了下，更加方便)
- 2. scoped_model： 不错。
- 3. redux和前端的redux是一个意思，但我写过demo用过，个人愚见：差远了。
- 4. Bloc：(Business Logic Component)paolo soares 和 cong hui 在2018年Google dartconf上提出的,它其实是一个模式InheritedWidget+stream配合使用。

本项目使用的就是Bloc。

### 6. 思考
这个开发的第一个flutter，都有这个项目来说该用的主流框架都恰到好处的用了，因为项目太小，适合入门和快速开发。对于flutter个人感觉。

- 1. 上个月看了一个消息Flutter团队好像在今年不会推出热更新功能，好像是基于安全和可实现性考虑，这里要说下flutter编译模式： 开发阶段使用的是 Kernel Snapshot 模式编译，生产模式使用AOT。
- 2. flutter上月好像推出了web端和桌面的适配，这个应该对flutter发展有很大帮助。
- 3. 我之前一年多一直使用React-Native开发项目，感觉Flutter的组件比RN多，而且多很多，组件兼容性更好，而且更精致，但是嵌套的模式真心丑，而且巨乱，我开发时把组件拆分成多个函数这样会让界面清新一点。
- 4. 状态管理，暂时还没有一个绝对好的状态管理功能，现在有些项目使用bloc或者bloc+redux，但个人认为不久的将来会有一个好的状态管理功能占据绝对的地址，想RN的redux、mobx一样。
- 5. 组件生命周期函数很少，尤其是开发大型项目时，之前使用RN开发时就觉得RN比原生安卓生命周期少，自己还得去添加全局监听去管理生命周期，flutter就更少了。
- 6. 性能，应该flutter，网上一大堆对比文章一番一大把，个人使用也明显感觉到flutter性能很好，这是现实原理的问题，尤其是列表，比fRN好很多，而且动画等也多，自定义组件还没看，不做评价。
- 7. 社区，毫无疑问RN社区会比Flutter对于现在这个时间段来说，而且RN支持热更新对原生加（RN、Flutter）来说，RN也更站优势，三方组件来说RN已经很多了，开源项目比较多。

### 7. 提示
2019-5-12左右豆瓣把开源API关了，现在使用的别的开发者的地址，项目Baser_url是抽出来的后期可以自己改，现在项目使用的是https://douban.uieee.com/v2，可以正常运行。

### 8.下载地址
- [安卓版](https://fir.im/mungflutter)
- ios版（没有企业账号-😊）
