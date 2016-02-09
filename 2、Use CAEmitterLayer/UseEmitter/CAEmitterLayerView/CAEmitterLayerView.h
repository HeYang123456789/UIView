//
//  CAEmitterLayerView.h
//  UseEmitter
//
//  Created by HEYANG on 16/2/1.
//  Copyright © 2016年 HEYANG. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CAEmitterLayerView : UIView

/** EmitterLayer */
@property (nonatomic,strong)CAEmitterLayer *emitterLayer;

/** 显示当前的View */
-(void)show;
/** 隐藏当前的View */
-(void)hide;


@end
