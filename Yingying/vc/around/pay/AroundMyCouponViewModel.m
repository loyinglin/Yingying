//
//  AroundMyCouponViewModel.m
//  Yingying
//
//  Created by 林伟池 on 16/1/8.
//  Copyright © 2016年 林伟池. All rights reserved.
//

#import "AroundMyCouponViewModel.h"

@interface AroundMyCouponViewModel()
@property (nonatomic , strong) NSArray* myCouponsArray;
@end

@implementation AroundMyCouponViewModel



#pragma mark - init


#pragma mark - update



#pragma mark - get

- (long)getCouponCount {
    long ret = 0;
    if (self.myCouponsArray) {
        ret = self.myCouponsArray.count;
    }
    return ret;
}

- (TicketInfo *)getCouponbyIndex:(long)index {
    TicketInfo* ret;
    if (index >= 0 && index < self.myCouponsArray.count) {
        ret = self.myCouponsArray[index];
    }
    return ret;
}
#pragma mark - message

- (RACSignal *)requestGetMyCoupon {
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        if (!self.myType) {
            [subscriber sendError:nil];
            return nil;
        }
        BaseMessage* message = [BaseMessage instance];
        message.myLoadingStrings = @"获取中...";
        [message sendRequestWithPost:[LY_MSG_BASE_URL stringByAppendingString:LY_MSG_USER_GET_TICKETS] Param:@{LY_MSG_KEY_TOKEN:[[UserModel instance] getMyAccessToken], @"type":self.myType} success:^(id responseObject) {
            NSArray* arr = responseObject;
            NSMutableArray* newArr = [NSMutableArray array];
            if ([arr isKindOfClass:[NSArray class]]) {
                for (NSDictionary* dict in arr) {
                    if ([dict isKindOfClass:[NSDictionary class]]) {
                        TicketInfo* info = [dict objectForClass:[TicketInfo class]];
                        if (info.type && info.type == self.myType) {
                            [newArr addObject:info];
                        }
                    }
                }
            }
            self.myCouponsArray = newArr;
            [subscriber sendCompleted];
        }];
        
        return nil;
    }];
}

@end
