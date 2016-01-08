//
//  YingYingFriendListViewModel.h
//  Yingying
//
//  Created by 林伟池 on 16/1/6.
//  Copyright © 2016年 林伟池. All rights reserved.
//

#import "LYBaseViewModel.h"

@interface YingYingFriendListViewModel : LYBaseViewModel

@property (nonatomic , strong) NSArray<Friend *>* myFriends;


#pragma mark - init


#pragma mark - set



#pragma mark - get

- (long)getSectionsCount;

- (long)getFriendsCountBySection:(long)section;

- (NSArray<NSString *> *)getIndexsArray;

- (Friend *)getFriendByIndex:(long)index Section:(long)section;



// search
- (long)getSearchSectionsCount;

- (long)getSearchFriendsCountBySection:(long)section;

- (NSArray<NSString *> *)getSearchIndexsArray;

- (Friend *)getSearchFriendByIndex:(long)index Section:(long)section;
#pragma mark - update

- (void)searchWithText:(NSString *)text;

#pragma mark - message

- (RACSignal *)requestGetFriendList;


@end
