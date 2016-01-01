//
//  AroundMapViewModel.m
//  Yingying
//
//  Created by 林伟池 on 16/1/1.
//  Copyright © 2016年 林伟池. All rights reserved.
//

#import "AroundMapViewModel.h"
#import "BaseMessage.h"
#import "MapInfoModel.h"
#import "NSObject+LYUITipsView.h"
#import "UserModel.h"


@interface AroundMapViewModel()

@end

@implementation AroundMapViewModel


#pragma mark - init


#pragma mark - update

- (void)updateAroundMapLocation {
    if ([[UserModel instance] getNeedLogin]) {
        [self presentFailureTips:@"请登录以获取周边数据"];
        return ;
    }
    [self requestLocationRefreshLocationWithToken:[[UserModel instance] getMyAccessToken] Longitude:@([MapInfoModel instance].myPosition.longitude) Latitude:@([MapInfoModel instance].myPosition.latitude) Gender:self.myGender];
}

#pragma mark - get

- (NSNumber *)getLongitudeByIndex:(long)index {
    NSNumber* ret;
    if (index >= 0 && index < self.myMapUserInfoArr.count) {
        ret = [(MapUserInfo *)self.myMapUserInfoArr[index] x];
    }
    return ret;
}

- (NSNumber *)getlatitudeByIndex:(long)index {
    NSNumber* ret;
    if (index >= 0 && index < self.myMapUserInfoArr.count) {
        ret = [(MapUserInfo *)self.myMapUserInfoArr[index] y];
    }
    return ret;
}

- (MapUserInfo *)getMapUserInfoByIndex:(long)index {
    MapUserInfo* ret;
    if (index >= 0 && index <self.myMapUserInfoArr.count) {
        ret = self.myMapUserInfoArr[index];
    }
    return ret;
}


#pragma mark - message

- (void)requestLocationRefreshLocationWithToken:(NSString *)token Longitude:(NSNumber *)x Latitude:(NSNumber *)y Gender:(NSString *)gender {
    
    BaseMessage* message = [BaseMessage instance];
    message.myLoadingStrings = @"加载周边数据...";
    
    NSMutableDictionary* dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                 token, @"access_token",
                                 x, @"x",
                                 y, @"y",
                                 nil];
    if (gender) {
        [dict setObject:gender forKey:@"gender"];
    }
    @weakify(self);
    [message sendRequestWithPost:[LY_MSG_BASE_URL stringByAppendingString:LY_MSG_LOCATION_REFRESH_LOCATION] Param:dict success:^(id responseObject) {
        @strongify(self);
        NSArray* arr = responseObject;
        NSMutableArray* usersArr = [NSMutableArray array];
        for (NSDictionary* dict in arr) {
            if ([dict isKindOfClass:[NSDictionary class]]) {
                MapUserInfo* info = [dict objectForClass:[MapUserInfo class]];
                [usersArr addObject:info];
            }
        }
        self.myMapUserInfoArr = usersArr;
        
    }];

}
@end
