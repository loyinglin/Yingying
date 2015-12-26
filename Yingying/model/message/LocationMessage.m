//
//  LocationMessage.m
//  Yingying
//
//  Created by 林伟池 on 15/12/25.
//  Copyright © 2015年 林伟池. All rights reserved.
//

#import "LocationMessage.h"

@implementation LocationMessage

- (void)requestLocationRefreshLocationWithToken:(NSString *)token Longitude:(float)x Latitude:(float)y Gender:(NSString *)gender {
    NSMutableDictionary* dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                 token, @"access_token",
                                 @(x), @"x",
                                 @(y), @"y",
                                 nil];
    if (gender) {
        [dict setObject:gender forKey:@"gender"];
    }
    [self sendRequestWithPost:[LY_MSG_BASE_URL stringByAppendingString:LY_MSG_LOCATION_REFRESH_LOCATION] Param:dict success:^(id responseObject) {
        NSDictionary* dict = responseObject;
        if ([dict isKindOfClass:[NSDictionary class]]) {
            if ([dict objectForKey:@"msg_desc"]) {
                LYLog(@"back %@", [dict objectForKey:@"msg_desc"]);
            }
        }
    }];
}

@end
