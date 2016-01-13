//
//  UserModel.h
//  Yingying
//
//  Created by 林伟池 on 15/12/17.
//  Copyright © 2015年 林伟池. All rights reserved.
//

#import "BaseModel.h"

@interface UserModel : BaseModel

@property (nonatomic , strong) NSNumber* myUid;
@property (nonatomic , strong) NSString* myHeadUrl;

#pragma mark - init

+ (instancetype)instance;

#pragma mark - update

- (void)updateWithLoginInfo:(LoginInfo *)info;

- (void)updateWithUserInfo:(UserInfo *)info;

- (void)updateWithUserLogout;

#pragma mark - get

- (UserInfo *)getMyUserInfo;

- (BOOL)getNeedLogin;

- (NSString *)getMyAccessToken;

- (NSString *)getMyUserphone;
#pragma mark - message

- (void)requestChangePasswordWithPassword:(NSString *)password;

- (void)requestLoginWithUserphone:(NSString *)userphone Code:(NSString *)code;

- (void)requestSendCodeWithUserphone:(NSString *)userphone;

- (void)requestRegisterWithUserphone:(NSString *)userphone Password:(NSString *)password VerifyCode:(NSString *)verifyCode;

- (void)requestOauthLoginWithUserphone:(NSString *)userphone Password:(NSString *)password;

- (void)requestGetUserInfo;

- (void)requestEditUserInfoWithName:(NSString *)nickName Gender:(NSString *)gender Address:(NSString *)address;

- (void)requestLoactionRefreshLocationWithLongitude:(float)x Latitude:(float)y Gender:(NSString *)gender;


@end
