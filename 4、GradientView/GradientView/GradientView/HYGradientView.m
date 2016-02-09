//
//  HYGradientView.m
//  HYGradientView
//
//  Created by HEYANG on 16/2/7.
//  Copyright © 2016年 HEYANG. All rights reserved.
//

/*
 *  练习反思：
 *      1、无法显示GradientLayer的bug原因是：没有设置frame值
 *      2、在类别中是无法直接使用属性的，所以用上了运行时动态添加属性
 *
 */

#import "HYGradientView.h"

@interface HYGradientView ()

/** GradientLayer */
@property (nonatomic,weak)CAGradientLayer *gradientLayer;

@end

@implementation HYGradientView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.borderWidth = 1.0f;
        CAGradientLayer* gradientLayer = [[CAGradientLayer alloc] init];
        gradientLayer.frame = frame;
        gradientLayer.startPoint = CGPointMake(0, 1);
        gradientLayer.endPoint = CGPointMake(0, 0);
        
        gradientLayer.colors = @[(__bridge id)[UIColor clearColor].CGColor,
                                      (__bridge id)[UIColor clearColor].CGColor];
        gradientLayer.locations = @[@(0),@(1)];
        
        [self.layer  addSublayer:gradientLayer];
        self.gradientLayer = gradientLayer;
    }
    return self;
}
#pragma mark - 重写HYGradientView属性的set和get方法
// 要想property声明的属性能被同时重写set和get方法，需要用(@synthesisze 属性名 = _属性名)
@synthesize direction = _direction;
-(void)setDirection:(kGradientDirection)direction{
    _direction = direction;
    switch (_direction) {
        case UP:
            self.gradientLayer.startPoint = CGPointMake(0, 0);
            self.gradientLayer.endPoint = CGPointMake(0, 1);
            break;
        case DOWN:
            self.gradientLayer.startPoint = CGPointMake(0, 1);
            self.gradientLayer.endPoint = CGPointMake(0, 0);
            break;
        case LEFT:
            self.gradientLayer.startPoint = CGPointMake(0, 0);
            self.gradientLayer.endPoint = CGPointMake(1, 0);
            break;
        case RIGHT:
            self.gradientLayer.startPoint = CGPointMake(1, 0);
            self.gradientLayer.endPoint = CGPointMake(0, 0);
            break;
        default:
            break;
    }
}
-(kGradientDirection)direction{
    
    return _direction;
}
@synthesize color = _color;
-(void)setColor:(UIColor *)color{
    self.gradientLayer.colors = @[(__bridge id)[UIColor clearColor].CGColor,
                                  (__bridge id)color.CGColor];
    _color = color;
}
-(UIColor*)color{
    return _color;
}
@synthesize percnet = _percnet;
-(void)setPercnet:(CGFloat)percnet{
    self.gradientLayer.locations = @[@(percnet),@(1.f)];
    _percnet = percnet;
}
-(CGFloat)percnet{
    if (!_percnet) {
        _percnet = 0.75;
    }
    return _percnet;
}

@end
