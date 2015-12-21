//
//  UIView+LYModify.m
//  Yingying
//
//  Created by 林伟池 on 15/12/21.
//  Copyright © 2015年 林伟池. All rights reserved.
//

#import "UIView+LYModify.h"

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]


@implementation UIView (LYModify)

- (void)lySetupBorderwithColor:(long)color Width:(CGFloat)width Radius:(CGFloat)radius {
    self.layer.borderColor = UIColorFromRGB(color).CGColor;
    self.layer.borderWidth = width;
    self.layer.cornerRadius = radius;
}

@end
