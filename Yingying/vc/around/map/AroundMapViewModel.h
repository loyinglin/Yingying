//
//  AroundMapViewModel.h
//  Yingying
//
//  Created by 林伟池 on 16/1/1.
//  Copyright © 2016年 林伟池. All rights reserved.
//

#import <ReactiveCocoa.h>
#import <ReactiveCocoa/RACEXTScope.h>
#import <Foundation/Foundation.h>
#import "Yingying.h"


@interface AroundMapViewModel : NSObject

@property (nonatomic , strong) NSString*    myGender;

@property (nonatomic , strong) NSArray*     myMapUserInfoArr;

#pragma mark - init


#pragma mark - update

- (void)updateAroundMapLocation;


#pragma mark - get

- (NSNumber *)getLongitudeByIndex:(long)index;

- (NSNumber *)getlatitudeByIndex:(long)index;

- (MapUserInfo *)getMapUserInfoByIndex:(long)index;

#pragma mark - message


@end
