//
//  ChatSearchViewModel.h
//  Yingying
//
//  Created by 林伟池 on 16/1/2.
//  Copyright © 2016年 林伟池. All rights reserved.
//

#import "LYBaseViewModel.h"

@interface ChatSearchViewModel :LYBaseViewModel

@property (nonatomic , strong) NSString*        mySearchString;

#pragma mark - init


#pragma mark - get

- (long)getFriendInfoCount;
- (FriendInfo *)getFriendInfoByIndex:(long)index;

#pragma mark - update


#pragma mark - message

- (RACSignal *)requestSearchFriend;

@end
