## 1、GlowView

![](http://chuantu.biz/t2/24/1454186379x-1376440148.gif)

学习来自：[YouXianMing老师Github上的GlowView](https://github.com/YouXianMing/GlowView)

YouXianMing老师用的是类别，但是本人将其改写为继承自CALayer的普通类，然后仅仅用了很简单的类别将对外接口进行了简单的封装。所以外部调用起来也是同样的方便，可读性也是比较好的。当然，本人这么做主要原因并不是喜欢重复造轮子，而是通过自我编码的训练，对辉光UIView的实现底层所使用到的上下文绘制、核心动画、GCD中的定时器以及Runtime动态添加属性等知识进一步的熟练运用和提高：

![](http://chuantu.biz/t2/24/1454188449x-954497756.png)
### 然后简单的使用示例：
![](http://chuantu.biz/t2/24/1454188366x-1376440148.png)

## 2、Use CAEmitterLayer

###粒子雪花效果和下雨效果

![](http://chuantu.biz/t2/24/1454269085x1822611270.gif)

类：CAEmitterLayer、CAEmitterCell
解析：CAEmitterLayer：粒子发射场对象(类似火箭发射场的作用)
	  CAEmitterCell：粒子对象

+ CAEmitterLayer的用途
	- CAEmitterLayer一直都是GPU渲染的，不会占用CPU内存
+ CAEmitterLayer的一些重要参数
+ 为什么要使用CAEmitterLayer
	- 为了节省性能
	- 可以产生非常不错的效果 

####封装 CAEmitterLayer

+ 替换CAEmitterLayer成自定义UIView子类的backedLayer

```objc
使用的方法，在自定义UIView里重写一个类方法
+ (Class)layerClass{
	return [CAEmitterLayer class];
}
这样就能将UIView的属性layer的类型CALayer换成CAEmitterLayer
```
然后在这个自定义UIView类中添加一个CAEmitterLayer属性，并且在创建这个CALayer的时候，就能拿到这个CAEmitterLayer对象，注意哦，不要另外创建，因为layerClass的类型是CAEmitterLayer，这样原本UIView.layer类型就是这个CAEmitterLayer，不过XCode可能误以为的类型还是CALayer，就会警告，所以还需要强制类型装换它哦。


## 3、Use CAShapeLayer 综合示例

![](http://i12.tietuku.com/b10d4ab84261cc12.gif) ![](http://i12.tietuku.com/9dc0c878af2d3b44.gif) 

+ 使用了
	- 核心动画的路径转换显示动画(如果没用上核心动画，直接切换path并不会出现渐变过程的动画)
	- 颜色的隐式动画
	- 精度条的隐式动画
	- 线宽的隐式动画(gif图没有显示罢了)

![](http://i12.tietuku.com/68ca2cca13a2c16c.png)

## 4、Use CAGradientLayer

![色差动画的实现.gif](http://i11.tietuku.com/bedd584f01c5a8d9.gif) ![图解CAGradientLayer的locations数组属性.png](http://i11.tietuku.com/f5ad960a0970a3ac.png) ![用 CAGradientLayer 封装带色差动画的 View.gif](http://i11.tietuku.com/5c6d77a0190a40b3.gif)

## 5、RainBowProgress

![](https://s3.amazonaws.com/nrjio/GradientProgressView.gif)