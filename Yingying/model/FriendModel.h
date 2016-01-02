//
//  FriendModel.h
//  Yingying
//
//  Created by 林伟池 on 16/1/2.
//  Copyright © 2016年 林伟池. All rights reserved.
//

#import "BaseModel.h"
#import "LYBaseViewModel.h"

@interface FriendModel : BaseModel


#pragma mark - init

+ (instancetype)instance;

#pragma mark - update



#pragma mark - get




#pragma mark - message

- (void)requestGetFriendList;
- (RACSignal *)requestAddFriendWith:(NSNumber *)uid;
- (RACSignal *)requestDeleteFriendWithUid:(NSNumber *)uid;

@end
