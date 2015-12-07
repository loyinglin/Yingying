//
//  MapModel.h
//  Yingying
//
//  Created by 林伟池 on 15/12/7.
//  Copyright © 2015年 林伟池. All rights reserved.
//

#import "BaseModel.h"
#import <CoreLocation/CoreLocation.h>

@interface MapInfoModel : BaseModel

@property (nonatomic , strong) NSString* myAddress;
@property (nonatomic , assign) CLLocationCoordinate2D myPosition;


#pragma mark - init

+ (instancetype)instance;


#pragma mark - update

- (void)updateCurrentPositionWithAddress:(NSString *)address;

- (void)updatecurrentLocationWith:(CLLocationCoordinate2D)location;

#pragma mark - get


#pragma mark - message

@end
