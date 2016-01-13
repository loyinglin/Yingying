//
//  UserMessage.m
//  Yingying
//
//  Created by 林伟池 on 15/12/17.
//  Copyright © 2015年 林伟池. All rights reserved.
//

#import "UserMessage.h"
#import "UserModel.h"
#import "YingYingUserModel.h"
#import "NSObject+LYUITipsView.h"

@implementation UserMessage

- (void)requestChangePasswordWithToken:(NSString *)token Password:(NSString *)password {
    if (token && password) {
        [self sendRequestWithPost:[LY_MSG_BASE_URL stringByAppendingString:LY_MSG_USER_CHANGE_PASSWORD] Param:@{@"access_token":token, @"password":password} success:^(id responseObject) {
            NSDictionary* dict = responseObject;
            if ([dict isKindOfClass:[NSDictionary class]]) {
                NSNumber* code = [dict objectForKey:@"msg_code"];
                if ([code isKindOfClass:[NSNumber class]] && code.integerValue == LY_MSG_CODE_SUCCESS) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_SERVER_CHANGE_PASSWORD_SUCCESS object:nil];
                }
                else {
                    [self presentMessageTips:@"重置密码失败"];
                }
            }
            else {
                [self presentMessageTips:@"重置密码失败"];
            }
        }];
    }
}

- (void)requestLoginWithUserphone:(NSString *)userphone Code:(NSString *)code {
    if (userphone && code) {
        [self sendRequestWithPost:[LY_MSG_BASE_URL stringByAppendingString:LY_MSG_JUDGE_CODE] Param:@{@"userphone":userphone, @"verifyCode":code} success:^(id responseObject) {
            NSDictionary* dict = responseObject;
            if ([dict isKindOfClass:[NSDictionary class]] && [dict objectForKey:@"access_token"]) {
                LoginInfo* info = [dict objectForClass:[LoginInfo class]];
                info.userphone = userphone;
                [[UserModel instance] updateWithLoginInfo:info];
                [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_SERVER_JUDGE_CODE_SUCCESS object:nil];
                //拉去用户的UID
                [[UserModel instance] requestGetUserInfo];
            }
            else {
                [self presentMessageTips:@"验证失败"];
            }
        }];
    }
}

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
        else {
            [self presentMessageTips:@"注册失败"];
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
            //拉取必要的UID
            [[UserModel instance] requestGetUserInfo];
        }
        else {
            [self presentMessageTips:@"登录失败"];
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
            
            
            if ([UserModel instance].myUid) {
                NSDictionary* head = [dict objectForKey:@"headImg"];
                if (head && [head objectForKey:@"thumbUrl"]) {
                    NSString* myAvatarUrl = [LY_MSG_BASE_URL stringByAppendingString:[head objectForKey:@"thumbUrl"]];
                    [UserModel instance].myHeadUrl = myAvatarUrl;
                    [[YingYingUserModel instance] updateAddUserWithName:[[UserModel instance] getMyUserInfo].nickName Uid:[UserModel instance].myUid Url:myAvatarUrl];
                }
            }
            
            if ([userInfo isKindOfClass:[NSDictionary class]]) {
                UserInfo* info = [userInfo objectForClass:[UserInfo class]];
                [[UserModel instance] updateWithUserInfo:info];
                [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_SERVER_GET_USERINFO_SUCCESS object:nil];
            }
        }
        else {
            [self presentMessageTips:@"拉取用户信息失败"];
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
