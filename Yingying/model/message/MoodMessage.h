//
//  MoodMessage.h
//  Yingying
//
//  Created by 林伟池 on 15/12/30.
//  Copyright © 2015年 林伟池. All rights reserved.
//

#import "BaseMessage.h"

@interface MoodMessage : BaseMessage

- (void)requestGetMoodNearMoodWithToken:(NSString *)access_token Longitude:(NSNumber *)x Latitude:(NSNumber *)y PageIndex:(NSNumber *)pageIndex;



- (void)requestSendMoodWithToken:(NSString *)access_token MoodContent:(NSString *)moodContent ThumbsUrl:(NSArray *)thumbsUrl Longitude:(NSNumber *)x Latitude:(NSNumber *)y LocName:(NSString *)locName;
@end
