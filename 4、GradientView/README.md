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

