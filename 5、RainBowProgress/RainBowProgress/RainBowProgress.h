//
//  RainBowProgress.h
//  RainBowProgress
//
//  Created by HEYANG on 16/2/10.
//  Copyright © 2016年 HEYANG. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RainBowProgress : UIView
/*
 *  接口：1、高度(用于重新设置高度，get方法有默认的高度)
 */

/** RainBowProgess's height 彩虹条的高度 */
@property (nonatomic,assign)CGFloat progressHeigh;

/** Progress Value (0~1) */
@property (nonatomic,assign)CGFloat progressValue;

/** 开始动画过程 */
- (void)startAnimating;
/** 结束动画过程 */
- (void)stopAnimating;

@end
