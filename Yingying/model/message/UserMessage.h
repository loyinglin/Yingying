//
//  UserMessage.h
//  Yingying
//
//  Created by 林伟池 on 15/12/17.
//  Copyright © 2015年 林伟池. All rights reserved.
//

#import "BaseMessage.h"

@interface UserMessage : BaseMessage


- (void)requestOauthLoginWithUserphone:(NSString *)userphone Password:(NSString *)password;

- (void)requestGetUserInfoWithAccessToken:(NSString *)accessToken Userphone:(NSString *)userphone;

@end
