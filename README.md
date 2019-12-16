<a href='https://github.com/popor/mybox'> MyBox </a>

# PoporNetRecord

[![CI Status](https://img.shields.io/travis/wangkq/PoporNetRecord.svg?style=flat)](https://travis-ci.org/wangkq/PoporNetRecord)
[![Version](https://img.shields.io/cocoapods/v/PoporNetRecord.svg?style=flat)](https://cocoapods.org/pods/PoporNetRecord)
[![License](https://img.shields.io/cocoapods/l/PoporNetRecord.svg?style=flat)](https://cocoapods.org/pods/PoporNetRecord)
[![Platform](https://img.shields.io/cocoapods/p/PoporNetRecord.svg?style=flat)](https://cocoapods.org/pods/PoporNetRecord)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

思路模仿自LLDebugTool, https://github.com/HDB-Li/LLDebugTool.git ,但是我只需要监测所有的网络请求,另外其他需求也不一致,所以有了本framework.

```
若想在Web页面显示 WIFI 名称，需要针对iOS12在Xcode中设置。
参考详情:https://www.jianshu.com/p/751625d4d282

选择Target，在Capabilities中，激活Access WiFi Infomation项。
```
<p>
<img src="https://github.com/popor/PoporNetRecord/blob/master/Example/PoporNetRecord/image/AccessWifiInformation.png" width="100%" height="100%">

</p>

## Requirements

## Installation

PoporNetRecord is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'PoporNetRecord'
```

```
修改弹出方式

PnrConfig * config = [PnrConfig share];
config.presentNCBlock = ^(UINavigationController *nc) {
    // ... other
    nc.modalPresentationStyle = UIModalPresentationFullScreen;
}

```

<p>
<img src="https://github.com/popor/PoporNetRecord/blob/master/Example/PoporNetRecord/image/root.png" width="30%" height="30%">
<img src="https://github.com/popor/PoporNetRecord/blob/master/Example/PoporNetRecord/image/list.png" width="30%" height="30%">
<img src="https://github.com/popor/PoporNetRecord/blob/master/Example/PoporNetRecord/image/detail.png" width="30%" height="30%">

</p>

```
电脑浏览器访问,假如使用chrome或者QQ浏览器,安装json-handle插件,可以点击[数据返回]进行更好的查看json数据
```
<p>
<img src="https://github.com/popor/PoporNetRecord/blob/master/Example/PoporNetRecord/image/web1.png" width="100%" height="100%">
<img src="https://github.com/popor/PoporNetRecord/blob/master/Example/PoporNetRecord/image/web2.png" width="100%" height="100%">
<img src="https://github.com/popor/PoporNetRecord/blob/master/Example/PoporNetRecord/image/web3.png" width="100%" height="100%">
</p>

1.07
详情页面增加再次转发功能

1.09
增加PnrBlockPVoid viewDidloadBlock; 方便设定ballBT属性

1.10
防止iPhoneX屏幕, bt位于屏幕正上方无法点击
autoFixIphoneXFrame : 默认为YES, 防止ballBT位于在屏幕上方出现, iPhoneX机型可能无法点击到ballBT.

## Author

wangkq, 908891024@qq.com

## License

PoporNetRecord is available under the MIT license. See the LICENSE file for more info.
