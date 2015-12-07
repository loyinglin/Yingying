//
//  MapModel.m
//  Yingying
//
//  Created by 林伟池 on 15/12/7.
//  Copyright © 2015年 林伟池. All rights reserved.
//

#import "MapInfoModel.h"

@interface MapInfoModel()

@end


@implementation MapInfoModel


#pragma mark - init


+(instancetype) instance
{
    static id test;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        test = [[[self class] alloc] init];
    });
    return test;
}


#pragma mark - update

- (void)updateCurrentPositionWithAddress:(NSString *)address {
    self.myAddress = address;
}

- (void)updatecurrentLocationWith:(CLLocationCoordinate2D)location {
    self.myPosition = location;
}

#pragma mark - get


#pragma mark - message

@end
