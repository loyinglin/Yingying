//
//  ChatSearchViewModel.m
//  Yingying
//
//  Created by 林伟池 on 16/1/2.
//  Copyright © 2016年 林伟池. All rights reserved.
//

#import "ChatSearchViewModel.h"

@interface ChatSearchViewModel()
@property (nonatomic , strong) NSArray*             myFriendsArr;

@end

@implementation ChatSearchViewModel


#pragma mark - init

- (instancetype)init {
    self = [super init];
    
    return self;
}

#pragma mark - set

#pragma mark - get

- (long)getFriendInfoCount {
    long ret = 0;
    if (self.myFriendsArr) {
        ret = self.myFriendsArr.count;
    }
    return ret;
}

- (FriendInfo *)getFriendInfoByIndex:(long)index {
    FriendInfo* ret;
    if (index >= 0 && index < self.myFriendsArr.count) {
        ret = [self.myFriendsArr objectAtIndex:index];
    }
    return ret;
}

#pragma mark - update

#pragma mark - message

- (RACSignal *)requestSearchFriend {
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        BaseMessage* message = [BaseMessage instance];
//        message.myLoadingStrings = @"搜索
        [message sendRequestWithPost:[LY_MSG_BASE_URL stringByAppendingString:LY_MSG_FRIEND_FIND_FRIEND] Param:@{@"access_token":[[UserModel instance] getMyAccessToken], @"nickname":self.mySearchString} success:^(id responseObject) {
            NSArray* arr = responseObject;
            NSMutableArray* newArr = [NSMutableArray array];
            if ([arr isKindOfClass:[NSArray class]]) {
                for (NSDictionary* dict in arr) {
                    if ([dict isKindOfClass:[NSDictionary class]]) {
                        FriendInfo* info = [dict objectForClass:[FriendInfo class]];
                        [newArr addObject:info];
                    }
                }
            }
            self.myFriendsArr = newArr;
            [subscriber sendNext:@"ok"];
            [subscriber sendCompleted];
        }];
        
        return nil;
    }];
}


- (RACSignal *)requestGetFriendList {
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, NSEC_PER_SEC * 3), dispatch_get_main_queue(), ^{
            LYLog(@"request");
            [subscriber sendNext:@"ABC"];
            [subscriber sendCompleted];
        });
        
        return nil;
    }];
}
@end
