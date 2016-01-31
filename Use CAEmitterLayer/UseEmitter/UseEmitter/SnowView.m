//
//  SnowView.m
//  CAEmitterLayerView
//
//  Created by YouXianMing on 15/5/14.
//  Copyright (c) 2015年 YouXianMing. All rights reserved.
//

#import "SnowView.h"

@implementation SnowView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // 初始化设置
        [self setup];
    }
    return self;
}

- (void)setup {
    self.emitterLayer.masksToBounds   = YES;
    self.emitterLayer.emitterShape    = kCAEmitterLayerLine;
    self.emitterLayer.emitterMode     = kCAEmitterLayerSurface;
    self.emitterLayer.emitterSize     = self.frame.size;
    self.emitterLayer.emitterPosition = CGPointMake(self.bounds.size.width / 2.f, - 20);
}

- (void)show {
    // 配置
    CAEmitterCell *snowflake  = [CAEmitterCell emitterCell];
    snowflake.birthRate       = 1.f;
    snowflake.speed           = 10.f;
    snowflake.velocity        = 2.f;
    snowflake.velocityRange   = 10.f;
    snowflake.yAcceleration   = 10.f;
    snowflake.emissionRange   = 0.5 * M_PI;
    snowflake.spinRange       = 0.25 * M_PI;
    snowflake.contents        = (__bridge id)([UIImage imageNamed:@"snow"].CGImage);
    snowflake.color           = [UIColor cyanColor].CGColor;
    snowflake.lifetime        = 60.f;
    snowflake.scale           = 0.5;
    snowflake.scaleRange      = 0.3;
    
    // 添加动画
    self.emitterLayer.emitterCells = @[snowflake];
}

@end
