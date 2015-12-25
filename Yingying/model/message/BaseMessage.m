//
//  BaseMessage.m
//  Supermark
//
//  Created by 林伟池 on 15/8/18.
//  Copyright (c) 2015年 林伟池. All rights reserved.
//

#import "BaseMessage.h"
#import "NSObject+LYUITipsView.h"
#import <CFNetwork/CFNetwork.h>

@implementation BaseMessage

+(instancetype)instance
{
    return [[[self class] alloc] init];
}

+(instancetype)backgroundInstance
{
    BaseMessage* ret = [[[self class] alloc] init];
    ret.background = YES;
    return ret;
}

+(instancetype)callbackInstance:(AfterMessageSuccess)callback
{
    BaseMessage* ret = [[[self class] alloc] init];
    ret.myCallback = callback;
    
    return ret;
}

-(void)sendRequestWithPost:(NSString *)str Param:(NSDictionary *)param success:(void (^)(id))success
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = 10;
    if (!self.background) {
        [self presentLoadingTips:@"加载中"];
    }
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript", @"text/plain", nil];
    
    [manager POST:str parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (!self.background) {
            [self dismissTips];
        }
        NSLog(@"%@ respone %@", str, responseObject);
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (!self.background) {
            [self dismissTips];
            [self presentMessageTips:@"操作失败"];
        }
        NSLog(@"Error: %@", error);
        NSLog(@"opertaion %@ error", [task description]);
    }];
}

-(void)sendUploadWithPost:(NSString *)str Param:(NSDictionary *)param constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block success:(void (^)(id))success {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = 10;
    if (!self.background) {
        [self presentLoadingTips:@"加载中"];
    }
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript", @"text/plain", nil];
    [manager POST:str parameters:param constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        if (block) {
            block(formData);
        }
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"percent %f", uploadProgress.fractionCompleted);
        });
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if (!self.background) {
            [self dismissTips];
        }
        NSLog(@"respone %@", responseObject);
        success(responseObject);

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if (!self.background) {
            [self dismissTips];
            [self presentMessageTips:@"操作失败"];
        }
        NSLog(@"Error: %@", error);
        NSLog(@"opertaion %@ error", [task description]);
    }];
    
}

@end
