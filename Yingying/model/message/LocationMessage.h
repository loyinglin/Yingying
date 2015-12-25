//
//  LocationMessage.h
//  Yingying
//
//  Created by 林伟池 on 15/12/25.
//  Copyright © 2015年 林伟池. All rights reserved.
//

#import "BaseMessage.h"

@interface LocationMessage : BaseMessage

- (void)requestLocationRefreshLocationWithToken:(NSString *)token Longitude:(float)x Latitude:(float)y Gender:(NSString *)gender;

@end
