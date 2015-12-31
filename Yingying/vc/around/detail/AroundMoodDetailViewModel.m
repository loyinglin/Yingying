//
//  AroundMoodDetailViewModel.m
//  Yingying
//
//  Created by 林伟池 on 16/1/1.
//  Copyright © 2016年 林伟池. All rights reserved.
//

#import "AroundMoodDetailViewModel.h"
#import "UserModel.h"
#import "BaseMessage.h"

@implementation AroundMoodDetailViewModel


#pragma mark - init


#pragma mark - update

- (void)updateGetMoodComment {
    [self requestMoodBySidWithToken:[[UserModel instance] getMyAccessToken] Sid:self.myMoodInfo.sid];
}


#pragma mark - get




#pragma mark - message

- (void)requestMoodBySidWithToken:(NSString *)token Sid:(NSNumber *)sid {
    BaseMessage* message = [BaseMessage instance];
    message.myLoadingStrings = @"获取评论列表";
    
    [message sendRequestWithPost:[LY_MSG_BASE_URL stringByAppendingString:LY_MSG_MOOD_GET_COMMENT_BY_SID] Param:@{@"access_token":token, @"sid":sid} success:^(id responseObject) {
        
    }];
}
@end
