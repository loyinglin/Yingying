//
//  LYDebug.m
//  Supermark
//
//  Created by 林伟池 on 15/9/17.
//  Copyright (c) 2015年 林伟池. All rights reserved.
//

#import "LYDebug.h"
void LYDebug(const char *fileName, int lineNumber, NSString *fmt, ...)
{
    va_list args;
    
    va_start(args, fmt);
    
    static NSDateFormatter *debugFormatter = nil;
    
    if (debugFormatter == nil) {
        debugFormatter = [[NSDateFormatter alloc] init];
        [debugFormatter setDateFormat:@"yyyyMMdd.HH:mm:ss"];
    }
    
    NSString *msg = [[NSString alloc] initWithFormat:fmt arguments:args];
    
    NSString        *filePath = [[NSString alloc] initWithUTF8String:fileName];
    NSString        *timestamp = [debugFormatter stringFromDate:[NSDate date]];
    NSDictionary    *info = [[NSBundle mainBundle] infoDictionary];
    NSString        *appName = [info objectForKey:(NSString *)kCFBundleNameKey];
    fprintf(stdout, "%s %s[%s:%d] %s\n", [timestamp UTF8String], [appName UTF8String], [[filePath lastPathComponent] UTF8String], lineNumber, [msg UTF8String]);
    
    va_end(args);
}