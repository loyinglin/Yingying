//
//  XCTestCase+LYBlock.h
//  Yingying
//
//  Created by 林伟池 on 16/1/4.
//  Copyright © 2016年 林伟池. All rights reserved.
//

#import <XCTest/XCTest.h>

typedef BOOL (^LYTestCallbackBlock)();


@interface XCTestCase (LYBlock)

- (void)lyRunCurrentRunLoopUntilTestPasses:(LYTestCallbackBlock)callback timeout:(NSTimeInterval)timeout;


@end
