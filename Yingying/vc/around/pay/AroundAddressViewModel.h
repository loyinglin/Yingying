//
//  AddressViewModel.h
//  Yingying
//
//  Created by 林伟池 on 15/12/16.
//  Copyright © 2015年 林伟池. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CityItem : NSObject

@property (nonatomic,copy) NSString  *pid;      //父级城市ID
@property (nonatomic,copy) NSString  *cityName; //城市名
@property (nonatomic,copy) NSString  *ids;      //城市ID

@end

@class CityItem;
@interface AroundAddressViewModel : NSObject


#pragma mark - init


#pragma mark - update

- (void)updateSelectedProvince:(long)index;

- (void)updateSelectedCity:(long)index;

- (void)updateSelectedArea:(long)index;

#pragma mark - get

- (long)getProvinceCount;

- (long)getCitysCount;

- (long)getAreasCount;

- (CityItem *)getProvinceByIndex:(long)index;

- (CityItem *)getCityByIndex:(long)index;

- (CityItem *)getAreaByIndex:(long)index;

- (NSString *)getAddressByProvince:(long)province City:(long)city Area:(long)area;

#pragma mark - message

@end
