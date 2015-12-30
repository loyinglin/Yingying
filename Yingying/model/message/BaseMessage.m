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
        NSString* str = @"加载中";
        if (self.myLoadingStrings) {
            str = self.myLoadingStrings;
        }
        [self presentLoadingTips:str];
    }
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript", @"text/plain", nil];
    
    LYLog(@"%@ request with %@", str, [param description]);

    [manager POST:str parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (!self.background) {
            [self dismissTips];
        }
        LYLog(@"%@ \n base log : %@", str, [responseObject description]);
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (!self.background) {
            [self dismissTips];
            [self presentMessageTips:@"操作失败"];
        }
        LYLog(@"Error: %@", error);
        LYLog(@"opertaion %@ error", [task description]);
    }];
}




-(void) sendUploadWithPost:(NSString *)str Param:(NSDictionary *)param constructingBodyWithBlock:(void (^)(id<AFMultipartFormData>))formDataBlock Progress:(void (^)(NSProgress *))progressBlock success:(void (^)(id))successBlock Fail:(void (^)(void))failBlock{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    manager.requestSerializer.timeoutInterval = 10; 上传不设超时
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript", @"text/plain", nil];
    [manager POST:str parameters:param constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        if (formDataBlock) {
            formDataBlock(formData);
        }
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        if (progressBlock) {
            progressBlock(uploadProgress);
        }
        else {
//            dispatch_async(dispatch_get_main_queue(), ^{
//                LYLog(@"percent %f", uploadProgress.fractionCompleted);
//                [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_PROGRESS_UPLOAD object:nil userInfo:@{NOTIFY_PROGRESS_UPLOAD:@(uploadProgress.fractionCompleted)}];
//            });
        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        LYLog(@"respone %@", [responseObject description]);
        if (successBlock) {
            successBlock(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failBlock) {
            failBlock();
        }
        
//        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_PROGRESS_UPLOAD object:nil userInfo:@{NOTIFY_PROGRESS_UPLOAD:@(-1.0)}];
        LYLog(@"Error: %@", error);
        LYLog(@"opertaion %@ error", [task description]);
    }];
    
}

@end
