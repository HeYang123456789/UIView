//
//  CircleProgressView.m
//  CircleProgress
//
//  Created by HEYANG on 16/2/9.
//  Copyright © 2016年 HEYANG. All rights reserved.
//

#import "CircleProgressView.h"
#import "UIView+AdjustFrame.h"

@interface CircleProgressView ()

/** progressLayer */
@property (nonatomic,weak)CAShapeLayer *progressLayer;

@end

@implementation CircleProgressView

#pragma mark - 初始化方法
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // 创建CAprogressLayer
        CAShapeLayer* progressLayer = [CAShapeLayer layer];
        progressLayer.frame         = self.bounds;
        progressLayer.fillColor     = [UIColor clearColor].CGColor;
        progressLayer.lineWidth     = 3.5f;
        [self.layer addSublayer:progressLayer];
        self.progressLayer          = progressLayer;
        self.color                  = [UIColor redColor];

        // 贝塞尔曲线所在的frame值
        CGRect pathFrame            = CGRectMake(progressLayer.lineWidth * 0.5 + 0.5, progressLayer.lineWidth * 0.5 + 0.5, frame.size.width -  progressLayer.lineWidth - 1, frame.size.height -  progressLayer.lineWidth - 1);
        // 创建贝塞尔曲线
        UIBezierPath* path          = [UIBezierPath bezierPathWithOvalInRect:pathFrame];
        // 关联贝塞尔曲线
        progressLayer.path = path.CGPath;
        // 超出VIew本身的不要显示
        progressLayer.masksToBounds = YES;
    }
    return self;
}

#pragma mark - 重写set和get方法
#pragma mark 重写startValue的set和get方法
@synthesize startValue = _startValue;
-(void)setStartValue:(CGFloat)startValue{
    _startValue = startValue;
    _progressLayer.strokeStart = _startValue;
}
-(CGFloat)startValue{
    return _startValue;
}
#pragma mark 重写endValue的set和get方法
@synthesize endValue = _endValue;
-(void)setEndValue:(CGFloat)endValue{
    _endValue = endValue;
    _progressLayer.strokeEnd = _endValue;
}
-(CGFloat)endValue{
    return _endValue;
}
#pragma mark 重写“线的颜色”的set和get方法
@synthesize color = _color;
-(void)setColor:(UIColor *)color{
    _color = color;
    _progressLayer.strokeColor = _color.CGColor;
}
-(UIColor *)color{
    return _color;
}
#pragma mark 重写“线宽”的set和get方法
@synthesize progressLineWidth = _progressLineWidth;
-(void)setProgressLineWidth:(CGFloat)progresslineWidth{
    _progressLineWidth           = progresslineWidth;
    // 重新设置线宽，还要重新设置UIBezierPath所在的frame值
    _progressLayer.lineWidth = _progressLineWidth;
    // 贝塞尔曲线所在的frame值
    CGRect pathFrame             = CGRectMake(_progressLineWidth * 0.5 + 0.5, _progressLineWidth * 0.5 + 0.5, _progressLayer.frame.size.width - _progressLineWidth - 1, _progressLayer.frame.size.height - _progressLineWidth - 1);
    // 创建贝塞尔曲线
    UIBezierPath* path           = [UIBezierPath bezierPathWithOvalInRect:pathFrame];
    // 关联贝塞尔曲线
    _progressLayer.path      = path.CGPath;
}
-(CGFloat)progressLineWidth{
    return _progressLineWidth;
}

#pragma mark 重写path的set和get方法
@synthesize path = _path;
-(void)setPath:(UIBezierPath *)path{
    CABasicAnimation* baseicAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
    baseicAnimation.removedOnCompletion = NO;
    baseicAnimation.duration          = 1.f;
    baseicAnimation.fromValue         = (__bridge id _Nullable)(_path.CGPath);
    baseicAnimation.toValue           = (__bridge id _Nullable)(path.CGPath);
    [_progressLayer addAnimation:baseicAnimation forKey:@"animateCirclePath"];
    _path                             = path;
    _progressLayer.path           = _path.CGPath;
}
-(UIBezierPath *)path{
    return _path;
}
@end
