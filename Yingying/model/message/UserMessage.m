//
//  UserMessage.m
//  Yingying
//
//  Created by 林伟池 on 15/12/17.
//  Copyright © 2015年 林伟池. All rights reserved.
//

#import "UserMessage.h"
#import "UserModel.h"
#import "NSObject+LYUITipsView.h"

@implementation UserMessage

- (void)requestSendCodeWithUserphone:(NSString *)userphone {
    NSDictionary* dict = [[NSDictionary alloc] initWithObjectsAndKeys:userphone, @"userphone", nil];
    
    [self sendRequestWithPost:[LY_MSG_BASE_URL stringByAppendingString:LY_MSG_SEND_CODE] Param:dict success:^(id responseObject) {
        NSDictionary* dict = responseObject;
        if ([dict isKindOfClass:[NSDictionary class]]) {
            if ([[dict objectForKey:@"msg_desc"] isKindOfClass:[NSString class]]) {
                [self presentMessageTips:[dict objectForKey:@"msg_desc"]];
            }
        }
    }];
}


- (void)requestRegisterWithUserphone:(NSString *)userphone Password:(NSString *)password VerifyCode:(NSString *)verifyCode {
    NSDictionary* dict = [[NSDictionary alloc] initWithObjectsAndKeys:
                          userphone, @"userphone",
                          password, @"password",
                          verifyCode, @"verifyCode",
                          nil];
    
    [self sendRequestWithPost:[LY_MSG_BASE_URL stringByAppendingString:LY_MSG_REGISTER] Param:dict success:^(id responseObject) {
        
        NSDictionary* dict = responseObject;
        if ([dict isKindOfClass:[NSDictionary class]] && [dict objectForKey:@"access_token"]) {
            LoginInfo* info = [dict objectForClass:[LoginInfo class]];
            info.userphone = userphone;
            [[UserModel instance] updateWithLoginInfo:info];
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_SERVER_REGISTER_SUCCESS object:nil];
        }
    }];
}

- (void)requestOauthLoginWithUserphone:(NSString *)userphone Password:(NSString *)password {
    
    NSDictionary* dict = [[NSDictionary alloc] initWithObjectsAndKeys:
                          userphone, @"userphone",
                          password, @"password",
                          nil];
    
    [self sendRequestWithPost:[LY_MSG_BASE_URL stringByAppendingString:(NSString*)LY_MSG_OAUTH_LOGIN] Param:dict success:^(id responseObject) {
        NSDictionary* dict = responseObject;
        if ([dict isKindOfClass:[NSDictionary class]] && [dict objectForKey:@"access_token"]) {
            LoginInfo* info = [dict objectForClass:[LoginInfo class]];
            info.userphone = userphone;
            [[UserModel instance] updateWithLoginInfo:info];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_SERVER_LOGIN_SUCCESS object:nil];
        }
    }];

}

- (void)requestGetUserInfoWithAccessToken:(NSString *)accessToken Userphone:(NSString *)userphone {
    
    NSDictionary* dict = [[NSDictionary alloc] initWithObjectsAndKeys:
                          accessToken, @"access_token",
                          userphone, @"userphone",
                          nil];
    
    [self sendRequestWithPost:[LY_MSG_BASE_URL stringByAppendingString:(NSString*)LY_MSG_USER_GET_USER_INFO] Param:dict success:^(id responseObject) {
        NSDictionary* dict = responseObject;
        if ([dict isKindOfClass:[NSDictionary class]] && [dict objectForKey:@"userInfo"]) {
            [UserModel instance].myUid = [dict objectForKey:@"id"]; //先设置
            NSDictionary* userInfo = [dict objectForKey:@"userInfo"];
            if ([userInfo isKindOfClass:[NSDictionary class]]) {
                UserInfo* info = [userInfo objectForClass:[UserInfo class]];
                [[UserModel instance] updateWithUserInfo:info];
                [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_SERVER_GET_USERINFO_SUCCESS object:nil];
            }
        }
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
        NSLog(@"desc %@", [(NSDictionary *)responseObject objectForKey:@"msg_desc"]);
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_SERVER_EDIT_USERINFO_SUCCESS object:nil];
    }];
}


@end
