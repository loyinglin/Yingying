//
//  ChatDetailViewModel.m
//  Yingying
//
//  Created by 林伟池 on 16/1/7.
//  Copyright © 2016年 林伟池. All rights reserved.
//

#import "ChatDetailViewModel.h"

@implementation ChatDetailViewModel


#pragma mark - init


#pragma mark - update



#pragma mark - get




#pragma mark - message

- (RACSignal *)requestGetMoodInfoBySid:(NSNumber *)sid {
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        BaseMessage* message = [BaseMessage instance];
        message.myLoadingStrings = @"获取动态详情中...";
        if (!sid) {
            LYLog(@"ERROR");
            [subscriber sendError:nil];
            return nil;
        }
        [message sendRequestWithPost:[LY_MSG_BASE_URL stringByAppendingString:LY_MSG_MOOD_GET_MOOD_INFO_BY_SID] Param:@{@"access_token":[[UserModel instance] getMyAccessToken], @"sid":sid} success:^(id responseObject) {
            
        }];
        return nil;
    }];
}
@end
