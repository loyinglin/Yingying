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
#import "MapInfoModel.h"
#import <ReactiveCocoa/RACEXTScope.h>

@interface AroundMoodViewModel()

@property (nonatomic , strong) NSNumber* myLastIndex;

@end

@implementation AroundMoodViewModel


#pragma mark - init


#pragma mark - update

- (void)updateAppendNewMoods:(NSArray *)arr {
    self.myMoodsArr = [self.myMoodsArr arrayByAddingObjectsFromArray:arr];
}

- (void)updateInitWithNewMoods:(NSArray *)arr {
    self.myMoodsArr = arr;
}

- (void)updateRequestInitMoods {
    [self requestGetMoodNearMoodWithLongitude:@([MapInfoModel instance].myPosition.longitude) Latitude:@([MapInfoModel instance].myPosition.latitude) PageIndex:nil];
}

- (void)updateRequestMoreMoods {
    [self requestGetMoodNearMoodWithLongitude:@([MapInfoModel instance].myPosition.longitude) Latitude:@([MapInfoModel instance].myPosition.latitude) PageIndex:self.myLastIndex];
}
#pragma mark - get

- (long)getMoodsCount {
    return self.myMoodsArr.count;
}

- (MoodInfo *)getMoodInfoByIndex:(long)index {
    MoodInfo* ret = nil;
    if (index >= 0 && index < self.myMoodsArr.count) {
        ret = self.myMoodsArr[index];
    }
    
    return ret;
}



#pragma mark - message

- (void)requestGetMoodNearMoodWithLongitude:(NSNumber *)x Latitude:(NSNumber *)y PageIndex:(NSNumber *)pageIndex {
    BaseMessage* message = [BaseMessage instance];
    message.myLoadingStrings = @"获取中...";
    
    NSMutableDictionary* dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                 [[UserModel instance] getMyAccessToken], @"access_token",
                                 x, @"x",
                                 y, @"y",
                                 nil];
    
    if (pageIndex) {
        [dict setObject:pageIndex forKey:@"last_index"];
    }
    
    @weakify(self);
    [message sendRequestWithPost:[LY_MSG_BASE_URL stringByAppendingString:LY_MSG_MOOD_GET_NEAR_MOOD] Param:dict success:^(id responseObject) {
        @strongify(self);
        NSDictionary* dict = responseObject;
        if ([dict isKindOfClass:[NSDictionary class]]) {
            self.myLastIndex = [dict objectForKey:@"last_index"];
            NSArray* moods = [dict objectForKey:@"mood"];
            NSMutableArray* newItems = [NSMutableArray array];
            if ([moods isKindOfClass:[NSArray class]]) {
                for (NSDictionary* item in moods) {
                    MoodInfo* info = [item objectForClass:[MoodInfo class]];
                    [newItems addObject:info];
                }
            }
            if (pageIndex) {
                [self updateAppendNewMoods:newItems];
            }
            else {
                [self updateInitWithNewMoods:newItems];
            }
        }
    }];
}



@end
