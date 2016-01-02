//
//  FriendModel.m
//  Yingying
//
//  Created by 林伟池 on 16/1/2.
//  Copyright © 2016年 林伟池. All rights reserved.
//

#import "FriendModel.h"
#import "UserModel.h"
#import "BaseMessage.h"

@interface FriendModel()

@end


@implementation FriendModel


#pragma mark - init


+ (instancetype)instance
{
    static id test;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        test = [[[self class] alloc] init];
    });
    return test;
}

#pragma mark - update



#pragma mark - get




#pragma mark - message

- (void)requestGetFriendList {
    BaseMessage* message = [BaseMessage backgroundInstance];
    [message sendRequestWithPost:[LY_MSG_BASE_URL stringByAppendingString:LY_MSG_FRIEND_GET_FRIEND_LIST] Param:@{@"access_token":[[UserModel instance] getMyAccessToken]} success:^(id responseObject) {
        
    }];
}

@end
