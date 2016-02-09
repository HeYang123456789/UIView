//
//  CAEmitterLayerView.m
//  UseEmitter
//
//  Created by HEYANG on 16/2/1.
//  Copyright © 2016年 HEYANG. All rights reserved.
//

#import "CAEmitterLayerView.h"

@implementation CAEmitterLayerView

#pragma mark - 替换layer类型的方法
// 将CAEmitterLayerView自带的CALayer属性类型替换成CAEmitterLayer类型
+ (Class)layerClass{
    return [CAEmitterLayer class];
}
#pragma mark - 初始化的方法
// 不要另外创建这个CAEmitterLayer，因为有个现成的
// 所以在初始化中就让自定义的属性拿到这个CAEmitterLayer对象
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        NSLog(@"%@",self.layer);
        _emitterLayer = (CAEmitterLayer*)self.layer;
    }
    return self;
}

#pragma mark - 显示和隐藏的方法
/** 显示当前的View */
-(void)show{
    
}

/** 隐藏当前的View */
-(void)hide{
    
}

@end
