//
//  AroundMyCouponViewModel.h
//  Yingying
//
//  Created by 林伟池 on 16/1/8.
//  Copyright © 2016年 林伟池. All rights reserved.
//

#import "LYBaseViewModel.h"

@interface AroundMyCouponViewModel : LYBaseViewModel

@property (nonatomic , strong) NSNumber* myType;

#pragma mark - init


#pragma mark - update



#pragma mark - get


- (long)getCouponCount;

- (TicketInfo *)getCouponbyIndex:(long)index;



#pragma mark - message

- (RACSignal *)requestGetMyCoupon;

@end
