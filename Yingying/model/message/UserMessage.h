//
//  UserMessage.h
//  Yingying
//
//  Created by 林伟池 on 15/12/17.
//  Copyright © 2015年 林伟池. All rights reserved.
//

#import "BaseMessage.h"

@interface UserMessage : BaseMessage

- (void)requestChangePasswordWithToken:(NSString *)token Password:(NSString *)password;

- (void)requestLoginWithUserphone:(NSString *)userphone Code:(NSString *)code;

- (void)requestSendCodeWithUserphone:(NSString *)userphone;

- (void)requestRegisterWithUserphone:(NSString *)userphone Password:(NSString *)password VerifyCode:(NSString *)verifyCode;

- (void)requestOauthLoginWithUserphone:(NSString *)userphone Password:(NSString *)password;

- (void)requestGetUserInfoWithAccessToken:(NSString *)accessToken Userphone:(NSString *)userphone;

- (void)requestEditUserInfoWithToken:(NSString *)accessToken Name:(NSString *)nickName Gender:(NSString *)gender Address:(NSString *)address;
@end
