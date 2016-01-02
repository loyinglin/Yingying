//
//  FriendModel.m
//  Yingying
//
//  Created by 林伟池 on 16/1/2.
//  Copyright © 2016年 林伟池. All rights reserved.
//

#import "FriendModel.h"

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

- (RACSignal *)requestAddFriendWith:(NSNumber *)uid {
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        BaseMessage* message = [BaseMessage instance];
        message.myLoadingStrings = @"添加好友中...";
        [message sendRequestWithPost:[LY_MSG_BASE_URL stringByAppendingString:LY_MSG_FRIEND_ADD_FRIEND] Param:@{@"access_token":[[UserModel instance] getMyAccessToken], @"frduid":uid} success:^(id responseObject) {
           
            [subscriber sendCompleted];
        }];
        
        return nil;
    }];
}

- (RACSignal *)requestDeleteFriendWithUid:(NSNumber *)uid {
    
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        BaseMessage* message = [BaseMessage instance];
        message.myLoadingStrings = @"删除好友中...";
        [message sendRequestWithPost:[LY_MSG_BASE_URL stringByAppendingString:LY_MSG_FRIEND_DELETE_FRIEND] Param:@{@"access_token":[[UserModel instance] getMyAccessToken], @"frduid":uid} success:^(id responseObject) {
            
            [subscriber sendCompleted];
        }];
        
        return nil;
    }];
}
@end
