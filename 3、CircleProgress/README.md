## 关于CAShapeLayer

### CAShapeLayer简介

+ 1、CAShapeLayer继承自CALayer，可以使用CALayer的所有属性值
+ 2、CAShapeLayer需要与贝塞尔曲线配合使用才有意义
+ 3、使用CAShapeLayer与贝塞尔曲线可以实现不在view的drawRect方法中画出有一些想要的图形
+ 4、CAShapeLayer属于CoreAnimation框架，其动画渲染直接提交到手机的GPU当中，相较于view的drawRect方法使用CPU渲染而言，其效率极高，能大大优化内存使用情况。
	- 个人经验：可以重写UIView的子类中的drawRect来实现进度条效果，但是UIView的drawRect是用CPU渲染实现的，而使用CAShapeLayer效率更高，因为它用的是GPU渲染。


### 贝塞尔曲线与CAShapeLayer的关系

+ 1、CAShapeLayer中有Shape这个单词，顾名思义，它需要一个形状才能生效
+ 2、贝塞尔曲线可以创建基于矢量的路径
+ 3、贝塞尔曲线给CAShapeLayer提供路径，CAShapeLayer在提供的路径中进行渲染，路径会闭环，所以路径绘制出了Shape
+ 4、用于CAShapeLayer的贝塞尔曲线做为path，其path实一个首尾相接的闭环的曲线，即使该贝塞尔曲线不是一个闭环的曲线

 图2.png
 
 如何建立贝塞尔曲线和CAShapeLayer的联系：
 
 + 类：CAShapeLayer
 	- 属性：path
 		+ 值：可以是贝塞尔曲线对象
 		
 		```objc
 		UIBezierPath *circle = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0,0,200,100)];
 		shape.path = circle.CGPath;
 		```
 	- 属性：fillColor 修改贝塞尔曲线的填充颜色
 		+ 值：CGColor对象
 	- 属性：maskToBounds 
 		+ 值：YES 会让超出CAShapeLayer的部分不会显示


### strokeStart与strokeEnd动画

+ 1、将ShapeLayer的fillColor设置成透明背景
+ 2、设置线条的宽度（lineWidth）的值
+ 3、设置线条的颜色
+ 4、将strokeStart值设定成0，然后让strokeEnd的值变化触发隐式动画

- 类：CAShapeLayer
	+ 属性：
		- strokeStart
		- strokeEnd
			+ 注意 ：strokeEnd的值一定要比strokeStart的大
			+ 范围 ：(0~1)
		
		```objc
		处理方法：
			shapeLayer.strokeStart = valueOne < valueTwo ? valueOne : valueTwo;
			shapeLayer.strokeStart = valueOne > valueTwo ? valueOne : valueTwo;
		```	
	+ 属性：
		- lineWidth 线条的宽度
		- strokeColor 线条的颜色 
			+ 值：CGColor



### 用CAShapeLayer实现圆形进度条效果

圆形进度条动画.gif

![](http://i12.tietuku.com/9dc0c878af2d3b44.gif)
 
源码下载地址：[CircleProgress](https://github.com/HeYang123456789/UIView) 中的 CircleProgress源码



直接更改path的结果，并没有理想中的渐变过程，所以需要使用核心动画：

![](http://i12.tietuku.com/a1e3dc39689f1e28.gif)

只不过通过核心动画更改路径动画，但是

综合示例源码请看：[https://github.com/HeYang123456789/UIView](https://github.com/HeYang123456789/UIView)
