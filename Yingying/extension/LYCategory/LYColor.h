//
//  LYColor.h
//  Supermark
//
//  Created by 林伟池 on 15/8/28.
//  Copyright (c) 2015年 林伟池. All rights reserved.
//

#import <Foundation/Foundation.h>

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define RGBA(r,g,b,a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
#define RGB(r,g,b) RGBA(r,g,b,1.0f)

#define LY_COLOR_RED       0xf84a40
#define LY_COLOR_YELLOW    0xffb017
#define LY_COLOR_GRAY      0x8e8e8e
#define LY_COLOR_BLACK     0x333333
#define LY_COLOR_BACKGROUND 0XF0F0F0


@interface LYColor : NSObject

@end
