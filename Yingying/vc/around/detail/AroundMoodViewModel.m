//
//  AroundMoodViewModel.m
//  Yingying
//
//  Created by 林伟池 on 15/12/30.
//  Copyright © 2015年 林伟池. All rights reserved.
//

#import "AroundMoodViewModel.h"
#import "UserModel.h"
#import "MoodMessage.h"
#import "NSObject+LYUITipsView.h"

@implementation AroundMoodViewModel


#pragma mark - init


#pragma mark - update



#pragma mark - get




#pragma mark - message

- (void)requestGetMoodNearMoodWithLongitude:(NSNumber *)x Latitude:(NSNumber *)y PageIndex:(NSNumber *)pageIndex {
    if ([[UserModel instance] getNeedLogin]) {
        [self presentMessageTips:@"请先登录"];
    }
    else {
        MoodMessage* message = [MoodMessage instance];
        message.myLoadingStrings = @"获取中...";
        [message requestGetMoodNearMoodWithToken:[[UserModel instance] getMyAccessToken] Longitude:x Latitude:y PageIndex:pageIndex];
    }
}



@end
