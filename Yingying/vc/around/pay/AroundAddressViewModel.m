//
//  AddressViewModel.m
//  Yingying
//
//  Created by 林伟池 on 15/12/16.
//  Copyright © 2015年 林伟池. All rights reserved.
//

#import "AroundAddressViewModel.h"

@implementation CityItem


@end

@interface AroundAddressViewModel()

@property (nonatomic , strong) NSArray*     myTotalCitys;
@property (nonatomic , strong) NSArray*     myProvinces;
@property (nonatomic , strong) NSArray*     myCitys;
@property (nonatomic , strong) NSArray*     myAreas;

@end

@implementation AroundAddressViewModel

#pragma mark - init
- (instancetype)init {
    self = [super init];
    [self readData];
    
    return self;
}



-(void)readData{
    NSString *path=[[NSBundle mainBundle] pathForResource:@"china" ofType:@"txt"];
    char  pid[30],name[30],ids[30];
    
    FILE *f=fopen([path UTF8String], "r");
    NSMutableArray* cityArr = [NSMutableArray array];
    NSMutableArray* provinceArr = [NSMutableArray array];
    while (!feof(f)) {
        CityItem *city=[[CityItem alloc] init];
        fscanf(f, " %s %s %s ",ids,name,pid);
        NSString *pids=[NSString stringWithUTF8String:pid];
        NSString *names=[NSString stringWithUTF8String:name];
        NSString *idss=[NSString stringWithUTF8String:ids];
        city.ids=idss;
        city.pid=pids;
        city.cityName=names;
        [cityArr addObject:city];
        if ([city.pid isEqualToString:@"0"]) {
            [provinceArr addObject:city];
        }
    }
    self.myProvinces = provinceArr;
    self.myTotalCitys = cityArr;
    LYLog(@"total city item %ld province %ld", cityArr.count, provinceArr.count);
    
}
#pragma mark - update

- (void)updateSelectedProvince:(long)index {
    if (index >= self.myProvinces.count) {
        return ;
    }
    CityItem* selectedProvince = self.myProvinces[index];
    NSMutableArray* arr = [NSMutableArray array];
    for (CityItem* item in self.myTotalCitys) {
        if ([item.pid isEqualToString:selectedProvince.ids]) {
            [arr addObject:item];
        }
    }
    self.myCitys = arr;
}

- (void)updateSelectedCity:(long)index {
    if (index >= self.myCitys.count) {
        return ;
    }
    CityItem* selectedProvince = self.myCitys[index];
    NSMutableArray* arr = [NSMutableArray array];
    for (CityItem* item in self.myTotalCitys) {
        if ([item.pid isEqualToString:selectedProvince.ids]) {
            [arr addObject:item];
        }
    }
    self.myAreas = arr;
}

- (void)updateSelectedArea:(long)index {
    if (index >= self.myAreas.count) {
        return ;
    }
}


#pragma mark - get

- (long)getProvinceCount {
    return self.myProvinces.count;
}

- (long)getCitysCount {
    return self.myCitys.count;
}

- (long)getAreasCount {
    return self.myAreas.count;
}

- (CityItem *)getProvinceByIndex:(long)index {
    if (self.myProvinces.count <= index) {
        return nil;
    }
    return self.myProvinces[index];
}

- (CityItem *)getCityByIndex:(long)index {
    if (self.myCitys.count <= index) {
        return nil;
    }
    return self.myCitys[index];
}

- (CityItem *)getAreaByIndex:(long)index {
    if (self.myAreas.count <= index) {
        return nil;
    }
    return self.myAreas[index];
}

- (NSString *)getAddressByProvince:(long)province City:(long)city Area:(long)area {
    NSString* ret = @"";
    ret = [ret stringByAppendingString:[self getProvinceByIndex:province].cityName];
    if (city >= self.myCitys.count) {
        city = self.myCitys.count - 1;
    }
    if (city >= 0) {
        ret = [ret stringByAppendingString:[self getCityByIndex:city].cityName];
    }
    if (area >= self.myAreas.count) {
        area = self.myAreas.count - 1;
    }
    if (area >= 0) {
        ret = [ret stringByAppendingString:[self getAreaByIndex:area].cityName];
    }
    return ret;
}
#pragma mark - message

@end
