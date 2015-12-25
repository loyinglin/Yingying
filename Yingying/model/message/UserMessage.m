//
//  UserMessage.m
//  Yingying
//
//  Created by 林伟池 on 15/12/17.
//  Copyright © 2015年 林伟池. All rights reserved.
//

#import "UserMessage.h"
#import "UserModel.h"

@implementation UserMessage

- (void)requestOauthLoginWithUserphone:(NSString *)userphone Password:(NSString *)password {
    
    NSDictionary* dict = [[NSDictionary alloc] initWithObjectsAndKeys:
                          userphone, @"userphone",
                          password, @"password",
                          nil];
    
    [self sendRequestWithPost:[LY_MSG_BASE_URL stringByAppendingString:(NSString*)LY_MSG_OAUTH_LOGIN] Param:dict success:^(id responseObject) {
        NSDictionary* dict = responseObject;
        if ([dict objectForKey:@"access_token"]) {
            [[UserModel instance] updateWithPhone:userphone AccessToken:[dict objectForKey:@"access_token"] TokenType:[dict objectForKey:@"token_type"] Expires:[dict objectForKey:@"expires_in"]];
            
        }
        else {
            NSLog(@"error %@", self);
        }
    }];

}

- (void)requestGetUserInfoWithAccessToken:(NSString *)accessToken Userphone:(NSString *)userphone {
    
    NSDictionary* dict = [[NSDictionary alloc] initWithObjectsAndKeys:
                          accessToken, @"access_token",
                          userphone, @"userphone",
                          nil];
    
//    AFHTTPSessionManager* manager = [AFHTTPSessionManager manager];
//    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript", @"text/plain", nil];
//    [manager GET:[NSString stringWithFormat:@"%@%@", LY_MSG_BASE_URL, LY_MSG_USER_GET_USER_INFO] parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSLog(@"succcess %@", responseObject);
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        NSLog(@"eeror %@", error);
//    }];
    
//    [manager POST:[NSString stringWithFormat:@"%@%@", LY_MSG_BASE_URL, LY_MSG_USER_GET_USER_INFO] parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSLog(@"succcess %@", responseObject);
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        NSLog(@"eeror %@", error);
//    }];

    [self sendRequestWithPost:[LY_MSG_BASE_URL stringByAppendingString:(NSString*)LY_MSG_USER_GET_USER_INFO] Param:dict success:^(id responseObject) {
        NSDictionary* dict = responseObject;
            NSLog(@"back %@", responseObject);
    }];

}


- (void)requestEditUserInfoWithToken:(NSString *)accessToken Name:(NSString *)nickName Gender:(NSString *)gender Address:(NSString *)address {
    NSMutableDictionary* dict = [NSMutableDictionary dictionaryWithObject:accessToken forKey:@"access_token"];
    if (nickName) {
        [dict setObject:nickName forKey:@"nickName"];
    }
    if (gender) {
        [dict setObject:gender forKey:@"gender"];
    }
    if (address) {
        [dict setObject:address forKey:@"address"];
    }
    [self sendRequestWithPost:[LY_MSG_BASE_URL stringByAppendingString:LY_MSG_USER_EDIT_USER_INFO] Param:dict success:^(id responseObject) {
        NSLog(@"edit back%@", [responseObject description]);
    }];
}


@end
