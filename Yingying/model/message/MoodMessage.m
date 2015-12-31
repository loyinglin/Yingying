//
//  MoodMessage.m
//  Yingying
//
//  Created by 林伟池 on 15/12/30.
//  Copyright © 2015年 林伟池. All rights reserved.
//

#import "MoodMessage.h"

@implementation MoodMessage

- (void)requestGetMoodNearMoodWithToken:(NSString *)access_token Longitude:(NSNumber *)x Latitude:(NSNumber *)y PageIndex:(NSNumber *)pageIndex {
    
    NSMutableDictionary* dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                 access_token, @"access_token",
                                 x, @"x",
                                 y, @"y",
                                 nil];
    
    if(pageIndex) {
        [dict setObject:pageIndex forKey:@"pageIndex"];
    }

    [self sendRequestWithPost:[LY_MSG_BASE_URL stringByAppendingString:LY_MSG_MOOD_GET_NEAR_MOOD] Param:dict success:^(id responseObject) {
        NSDictionary* dict = responseObject;
        if ([dict isKindOfClass:[NSDictionary class]]) {
            if ([dict objectForKey:@"last_index"]) {
                LYLog(@"back %@", [dict objectForKey:@"last_index"]);
            }
        }
    }];

}


- (void)requestSendMoodWithToken:(NSString *)access_token MoodContent:(NSString *)moodContent ThumbsUrl:(NSArray *)thumbsUrl Longitude:(NSNumber *)x Latitude:(NSNumber *)y LocName:(NSString *)locName {
    
    NSMutableDictionary* dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                 access_token, @"access_token",
                                 moodContent, @"moodContent",
                                 @(0),  @"type",
                                 nil];
    if (thumbsUrl) {
        [dict setObject:thumbsUrl forKey:@"thumbsurl"];
    }
    if (locName.length > 0) {
        [dict setObject:x forKey:@"x"];
        [dict setObject:y forKey:@"y"];
//        locName = [locName stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [dict setObject:locName forKey:@"locName"];
    }
    
    [self sendRequestWithPost:[LY_MSG_BASE_URL stringByAppendingString:LY_MSG_MOOD_SEND_MOOD] Param:dict success:^(id responseObject) {
        
    }];

}
@end
