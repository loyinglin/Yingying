//
//  LYDebug.h
//  Supermark
//
//  Created by 林伟池 on 15/9/17.
//  Copyright (c) 2015年 林伟池. All rights reserved.
//


#ifdef DEBUG 
#define LYLog(format...) LYDebug(__FILE__,__LINE__,format)
#define LYLogError()    LYLog(@"error here")
#else
#define LYLog(format...)  
#endif

#import <Foundation/Foundation.h>

void LYDebug(const char *fileName, int lineNumber, NSString *fmt, ...);