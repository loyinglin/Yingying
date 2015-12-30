//
//  BaseMessage.h
//  Supermark
//
//  Created by 林伟池 on 15/8/18.
//  Copyright (c) 2015年 林伟池. All rights reserved.
//

#import "AllMessage.h"
#import "Yingying.h"
#import "LYNotifyCenter.h"
#import "AFNetworking.h"
#import <Foundation/Foundation.h>

@interface BaseMessage : NSObject

typedef void(^AfterMessageSuccess)(void);
typedef void(^AfterMessageFail)(void);

@property (nonatomic) BOOL background;

@property (nonatomic , strong) AfterMessageSuccess  myCallback;
@property (nonatomic , strong) AfterMessageFail     myFailBack;

@property (nonatomic , strong) NSString* myLoadingStrings;

+(instancetype)instance;

+(instancetype)backgroundInstance;

+(instancetype)callbackInstance:(AfterMessageSuccess)callback;

/**
 *  post 请求
 *
 *  @param str     <#str description#>
 *  @param param   <#param description#>
 *  @param success <#success description#>
 */
-(void)sendRequestWithPost:(NSString*)str Param:(NSDictionary *)param success:(void (^)(id responseObject))success;



/**
 *  上传
 *
 *  @param str           上传url
 *  @param param         上传参数
 *  @param formDataBlock 初始化formData回调
 *  @param progressBlock 进度回调
 *  @param successBlock  成功回调
 *  @param failBlock     失败回调
 */
-(void)sendUploadWithPost:(NSString *)str Param:(NSDictionary *)param constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))formDataBlock Progress:(void (^)(NSProgress *uploadProgress)) progressBlock success:(void (^)(id responseObject))successBlock Fail:(void(^)(void))failBlock;

@end
