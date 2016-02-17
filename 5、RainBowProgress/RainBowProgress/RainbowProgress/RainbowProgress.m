//
//  RainbowProgress.m
//  RainbowProgress
//
//  Created by HEYANG on 16/2/10.
//  Copyright © 2016年 HEYANG. All rights reserved.
//
/**
 * 该工具类源码下载地址：https://github.com/HeYang123456789/UIView
 */
#import "RainbowProgress.h"

@interface RainbowProgress ()

/** Animating */
@property (nonatomic,assign,getter=isAnimating)BOOL animating;

/** CAShapeLayer */
@property (nonatomic,weak)CAShapeLayer *shapeMaskLayer;
@end

/*
 * 总结思路：
 *      1、彩虹条的变化动画过程用的是核心动画
 *      2、遮罩层的变化用的是CAShapeLayer的startPoint和endPoint
 */

@implementation RainbowProgress

#pragma mark - 将UIView默认的CALayer替换成CAGradientLayer
+(Class)layerClass{
    return [CAGradientLayer class];
}
#pragma mark - 初始化方法
- (instancetype)initWithFrame:(CGRect)frame
{
    // 设置默认的frame，高度设置为22，这个22懒加载在progressHeigh属性中，宽度当然要和屏幕宽度一样
    CGRect originFrame = CGRectMake(0, self.progressHeigh, [UIScreen mainScreen].bounds.size.width, 2);
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = originFrame;
        
        [self setUpRainbowLayer];
    }
    return self;
}
-(void)setUpRainbowLayer{
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
 当动画在活动时间内完成或者是从层对象中移除这个代理方法会被调用，如果动画直到它的活动时间末尾没有被移除，那这个'flag'是true的。
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
#pragma mark - 重写set和get方法
// 重设进度条在父控件的高度位置
@synthesize progressHeigh = _progressHeigh;
-(void)setProgressHeigh:(CGFloat)progressHeigh{
    _progressHeigh = progressHeigh;
    // 就要重新设置RainbowProgress这个自定义UIView的高度
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
@end
