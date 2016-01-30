//
//  GlowLayer.m
//  GlowView
//
//  Created by HEYANG on 16/1/30.
//  Copyright © 2016年 HeYang. All rights reserved.
//

#import "GlowLayer.h"

@interface GlowLayer ()

/** 辉光的颜色 */
@property (nonatomic,strong)UIColor *glowColor;

/** 需要添加辉光效果的View ，注意这里用的是weak，而不是strong */
@property (nonatomic,weak)UIView *addedGlowView;

/** dispatch_source_t */
@property (nonatomic,strong)dispatch_source_t timer;
@end

@implementation GlowLayer

#pragma mark - 创建辉光

// 遗留了一个先后顺序的问题，
/** 在原始的View上创建出辉光layer */
-(void)createGlowLayerWithOriginView:(UIView*)originView glowColor:(UIColor*)glowColor{
    self.glowColor = glowColor;
    // 创建一个图形上下文 参数：CGSize size：上下文的尺寸 BOOL opaque是否不透明 CGFloat scale缩放因子
    UIGraphicsBeginImageContextWithOptions(originView.bounds.size, NO, [UIScreen mainScreen].scale);
    // 通过get函数得到当前图形上下文,然后将origingView上的图形渲染到这个图形上下文上
    [originView.layer renderInContext:UIGraphicsGetCurrentContext()];
    // 创建贝塞尔曲线
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:originView.bounds];
    // 设置贝塞尔取消绘制的颜色
    [self.glowColor setFill];//这里还是需要懒加载
    // 设置贝塞尔曲线绘制模式
    [path fillWithBlendMode:kCGBlendModeSourceAtop alpha:1];
    
    
    // 设置self(GlowLayer)初始状态
    self.frame = originView.bounds;
    // 至少要在设置好当前frame值之后，然后添加图形上下文的Image
    // 获得当前图形上下文的图形，然后赋值给CALayer的constraints
    self.contents = (__bridge id _Nullable)(UIGraphicsGetImageFromCurrentImageContext().CGImage);

    // 阴影设置不透明，其他的设置为透明
    self.opacity = 0.f;
    self.shadowOpacity = 1.f;
    // 阴影偏移量为(0,0)
    self.shadowOffset = CGSizeMake(0, 0);
    
    
    // 关闭图形上下文
    UIGraphicsEndImageContext();
    
    // 强引用指向这个原来的View
    self.addedGlowView = originView;
}



#pragma mark - 显示和隐藏辉光

/** 显示辉光 */
-(void)showGLowLayer{
    // 设置阴影初始效果
    self.shadowColor = self.glowColor.CGColor;
    self.shadowRadius = self.glowRadius.floatValue;
    
    
    CABasicAnimation* animation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    animation.fromValue = @(0);
    animation.toValue = self.glowOpacity;
    animation.duration = self.glowAnimationDuration.floatValue;
    // 设置最终值
    self.opacity = self.glowOpacity.floatValue;
    
    [self addAnimation:animation forKey:nil];
}

/** 隐藏辉光 */
-(void)hideGlowLayer{
    self.shadowColor = self.glowColor.CGColor;
    self.shadowRadius = self.glowRadius.floatValue;
    
    CABasicAnimation* animation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    animation.fromValue = self.glowOpacity;
    animation.toValue = @(0);
    animation.duration = self.glowAnimationDuration.floatValue;
    // 设置最终值
    self.opacity = 0;
    
    [self addAnimation:animation forKey:nil];
}

#pragma mark - 循环显示和隐藏辉光

/** 开始循环辉光动画 */
-(void)startGlowAnimation{
    CGFloat cycleTime = self.glowAnimationDuration.floatValue * 2
    + self.glowDuration.floatValue + self.hideDuration.floatValue;
    CGFloat delayTime = self.glowAnimationDuration.floatValue + self.glowDuration.floatValue;
    
    _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_main_queue());
    dispatch_source_set_timer(_timer, DISPATCH_TIME_NOW, cycleTime * NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(_timer, ^{
        [self showGLowLayer];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self hideGlowLayer];
        });
    });
    dispatch_resume(_timer);
}
/** 暂停辉光动画 */
-(void)pauseGlowAnimation{
    [self removeFromSuperlayer];
}
/** 重启辉光动画 */
-(void)reStareGlowAnimation{
    [self.addedGlowView.layer addSublayer:self];
    [self startGlowAnimation];
}

#pragma mark - 懒加载辉光的效果，同时处理数据越界问题
#pragma mark duration 辉光时间
-(NSNumber *)glowDuration{
    if (!_glowDuration || _glowDuration.floatValue < 0) {
        _glowDuration = @(0.5f);
    }
    return _glowDuration;
}
-(NSNumber *)hideDuration{
    if (!_hideDuration || _hideDuration.floatValue < 0) {
        _hideDuration = @(0.5);
    }
    return _hideDuration;
}
-(NSNumber *)glowAnimationDuration{
    if (!_glowDuration || _glowDuration.floatValue < 0) {
        _glowDuration = @(1.f);
    }
    return _glowDuration;
}
#pragma mark 辉光颜色
-(UIColor *)glowColor{
    if (!_glowColor) {
        _glowColor = [UIColor redColor];
    }
    return _glowColor;
}
#pragma mark 辉光半径
-(NSNumber *)glowRadius{
    if (!_glowRadius || _glowRadius.floatValue <= 0) {
        _glowRadius = @(2.f);
    }
    return _glowRadius;
}
#pragma mark 辉光透明度
-(NSNumber *)glowOpacity{
    if (!_glowOpacity || _glowOpacity.floatValue <= 0) {
        _glowOpacity = @(0.8);
    }
    return _glowOpacity;
}
@end

#import <objc/runtime.h>

@implementation UIView (GlowViews)

/** 创建GlowLayer，默认辉光颜色为红色 */
-(void)addGlowLayer{
    [self addGlowLayerWithGlowColor:nil];
}
/** 创建GlowLayer，需要设置辉光颜色 */
-(void)addGlowLayerWithGlowColor:(UIColor*)glowColor{
    if (self.glowLayer == nil) {
        self.glowLayer = [[GlowLayer alloc] init];
    }
    [self.glowLayer createGlowLayerWithOriginView:self glowColor:glowColor];
    [self insertGlowLayerToSuperlayer];
}
#pragma mark - 插入和移除辉光

/** 插入辉光 */
-(void)insertGlowLayerToSuperlayer{
    if (self.glowLayer == nil) {
        self.glowLayer = [[GlowLayer alloc] init];
    }
    [self.layer addSublayer:self.glowLayer];
}


/** 移除辉光 */
-(void)removeGlowLayerFromSuperlayer{
    [self.glowLayer removeFromSuperlayer];
    self.glowLayer = nil;
}

#pragma mark - Runtime动态添加属性
NSString * const _recognizerGlowLayer = @"_recognizerGlowLayer";
-(void)setGlowLayer:(GlowLayer *)glowLayer{
    objc_setAssociatedObject(self, (__bridge const void *)(_recognizerGlowLayer), glowLayer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
-(GlowLayer *)glowLayer{
    return objc_getAssociatedObject(self, (__bridge const void *)(_recognizerGlowLayer));
}


@end
