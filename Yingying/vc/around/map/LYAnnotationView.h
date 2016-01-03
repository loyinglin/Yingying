//
//  LYAnnotationView.h
//  Yingying
//
//  Created by 林伟池 on 15/12/10.
//  Copyright © 2015年 林伟池. All rights reserved.
//

#import <BaiduMapAPI_Map/BMKAnnotationView.h>

@interface LYAnnotationView : BMKAnnotationView

- (void)customViewWithGenderIsMalf:(BOOL)isMale AvatarUrl:(NSString *)avatarStr;

@end
