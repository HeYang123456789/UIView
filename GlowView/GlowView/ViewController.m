//
//  ViewController.m
//  GlowView
//
//  Created by HEYANG on 16/1/31.
//  Copyright © 2016年 HEYANG. All rights reserved.
//

#import "ViewController.h"
#import "GlowLayer.h"

@interface ViewController ()

/** UILabel */
@property (nonatomic,weak)UILabel *label;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    {
        UILabel *label  = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 300, 50)];
        label.text      = @"HeYang";
        label.textColor = [UIColor whiteColor];
        label.font      = [UIFont fontWithName:@"AppleSDGothicNeo-Thin" size:40.f];
        
        label.center    = self.view.center;
        [self.view addSubview:label];
        self.label = label;
        
        [label addGlowLayerWithGlowColor:[UIColor cyanColor]];
        [label.glowLayer startGlowAnimation];
    }
    {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(180, 250, 45, 75)];
        imageView.image        = [UIImage imageNamed:@"demo"];
        [self.view addSubview:imageView];
        
        [imageView addGlowLayerWithGlowColor:[UIColor cyanColor]];
        
        imageView.glowLayer.glowRadius        = @(2.f);
        imageView.glowLayer.glowOpacity       = @(0.5f);
        
        imageView.glowLayer.glowDuration      = @(1.f);
        imageView.glowLayer.hideDuration      = @(0.5f);
        imageView.glowLayer.glowAnimationDuration = @(1.f);
        
        [imageView.glowLayer startGlowAnimation];
    }
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    static BOOL isTrue  = true;
    if (isTrue == true) {
        // 暂停辉光动画
        [self.label.glowLayer pauseGlowAnimation];
    }else{
        // 重启辉光动画
        [self.label.glowLayer reStareGlowAnimation];
    }
    isTrue = !isTrue;
}
@end
