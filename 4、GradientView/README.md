## GradientView

效果：用 CAGradientLayer 封装带色差动画的 View.gif

+ HYGradientView是自定义的GradientView
	- 继承UIView
	- 只有一层渐变颜色，色差UIView
	- 属性
		+ kGradientDirection
		+ UIColor
		+ CGFloat
	
	```objc
	typedef enum : NSUInteger {
    UP = 0x11,
    DOWN,
    LEFT,
    RIGHT
	} kGradientDirection;

	@interface HYGradientView : UIView

	/** Direction */
	@property (nonatomic,assign)kGradientDirection direction;

	/** Color */
	@property (nonatomic,strong)UIColor *color;

	/** Percent */
	@property (nonatomic,assign)CGFloat percnet;


	@end
	```
+ HYGradientView+GradientAnimation是GradientView的类别
	- 动画：色差随机动画
		+ 方向UP、DOWN、LEFT、RIGHT随机
		+ 颜色值color随机
		+ 铺盖面积百分比percent随机
	- 可以start动画
	- 可以stop动画
	
	```objc
	@interface HYGradientView (GradientAnimation)
	
	/** Timer */
	@property (nonatomic,strong)NSTimer *timer;
	/** 开始Gradient动画 */
	-(void)startGradientAnimation;
	/** 停止Gradient动画 */
	- (void)stopGradientAnimation;

	@end
	```

## iOS 中 CAGradientLayer 的使用

### 1、CAGradientLayer 简介

如果说CAShapeLayer是用于提供设置形状的，那么CAGradientLayer是用于提供设置颜色的

英语单词：Gradient：

+ CAGradientLayer简介
	- CAGradientLayer是用于处理渐变色的层结构
	- CAGradientLayer的渐变色可以做隐式动画
	- 大部分情况下，CAGradientLayer都是与CAShapeLayer配合使用的
	- CAGradientLayer可以用作png遮罩效果

+ 使用CAGradientLayer主要的方法
	- locations 设置颜色分割点的数组
	- startPoint	坐标系统的起点 
	- endPoint 	坐标系统的终止点
		+ startPoint和endPoint的起止点范围(0,0)~(1,1)
	- colors 颜色值数组，颜色个数 >=2 才有用

下面展示几个关于CAGradientLayer的效果图。

