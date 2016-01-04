//
//  XCTestCase+LYBlock.m
//  Yingying
//
//  Created by 林伟池 on 16/1/4.
//  Copyright © 2016年 林伟池. All rights reserved.
//

#import "XCTestCase+LYBlock.h"

@implementation XCTestCase (LYBlock)


- (void)lyRunCurrentRunLoopUntilTestPasses:(LYTestCallbackBlock)callback timeout:(NSTimeInterval)timeout {
    
    NSDate *timeoutDate = [NSDate dateWithTimeIntervalSinceNow:timeout];
    NSTimeInterval timeoutTime = [timeoutDate timeIntervalSinceReferenceDate];
    BOOL bTimeout = NO;
    
    while (!callback()) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate dateWithTimeIntervalSinceNow:0.1]];
        if ([NSDate timeIntervalSinceReferenceDate] >= timeoutTime) {
            bTimeout = YES;
            break;
        }
    }
    
    XCTAssertFalse(bTimeout, @"Timed out");

}

@end
