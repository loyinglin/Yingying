//
//  UserModel.h
//  Yingying
//
//  Created by 林伟池 on 15/12/17.
//  Copyright © 2015年 林伟池. All rights reserved.
//

#import "BaseModel.h"

@interface UserModel : BaseModel


#pragma mark - init

+ (instancetype)instance;

#pragma mark - update

- (void)updateWithPhone:(NSString *)phone AccessToken:(NSString *)access TokenType:(NSString *)tokenType Expires:(NSNumber *)expires;


#pragma mark - get




#pragma mark - message

- (void)requestOauthLoginWithUserphone:(NSString *)userphone Password:(NSString *)password;

- (void)requestGetUserInfo;

@end
