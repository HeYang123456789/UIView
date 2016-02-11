//
//  ViewController.m
//  CircleProgress
//
//  Created by HEYANG on 16/2/9.
//  Copyright © 2016年 HEYANG. All rights reserved.
//

#import "ViewController.h"

#import "CircleProgressView.h"

@interface ViewController ()

/** CircleProgressView */
@property (nonatomic,weak)CircleProgressView *progressView;
/** timer */
@property (nonatomic,strong)NSTimer *timer;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    
    CircleProgressView* progressView = [[CircleProgressView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
    progressView.center = self.view.center;
    progressView.layer.borderWidth = 1.f;
    progressView.layer.borderColor = [UIColor whiteColor].CGColor;
    progressView.progressLineWidth = 10.f;
    [self.view addSubview:progressView];
    self.progressView = progressView;
    
    // 测试进度条路径的切换动画
//    [self progressPathAnimation];
    // 测试进度条位置的动画
    [self progressAnimation];
    // 测试线颜色的动画
//    [self progressColorAnimation];
    // 测试线宽的动画
//    [self progressLineWidthAnimation];
}
#pragma mark - 进度条路径的切换动画
-(void)progressPathAnimation{
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.f
                                                  target:self
                                                selector:@selector(changeProgressPath)
                                                userInfo:nil
                                                 repeats:YES];
}
static BOOL isOne = TRUE;
-(void)changeProgressPath{
    if (isOne) {
        UIBezierPath* onePath = [UIBezierPath bezierPathWithRect:CGRectMake(1, 1, 200, 200)];
        self.progressView.path = onePath;
        isOne = !isOne;
    }else if(!isOne){
        UIBezierPath* twoPath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(1, 1, 200, 200)];
        self.progressView.path = twoPath;
        isOne = !isOne;
        
    }
    
}
#pragma mark - 因起止点属性变化的线宽变化动画
-(void)progressAnimation{
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.f
                                                  target:self
                                                selector:@selector(changeProgress)
                                                userInfo:nil
                                                 repeats:YES];
}
-(void)changeProgress{
    CGFloat startValue           = arc4random() % 100 / 100.f;
    CGFloat endValue             = arc4random() % 100 / 100.f;
    self.progressView.startValue = startValue < endValue ? startValue : endValue;
    self.progressView.endValue   = startValue > endValue ? startValue : endValue;
}
#pragma mark - 因线颜色属性变化的线宽变化动画
-(void)progressColorAnimation{
    self.timer = [NSTimer scheduledTimerWithTimeInterval:5.f
                                                  target:self
                                                selector:@selector(changeProgressColor)
                                                userInfo:nil
                                                 repeats:YES];
}
-(void)changeProgressColor{
    self.progressView.color = [UIColor colorWithRed:arc4random() % 255 / 255.f
                                              green:arc4random() % 255 / 255.f
                                               blue:arc4random() % 255 / 255.f
                                              alpha:1];
}
#pragma mark - 因线宽属性变化的线宽变化动画
-(void)progressLineWidthAnimation{
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.f
                                                  target:self
                                                selector:@selector(changeProgressLineWidth)
                                                userInfo:nil
                                                 repeats:YES];
}
-(void)changeProgressLineWidth{
    self.progressView.progressLineWidth = arc4random() % 100;
}


@end
