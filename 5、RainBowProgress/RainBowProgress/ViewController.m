//
//  ViewControl/Users/HeYang/Documents/Xcode/object-c/IOS/RainBowProgress/RainBowProgress/ViewController.hler.m
//  RainBowProgress
//
//  Created by HEYANG on 16/2/10.
//  Copyright © 2016年 HEYANG. All rights reserved.
//

#import "ViewController.h"
#import "RainBowProgress.h"

@interface ViewController ()

/** timer */
@property (nonatomic,strong)NSTimer *timer;
/** rainbowProgress */
@property (nonatomic,weak)RainBowProgress *rainbowProgress;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    RainBowProgress* rainbowProgress = [RainBowProgress new];
    // 重设彩虹进度条的高度
    rainbowProgress.progressHeigh = 145;
    [self.view addSubview:rainbowProgress];
    self.rainbowProgress = rainbowProgress;
    [rainbowProgress startAnimating];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:2.f
                                     target:self
                                   selector:@selector(func)
                                   userInfo:nil
                                    repeats:YES];
}
-(void)func{
    self.rainbowProgress.progressValue = self.rainbowProgress.progressValue + arc4random() % 100 / 150.f;
    // 如果想要在进度条到1的结束时候停止彩虹移动动画，可以这样
    if (self.rainbowProgress.progressValue == 1) {
        [self.rainbowProgress stopAnimating];
//        [self.rainbowProgress removeFromSuperview];
    }
}
-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

@end
