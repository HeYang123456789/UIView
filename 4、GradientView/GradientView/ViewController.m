//
//  ViewController.m
//  HYGradientView
//
//  Created by HEYANG on 16/2/7.
//  Copyright © 2016年 HEYANG. All rights reserved.
//

#import "ViewController.h"
#import "HYGradientView+GradientAnimation.h"
//#import "HYGradientView.h"


@interface ViewController ()

/** HYGradientView */
@property (nonatomic,weak)HYGradientView *gradientView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    HYGradientView* gradientView = [[HYGradientView alloc] initWithFrame:CGRectMake(0, 0, 200, 300)];
    gradientView.center = self.view.center;
    [self.view addSubview:gradientView];
    self.gradientView = gradientView;
    self.gradientView.backgroundColor = [UIColor clearColor];
    
    [self.gradientView startGradientAnimation];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSLog(@"hello");
        [self.gradientView stopGradientAnimation];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSLog(@"hello");
            [self.gradientView startGradientAnimation];
        });
    });

}


@end
