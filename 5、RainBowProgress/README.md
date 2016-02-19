# iOS之彩虹动画进度条学习和自主封装改进

## 前言：

首先展示一下这个iOS小示例的彩色进度条动画效果：

![彩色动画进度条](https://s3.amazonaws.com/nrjio/GradientProgressView.gif)

阅读本文先说说好处：对于基础不好的读者，可以直接阅读文末尾的"如何使用彩虹动画进度条"章节，然后将我封装好的这个功能模块类用到你的工程项目中即可。

这个效果的示例是老外Nick Jensen在2013年写的一个作品：[使用CAGradientLayer的动画精度条View](https://nrj.io/animated-progress-view-with-cagradientlayer)。
本人阅读了老外的源码之后，觉得老外这个进度条的效果很不错，但是觉得他写的代码有待改进。

小贴士：读者可以直接将老外的源码下载下来，跑一下，然后对比本人写的博文重构的思路过程，进行学习。另外要提出一点的是，老外这个源码毕竟产出比较早，所以用的是MRC，代码中多出用到了retain和release手动内存管理，但是本人的源码是基于ARC的，所以就不涉及用到手动内存管理的代码了。

注意：本篇博文需要有一定的iOS开发基础，主要需要熟悉并能掌握关于CAGradientLayer(颜色渐变层)、CAShapeLayer(形状层)、核心动画基础以及layer、layer.mask等知识，否则读者看此文会有很多不理解的地方。至少可能看老外的源码都会有很多不懂的地方。关于CAGradientLayer(颜色渐变层)、CAShapeLayer(形状层)可以阅读本人博客中前几篇博文笔记。

## 正文：
### UI效果实现的结构分析：

+ 1、先添加一个Rect(0,0,[UIScreen mainScreen].bounds.size.width,2)的矩形CAGradientLayer对象。
+ 2、在这个CAGradientLayer对象上，用核心动画实现彩虹条无限循环轮播移动过程。
+ 3、为这个CAGradientLayer添加遮罩层，这个遮罩层好比再添加一个同等宽高坐标的矩形，遮住了gradientLayer对象
+ 4、然后将这个遮罩层的宽度提供一个接口供外部调用，通过改变这个遮罩层的宽度来显示不被遮住部分的彩虹条


#### 代码实现思路(和Nick Jensen的差不多，但是后面有所改进)：
1、重写类方法layerClass，将UIView默认的CALayer对象类型换CAGradientLayer

```objc
+ (Class)layerClass {
    // Tells UIView to use CAGradientLayer as our backing layer
    return [CAGradientLayer class];
}
```
2、在初始化方法中

```objc
#pragma mark - 初始化方法
- (instancetype)initWithFrame:(CGRect)frame
{
    // 设置默认的frame，高度设置为22，这个22懒加载在progressHeigh属性中，宽度当然要和屏幕宽度一样
    CGRect originFrame = CGRectMake(0, self.progressHeigh, [UIScreen mainScreen].bounds.size.width, 2);
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = originFrame;
        
        [self setUpRainBowLayer];
    }
    return self;
}
-(void)setUpRainBowLayer{
    // 1、创建CAGradientLayer彩虹条颜色层，彩虹颜色当然需要数组存储
    CAGradientLayer* gradientLayer = (CAGradientLayer*)self.layer;
    [gradientLayer setStartPoint:CGPointMake(0, 0)];
    [gradientLayer setEndPoint:CGPointMake(1, 0)];
    
    NSMutableArray *rainBowColors = [NSMutableArray array];
    for (NSInteger hue = 0; hue <= 360; hue += 5) {
        UIColor *color = [UIColor colorWithHue:1.0*hue/360.0
                                    saturation:1.0
                                    brightness:1.0
                                         alpha:1.0];
        [rainBowColors addObject:(id)color.CGColor];
    }
    gradientLayer.colors = [NSArray arrayWithArray:rainBowColors];
    
    // 2、创建遮罩层 同时也需要贝塞尔曲线
    UIBezierPath* shapePath = [UIBezierPath bezierPath];
    [shapePath moveToPoint:CGPointMake(0, 0)];
    [shapePath addLineToPoint:CGPointMake(self.bounds.size.width, 0)];
    
    CAShapeLayer* shapeMaskLayer = [CAShapeLayer layer];
    
    //这个遮罩层其实可以不用设置frame值，因为关联的贝塞尔曲线显示的颜色是默认全部显示的masksToBounds = NO
    //如果masksToBounds = YES;就会出现frame外部的部分就不显示了。
    //shapeMaskLayer.frame = CGRectMake(0, 0, 100, self.layer.bounds.size.height);
    //shapeMaskLayer.masksToBounds = YES;
    
    shapeMaskLayer.path = shapePath.CGPath;
    shapeMaskLayer.lineWidth = 4.f;
    shapeMaskLayer.fillColor = [UIColor clearColor].CGColor;
    shapeMaskLayer.strokeColor = [UIColor blackColor].CGColor;
    // 设置shapeMaskLayer的起止点初始值均为0
    shapeMaskLayer.strokeStart = 0;
    shapeMaskLayer.strokeEnd = 0;
    gradientLayer.mask = shapeMaskLayer;
    
    self.shapeMaskLayer = shapeMaskLayer;
}
```

3、因为需要轮播循环彩虹条动画，所以当然需要一个辅助的数组元素转换的算法方法

```objc
#pragma mark - 辅助方法：转移可变数组最后一个元素到数组的最前面
- (NSArray *)shiftColors:(NSArray *)colors {
    // Moves the last item in the array to the front
    // shifting all the other elements.
    // 数组中最后一项移动到前面
    // 转移的所有其他元素
    NSMutableArray *mutable = [colors mutableCopy];// 将NSArray数组换成 NSMutableArray
    id last = [mutable lastObject]; // 单独取出最后一个元素
    [mutable removeLastObject];              // 然后将数组中的最后一个元素去除
    [mutable insertObject:last atIndex:0];   // 然后将取出的元素插入到最前面
    return [NSArray arrayWithArray:mutable];
}
```

4、然后通过核心动画，来实现彩虹条轮播动画

```objc
#pragma mark - 执行动画的过程
-(void)performAnimation{
    // Update the colors on the model layer
    
    CAGradientLayer *layer = (id)[self layer];
    NSArray *fromColors = [layer colors];
    NSArray *toColors = [self shiftColors:fromColors];
    [layer setColors:toColors];
    
    // Create an animation to slowly move the hue gradient left to right.
    
    CABasicAnimation *animation;
    animation = [CABasicAnimation animationWithKeyPath:@"colors"];
    [animation setFromValue:fromColors];
    [animation setToValue:toColors];
    [animation setDuration:0.08];                   // CALayer的color切换时间是0.08
    [animation setRemovedOnCompletion:YES];         // 动画完成后是否要移除
    [animation setFillMode:kCAFillModeForwards];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
    [animation setDelegate:self];
    
    // Add the animation to our layer
    [layer addAnimation:animation forKey:@"animateGradient"];
}
/*
 当动画在活动时间内完成或者是从层对象中移除这个代理方法会被调用，
 如果动画直到它的活动时间末尾没有被移除，那这个'flag'是true的。
 回调和布尔值来保证动画的循环开始并持续以及结束该动画
 */
- (void)animationDidStop:(CAAnimation *)animation finished:(BOOL)flag {
    // 当动画在duration时间结束前移除了，这个方法会被调用
    // 然后就下面的if语句判断，如果isAnimation = yes，就重新执行performAnimation
    // 在这个performAnimation中重新创建了核心动画对象，重新设置了代理
    if ([self isAnimating]) {
        [self performAnimation];
    }
}

- (void)startAnimating {
    if (![self isAnimating]) {
        self.animating = YES;
        [self performAnimation];
    }
}

- (void)stopAnimating {
    if ([self isAnimating]) {
        self.animating = NO;
    }
}
```

5、最后重写对外公开的两个接口的属性

```objc
#pragma mark - 重写set和get方法
// 重设进度条在父控件的高度位置
@synthesize progressHeigh = _progressHeigh;
-(void)setProgressHeigh:(CGFloat)progressHeigh{
    _progressHeigh = progressHeigh;
    // 就要重新设置RainBowProgress这个自定义UIView的高度
    CGRect frame = self.frame;
    frame.origin.y = _progressHeigh;
    self.frame = frame;
}
-(CGFloat)progressHeigh{
    if (!_progressHeigh) {
        _progressHeigh = 22;
    }
    return _progressHeigh;
}
// 设置进度条的值
@synthesize progressValue = _progressValue;
-(void)setProgressValue:(CGFloat)progressValue{
    progressValue = progressValue > 1 ? 1 : progressValue;
    progressValue = progressValue < 0 ? 0 : progressValue;
    _progressValue = progressValue;
    self.shapeMaskLayer.strokeEnd = _progressValue;
}
-(CGFloat)progressValue{
    return _progressValue;
}
```

### 如何使用彩虹动画进度条

1、首先到本人github上[UIView](https://github.com/HeYang123456789/UIView)下载第5个UIView实现好的小功能RainBowProgress。

![](http://images2015.cnblogs.com/blog/784420/201602/784420-20160211232216261-691589325.png)

2、然后将该功能项目中的RainbowProgress的整个文件目录拖进你的项目中:

![](http://images2015.cnblogs.com/blog/784420/201602/784420-20160211232225198-2113741968.png)

3、然后下面直接展示使用示例：

![](http://images2015.cnblogs.com/blog/784420/201602/784420-20160211232231542-534863152.png)


### 不得不提的改进的亮点


- Nick Jensen实现进度条遮罩层的方式：
	+ 1、外部调用接口，根据外部数据不断的更改progress进度值
	+ 2、在progress的set方法内部调用了[self setNeedsLayout];
	+ 3、[self setNeedsLayout]会在内部重新调用layoutSubviews方法
	+ 4、而layoutSubviews的重写方法中根据progress值更改遮罩层的长度
	+ 5、从而触发了CALayer的隐式动画，实现了进度条展示进度的效果

注意：Nick Jensen的遮罩层用的是CALayer创建的对象

- 本人实现进度条的遮罩层的方式
	+ 1、外部调用接口，根据外部数据不断的更改progress进度值
	+ 2、在progress的set方法内部调用了self.shapeMaskLayer.strokeEnd = _progressValue;
	+ 3、这样就直接更改了遮罩层(CAShapeLayer)的终点值，更改了遮罩层的长度
	+ 4、从而触发了CAShapeLayer的隐式动画，实现了进度条展示进度的效果

注意：本人的遮罩层用的是CAShapeLayer创建的对象

所以相对而言，本人的代码也简单一些。哈哈，其实也没什么。能实现不出bug就好。




