//
//  HYGradientView+GradientAnimation.m
//  GradientView
//
//  Created by HEYANG on 16/2/8.
//  Copyright © 2016年 HEYANG. All rights reserved.
//

#import "HYGradientView+GradientAnimation.h"
#import <objc/runtime.h>

@implementation HYGradientView (GradientAnimation)

-(void)startGradientAnimation{
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0f
                                                  target:self
                                                selector:@selector(event)
                                                userInfo:nil
                                                 repeats:YES];
}
- (void)event {    // 这个实例练习让我学会了，类别拓展是拿不到主类中实现中的属性和方法，但是可以拿到声明公开的方法
    self.color     = [UIColor colorWithRed:arc4random() % 255 / 255.f
                                     green:arc4random() % 255 / 255.f
                                      blue:arc4random() % 255 / 255.f
                                     alpha:1];
    self.percnet   = arc4random() % 100 / 100.f;
    self.direction = [self getDirectionArcRandom];
}

-(kGradientDirection)getDirectionArcRandom{
    switch (arc4random() % 4) {
        case 0:
            return UP;
            break;
        case 1:
            return DOWN;
            break;
        case 2:
            return LEFT;
            break;
        case 3:
            return RIGHT;
            break;
        default:
            return DOWN;
            break;
    }
}
- (void)stopGradientAnimation{
    [self.timer invalidate];
}

-(void)setTimer:(NSTimer *)timer{
    objc_setAssociatedObject(self, @"GradientTimer", timer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
-(NSTimer *)timer{
    return objc_getAssociatedObject(self, @"GradientTimer");
}

@end