![CAShapeLayer作为CAGradientLayer的遮罩实现的效果.gif](http://i13.tietuku.com/3f015e022368ed72.gif)

最后给出YouXianMing老师的四个关于CAGradientLayer的Example Code下载链接: [http://pan.baidu.com/s/1eR0Q7Hw](http://pan.baidu.com/s/1eR0Q7Hw) 密码: 7zvm

### 2、CAGradientLayer 坐标系统

+ CAGradientLayer的坐标系统是从坐标（0，0）到（1，1）绘制的矩形
+ CAGradientLayer的frame值的size不为正方形的话，坐标系统会被拉伸
+ CAGradientLayer的startPoint与endPoint会直接影响颜色的绘制方向
+ CAGradientLayer的颜色分割点割点是以0到1的比例来计算的 

![图解CAGradientLayer的locations数组属性.png](http://i11.tietuku.com/f5ad960a0970a3ac.png)

- 个人分析:
	+ 当"颜色的个数 = 设置颜色分割点的个数 + 1"，是最大有效渐变颜色设置的数量关系
	+ 当"颜色的个数 > 设置颜色分割点的个数 + 1"，会出现多余的颜色不显示在屏幕上
	+ 当"颜色的个数 < 设置颜色分割点的个数 + 1"，多余的分割点无用

用于体会的源码

```objc
#import "CAGradientLayerController.h"

#define ScreenWidth  [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height

@interface CAGradientLayerController ()

/** GradientLayer */
@property (nonatomic,weak)CAGradientLayer *gradientLayer;
@property (nonatomic,weak)CAGradientLayer *gradientLayer2;

@end

@implementation CAGradientLayerController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 第一个layer
    NSArray* colors =  @[(__bridge id)[UIColor redColor].CGColor,
                             (__bridge id)[UIColor blueColor].CGColor];
    self.gradientLayer = [self addGradientLayerWithFrame:CGRectMake(ScreenWidth * 0.5 - 100, 50, 200, 100) colors:colors locations:nil];
    
    // 第二个layer
    NSArray* colors2 =  @[(__bridge id)[UIColor redColor].CGColor,
                         (__bridge id)[UIColor blueColor].CGColor];
    NSArray* locations2 = @[@(0.5),@(0.75)];
    
    self.gradientLayer = [self addGradientLayerWithFrame:CGRectMake(ScreenWidth * 0.5 - 100, 170, 200, 100) colors:colors2 locations:locations2];
    
    // 第三个layer
    NSArray* colors3 =  @[(__bridge id)[UIColor redColor].CGColor,
                          (__bridge id)[UIColor greenColor].CGColor,
                          (__bridge id)[UIColor blueColor].CGColor];
    NSArray* locations3 = @[@(0),@(0.5)];
    
    self.gradientLayer = [self addGradientLayerWithFrame:CGRectMake(ScreenWidth * 0.5 - 100, 290, 200, 100) colors:colors3 locations:locations3];
    
    // 第四个layer
    NSArray* colors4 =  @[(__bridge id)[UIColor blackColor].CGColor,//黑色
                          (__bridge id)[UIColor whiteColor].CGColor,//白色
                          (__bridge id)[UIColor greenColor].CGColor,//绿色
                          (__bridge id)[UIColor blueColor].CGColor, //蓝色
                          (__bridge id)[UIColor grayColor].CGColor, //灰色
                          (__bridge id)[UIColor brownColor].CGColor //棕色
                          ];
    NSArray* locations4 = @[@(0.25),@(0.5),@(0.75),@(0.85)];
    /*
     * 0~0.25    黑色◎
     * 0.25~0.5  黑色↓ 白色↑
     * 0.5~0.75  白色↓ 绿色↑
     * 0.75~0.85 绿色↓ 蓝色↑
     * 0.85~1.0  蓝色↓ 灰色↑
     * 因为到1.0就结束了，所以棕色就是多余的了
     */
    
    self.gradientLayer = [self addGradientLayerWithFrame:CGRectMake( 2, 410, ScreenWidth - 4, 100) colors:colors4 locations:locations4];
    

}
-(CAGradientLayer*)addGradientLayerWithFrame:(CGRect)frame colors:(NSArray<NSNumber*>*)colors locations:(NSArray<NSNumber*>*)locations {
    CAGradientLayer* gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = frame;
    gradientLayer.colors = colors;
    gradientLayer.locations = locations;
    gradientLayer.borderWidth = 1.0f;
    
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(1, 0);
    
    [self.view.layer addSublayer:gradientLayer];
    return gradientLayer;
}

@end
```

### 3、色差动画的实现

+ 确定渐变色渐变方向
+ 设定两种颜色，其中一种是透明色，另外一种是自定义颜色
+ 设定好location颜色分割点值
+ CAGradientLayer的颜色分割点是以0到1的比例来计算的

+ 补充：
	- arc4random()是随机生成任意数值，所以arc4random() % 99这个求余的式子表示求出0~99之间的余数，所以通过这种类似的求余式子来设置产生）0~99之间的随机数。
	- 如果要设置0~1之间的按照自定义的精细度设置范围：
		+ 比如我需要将0~1拆分为255份，那么就要arc4random() % 255 / 255.0f
		+ 比如我需要将0~1拆分为10份， 那么就要arc4random() % 10 / 10.0f
	
+ 注意：
	- 如果后面 / 10.0f没有 .0f 而是直接 / 10的话，会出问题的。

![色差动画的实现.gif](http://i11.tietuku.com/bedd584f01c5a8d9.gif)

```objc
#import "CAGradientLayerController.h"

#define ScreenWidth  [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height

@interface CAGradientLayerController ()

/** GradientLayer */
@property (nonatomic,weak)CAGradientLayer *gradientLayer;
/** Timer */
@property (nonatomic,strong)NSTimer *timer;

@end

@implementation CAGradientLayerController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 添加背景
    UIImageView* imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg"]];
    imageView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    [self.view addSubview:imageView];
    
    // 添加色差层
    NSArray* colors = @[(__bridge id)[UIColor clearColor].CGColor,
                        (__bridge id)[UIColor clearColor].CGColor];
    NSArray* locations = @[@(0)];
    
    self.gradientLayer = [self addGradientLayerWithFrame:imageView.frame colors:colors locations:locations];
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0f
                                                  target:self
                                                selector:@selector(changeGradientColor)
                                                userInfo:nil
                                                 repeats:YES];
}
-(void)changeGradientColor{
    self.gradientLayer.colors = @[(__bridge id)[UIColor clearColor].CGColor,
                                  (__bridge id)[UIColor colorWithRed:arc4random() % 255 / 255.0f
                                                               green:arc4random() % 255 / 255.0f
                                                                blue:arc4random() % 255 / 255.0f
                                                               alpha:1].CGColor];
    //self.gradientLayer.locations = @[@(arc4random() % 10 / 10.0f)];
    //这个效果不好，效果是直接铺盖上去的，但是下面一种情况，是形变也是有过程的。
    self.gradientLayer.locations = @[@(arc4random() % 10 / 10.0f),@(1.0f)];
}

-(CAGradientLayer*)addGradientLayerWithFrame:(CGRect)frame colors:(NSArray<NSNumber*>*)colors locations:(NSArray<NSNumber*>*)locations {
    CAGradientLayer* gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = frame;
    gradientLayer.colors = colors;
    gradientLayer.locations = locations;
    gradientLayer.borderWidth = 1.0f;
    
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(0, 1);
    
    [self.view.layer addSublayer:gradientLayer];
    return gradientLayer;
}

@end
``` 


### 4、用 CAGradientLayer 封装带色差动画的 View

+ 确定几个属性值
+ 确定可以做动画的参数
+ 重写setter方法做动画

+ 对外的需求：
	- 属性：
		+ 设置上下左右色差方向(用枚举设置该属性direction)
		+ 色差颜色(color)
		+ 颜色占位百分比(percent)
		

效果图：

![用 CAGradientLayer 封装带色差动画的 View.gif](http://i11.tietuku.com/5c6d77a0190a40b3.gif)

源码在github上：[https://github.com/HeYang123456789/UIView](https://github.com/HeYang123456789/UIView)



