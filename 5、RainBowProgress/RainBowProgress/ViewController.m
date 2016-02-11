//
//  ViewControl/Users/HeYang/Documents/Xcode/object-c/IOS/RainbowProgress/RainbowProgress/ViewController.hler.m
//  RainbowProgress
//
//  Created by HEYANG on 16/2/10.
//  Copyright © 2016年 HEYANG. All rights reserved.
//

#import "ViewController.h"
#import "RainbowProgress.h"

@interface ViewController ()

/** timer */
@property (nonatomic,strong)NSTimer *timer;
/** rainbowProgress */
@property (nonatomic,weak)RainbowProgress *rainbowProgress;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    
    // 1、创建彩虹进度条
    RainbowProgress* rainbowProgress = [RainbowProgress new];
    // 2、重设彩虹进度条的高度
    rainbowProgress.progressHeigh = 145;
    // 3、开始彩虹动画
    [rainbowProgress startAnimating];
    
    // 通过计时器模拟网络加载 进度条显示状态
    self.timer = [NSTimer scheduledTimerWithTimeInterval:2.f
                                     target:self
                                   selector:@selector(func)
                                   userInfo:nil
                                    repeats:YES];
    
    [self.view addSubview:rainbowProgress];
    self.rainbowProgress = rainbowProgress;
}
-(void)func{
    // 4、设置彩虹进度条的进度值
    self.rainbowProgress.progressValue = self.rainbowProgress.progressValue + arc4random() % 100 / 150.f;
    // 5、如果想要在进度条到1的结束时候停止彩虹移动动画，可以这样
    if (self.rainbowProgress.progressValue == 1) {
        [self.rainbowProgress stopAnimating];
//        [self.rainbowProgress removeFromSuperview];
    }
}
-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

@end
