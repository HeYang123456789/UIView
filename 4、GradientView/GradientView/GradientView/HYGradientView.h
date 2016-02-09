//
//  HYGradientView.h
//  HYGradientView
//
//  Created by HEYANG on 16/2/7.
//  Copyright © 2016年 HEYANG. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    UP = 0x11,
    DOWN,
    LEFT,
    RIGHT
} kGradientDirection;

@interface HYGradientView : UIView

/** Direction */
@property (nonatomic,assign)kGradientDirection direction;

/** Color */
@property (nonatomic,strong)UIColor *color;

/** Percent */
@property (nonatomic,assign)CGFloat percnet;


@end
