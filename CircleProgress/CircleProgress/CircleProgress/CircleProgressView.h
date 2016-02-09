//
//  CircleProgressView.h
//  CircleProgress
//
//  Created by HEYANG on 16/2/9.
//  Copyright © 2016年 HEYANG. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CircleProgressView : UIView


/*
 * 需要的属性
 * 线宽、线的颜色、进度条的起点、进度条的终点
 */

/** 线的颜色 */
@property (nonatomic,strong)UIColor *color;
/** 线宽 */
@property (nonatomic,assign)CGFloat progressLineWidth;
/** 进度条的起点 */
@property (nonatomic,assign)CGFloat startValue;
/** 进度条的终点 */
@property (nonatomic,assign)CGFloat endValue;

#pragma mark - 路径属性

/** 线的路径 */
@property (nonatomic,strong)UIBezierPath *path;

@end
