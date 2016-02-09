//
//  HYGradientView+GradientAnimation.h
//  GradientView
//
//  Created by HEYANG on 16/2/8.
//  Copyright © 2016年 HEYANG. All rights reserved.
//

#import "HYGradientView.h"

@interface HYGradientView (GradientAnimation)
/** Timer */
@property (nonatomic,strong)NSTimer *timer;
/** 开始Gradient动画 */
-(void)startGradientAnimation;
/** 停止Gradient动画 */
- (void)stopGradientAnimation;

@end
