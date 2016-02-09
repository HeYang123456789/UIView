//
//  ViewController.m
//  UseEmitter
//
//  Created by HEYANG on 16/2/1.
//  Copyright © 2016年 HEYANG. All rights reserved.
//
//  学习目标：1.做个熟悉下面属性的笔记 2.熟悉下面使用到的属性 3.补充最下面的笔记
/*
    emitterMode' values.发射模式

CA_EXTERN NSString * const kCAEmitterLayerPoints
__OSX_AVAILABLE_STARTING (__MAC_10_6, __IPHONE_5_0);
CA_EXTERN NSString * const kCAEmitterLayerOutline
__OSX_AVAILABLE_STARTING (__MAC_10_6, __IPHONE_5_0);
CA_EXTERN NSString * const kCAEmitterLayerSurface
__OSX_AVAILABLE_STARTING (__MAC_10_6, __IPHONE_5_0);
CA_EXTERN NSString * const kCAEmitterLayerVolume
__OSX_AVAILABLE_STARTING (__MAC_10_6, __IPHONE_5_0);
 
 */

/** `
    emitterShape' values.发射形状

CA_EXTERN NSString * const kCAEmitterLayerPoint
__OSX_AVAILABLE_STARTING (__MAC_10_6, __IPHONE_5_0);
CA_EXTERN NSString * const kCAEmitterLayerLine
__OSX_AVAILABLE_STARTING (__MAC_10_6, __IPHONE_5_0);
CA_EXTERN NSString * const kCAEmitterLayerRectangle
__OSX_AVAILABLE_STARTING (__MAC_10_6, __IPHONE_5_0);
CA_EXTERN NSString * const kCAEmitterLayerCuboid
__OSX_AVAILABLE_STARTING (__MAC_10_6, __IPHONE_5_0);
CA_EXTERN NSString * const kCAEmitterLayerCircle
__OSX_AVAILABLE_STARTING (__MAC_10_6, __IPHONE_5_0);
CA_EXTERN NSString * const kCAEmitterLayerSphere
__OSX_AVAILABLE_STARTING (__MAC_10_6, __IPHONE_5_0);
  **/

#import "ViewController.h"
#import "CAEmitterLayerView.h"
#import "SnowView.h"
#import "RainView.h"
@interface ViewController ()

@end

@implementation ViewController

//有时候最好原图片的颜色不要用纯黑色，不然就不能渲染自己通过UIColor设定的颜色了
//比如白色的原图，还可以设定为黑色，但是黑色的原图就算设定为白色，显示到屏幕的还是黑色
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self testSnowAndRain];
    
    [self addEmitter];
}
-(void)testSnowAndRain{
    UIImageView *alphaView1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    alphaView1.image        = [UIImage imageNamed:@"alpha"];
    
    UIImageView *alphaView2 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    alphaView2.image        = [UIImage imageNamed:@"alpha"];
    
    
    // 添加下雪效果
    CAEmitterLayerView *snowView = [[SnowView alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
    snowView.maskView            = alphaView1;
    [self.view addSubview:snowView];
    [snowView show];
    
    
    
    // 添加下雨效果
    CAEmitterLayerView *rainView = [[RainView alloc] initWithFrame:CGRectMake(100, 210, 100, 100)];
    rainView.maskView            = alphaView2;
    [self.view addSubview:rainView];
    [rainView show];
    
}
-(void)addEmitter{
    //创建粒子的Layer
    CAEmitterLayer* emitterLayer = [CAEmitterLayer layer];
    //显示边框
    emitterLayer.borderWidth = 1.f;
    emitterLayer.borderColor = [UIColor whiteColor].CGColor;
    //给定尺寸
    emitterLayer.frame = CGRectMake(100, 400, 100, 100);
    //发射点
    emitterLayer.emitterPosition = CGPointMake(50, 50);
    //发射模式
    emitterLayer.emitterMode = kCAEmitterLayerSurface;
    //发射形状
    emitterLayer.emitterShape = kCAEmitterLayerLine;
    //添加到父Layer上
    [self.view.layer addSublayer:emitterLayer];
    
    
    //创建粒子
    CAEmitterCell* emitterCell = [CAEmitterCell emitterCell];
    //粒子产生率
    emitterCell.birthRate = 1.f;//这个相当于是某单位时间产生粒子的个数
    //粒子生命周期
    emitterCell.lifetime = 120.f;//这个是单个粒子的生命周期的时间
    //速度值
    emitterCell.velocity = 10;
    //速度值的微调值
    emitterCell.velocityRange = 3.f;
    //y轴加速度
    emitterCell.yAcceleration = 2.f;//这里的设置表示在y轴正方向有个2.f大小的加速度，模拟重力
    //发射角度
    emitterCell.emissionRange = M_PI * M_1_PI;// 暂时不理解
    //设置粒子的颜色
    emitterCell.color = [UIColor blueColor].CGColor;
    //设置图片
    emitterCell.contents = (__bridge id _Nullable)([UIImage imageNamed:@"snow"].CGImage);// 我暂时不理解图片的要求是什么？
    //让CAEmitterCell与CAEmitterLayer产生关联
    emitterLayer.emitterCells = @[emitterCell];//用的数组，说明一个CAEmitterLayer可以关联多个CAEmitterCell
    
}
/*
 补充：
    The cell contents, typically a CGImageRef. Defaults to nil.
    Animatable.
    @property(nullable, strong) id contents;虽然这个属性的类型是id类型，但是注释内容应该传入的类型值是CGImageRef
 */

@end
