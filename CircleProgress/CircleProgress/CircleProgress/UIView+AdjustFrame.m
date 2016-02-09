//
//  UIView+AdjustFrame.m
//  CircleProgress
//
//  Created by HEYANG on 16/2/9.
//  Copyright © 2016年 HEYANG. All rights reserved.
//

#import "UIView+AdjustFrame.h"

@implementation UIView (AdjustFrame)

#pragma mark - adjust_x
-(void)setAdjust_x:(CGFloat)adjust_x{
    CGRect frame = self.frame;
    frame.origin.x = adjust_x;
    self.frame = frame;
}

-(CGFloat)adjust_x{
    return self.frame.origin.x;
}

#pragma mark - adjust_y
-(void)setAdjust_y:(CGFloat)adjust_y{
    CGRect frame = self.frame;
    frame.origin.y = adjust_y;
    self.frame = frame;
}

- (CGFloat)adjust_y
{
    return self.frame.origin.y;
}

#pragma mark - adjust_width
-(void)setAdjust_width:(CGFloat)adjust_width{
    CGRect frame = self.frame;
    frame.size.width = adjust_width;
    self.frame = frame;
}
- (CGFloat)adjust_width
{
    return self.frame.size.width;
}

#pragma mark - adjust_height
-(void)setAdjust_height:(CGFloat)adjust_height{
    CGRect frame = self.frame;
    frame.size.height = adjust_height;
    self.frame = frame;
}
- (CGFloat)adjust_height
{
    return self.frame.size.height;
}

#pragma mark - adjust_size
-(void)setAdjust_size:(CGSize)adjust_size{
    CGRect frame = self.frame;
    frame.size = adjust_size;
    self.frame = frame;
}
- (CGSize)adjust_size
{
    return self.frame.size;
}

#pragma mark - adjust_origin
-(void)setAdjust_origin:(CGPoint)adjust_origin{
    CGRect frame = self.frame;
    frame.origin = adjust_origin;
    self.frame = frame;
}
- (CGPoint)adjust_origin
{
    return self.frame.origin;
}

@end

