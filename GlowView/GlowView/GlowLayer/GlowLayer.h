//
//  GlowLayer.h
//  GlowView
//
//  Created by HEYANG on 16/1/30.
//  Copyright © 2016年 HeYang. All rights reserved.
//

#import <UIKit/UIKit.h>

//                                     == 动画时间解析 ==
//
//  0.0 ----------- 0.0 ------------> glowOpacity [---------------] glowOpacity ------------> 0.0
//           T                T                           T                           T
//           |                |                           |                           |
//           |                |                           |                           |
//           .                .                           .                           .
//     hideDuration   animationDuration              glowDuration              animationDuration
//

/**
 *  需要考虑的参数
 *  
 *  需要考虑的逻辑
 *      1.数值越界问题，通过懒加载
 *      2.动画时间的安排(看前面的动画时间的解析)
 *
 *  需要对外公开的接口
 */


@interface GlowLayer : CALayer

#pragma mark - 对外公开的属性

#pragma mark 设置辉光效果
/** 辉光的阴影半径 */
@property (nonatomic,strong)NSNumber *glowRadius;
/** 辉光的透明度 */
@property (nonatomic,strong)NSNumber *glowOpacity;

#pragma mark 设置辉光的时间
/** 保持辉光的时间，默认设置为0.5f */
@property (nonatomic,strong)NSNumber *glowDuration;
/** 不显示辉光的时间，默认设置为0.5f */
@property (nonatomic,strong)NSNumber *hideDuration;
/** 辉光的变化时间，从明到暗或者是从暗到明，默认设置为1.f */
@property (nonatomic,strong)NSNumber *glowAnimationDuration;


#pragma mark - 对外公开的接口

/** 在原始的View上创建出辉光layer */
-(void)createGlowLayerWithOriginView:(UIView*)originView glowColor:(UIColor*)glowColor;

/** 显示辉光 */
-(void)showGLowLayer;

/** 隐藏辉光 */
-(void)hideGlowLayer;

/** 开始循环辉光动画 */
-(void)startGlowAnimation;

/** 暂停辉光动画 */
-(void)pauseGlowAnimation;

/** 重启辉光动画 */
-(void)reStareGlowAnimation;

@end

@interface UIView (GlowViews)

/** GlowLayer */
@property (nonatomic,strong)GlowLayer *glowLayer;


/** 创建GlowLayer，默认辉光颜色为红色 */
-(void)addGlowLayer;
/** 创建GlowLayer，需要设置辉光颜色 */
-(void)addGlowLayerWithGlowColor:(UIColor*)glowColor;

/** 插入辉光 */
-(void)insertGlowLayerToSuperlayer;

/** 完全移除GLowLayer */
-(void)removeGlowLayerFromSuperlayer;
@end


