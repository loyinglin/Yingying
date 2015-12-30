//
//  DataModel.m
//  Yingying
//
//  Created by 林伟池 on 15/12/25.
//  Copyright © 2015年 林伟池. All rights reserved.
//

#import "DataModel.h"
#import "DataMessage.h"

@implementation DataModel



#pragma mark - init

+ (instancetype)instance
{
    static id test;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        test = [[[self class] alloc] init];
    });
    return test;
}

#pragma mark - update



#pragma mark - get




#pragma mark - message

- (void)requestUploadWith:(NSString *)url {
//    [[DataMessage instance] requestUploadWithUrl:url];
}

@end
