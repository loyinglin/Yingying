//
//  PersonalHomePageViewModel.h
//  Yingying
//
//  Created by 林伟池 on 15/12/9.
//  Copyright © 2015年 林伟池. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveCocoa.h>
#import <ReactiveCocoa/RACEXTScope.h>
#import "Yingying.h"

@interface PersonalHomePageViewModel : NSObject

@property (nonatomic , assign) BOOL mySelf;
@property (nonatomic , assign) BOOL myFriend;

@property (nonatomic , strong) NSString*    myUserphone;
@property (nonatomic , strong) UserInfo*    myUserInfo;
@property (nonatomic , strong) NSNumber*    myUid;
@property (nonatomic , strong) NSString*    myAvatarUrl;
@property (nonatomic , strong) NSArray*     myPhotosArr;
@property (nonatomic , strong) NSArray*     myMoodsArr;

@property (nonatomic , strong) UIView*      myView;

#pragma mark - init


#pragma mark - update


#pragma mark - get

- (NSString *)getImageUrlbyIndex:(long)index;

- (NSNumber *)getImageIdbyIndex:(long)index;

- (MoodInfo *)getMoodInfoByIndex:(long)index;

#pragma mark - message

- (RACSignal *)requestGetUserInfo;
- (RACSignal *)requestGetMoodList;
- (RACSignal *)requestAddPhotoWithImage:(UIImage *)image;
- (RACSignal *)requestUploadAvatarWithImage:(UIImage *)image;
- (RACSignal *)requestDeletePhoteWithPhotoId:(NSNumber *)photoId;
@end
