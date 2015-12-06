//
//  MyTransferViewModel.h
//  Yingying
//
//  Created by 林伟池 on 15/12/5.
//  Copyright © 2015年 林伟池. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveCocoa.h>
#import <ReactiveCocoa/RACEXTScope.h>
#import "Yingying.h"

@interface MyTransferViewModel : NSObject

@property (nonatomic , strong) NSArray<Friend *>* myFriends;


#pragma mark - init


#pragma mark - set



#pragma mark - get

- (long)getSectionsCount;

- (long)getFriendsCountBySection:(long)section;

- (NSArray<NSString *> *)getIndexsArray;

- (Friend *)getFriendByIndex:(long)index Section:(long)section;


#pragma mark - update



#pragma mark - message


@end
