//
//  UserModel.m
//  Yingying
//
//  Created by 林伟池 on 15/12/17.
//  Copyright © 2015年 林伟池. All rights reserved.
//

#import "UserModel.h"
#import "MapInfoModel.h"
#import "UserMessage.h"
#import "LocationMessage.h"

@interface UserModel()
@property (nonatomic , strong) NSString*    myAccessToken;
@property (nonatomic , strong) NSString*    myTokenType;
@property (nonatomic , strong) NSNumber*    myExpires;
@property (nonatomic , strong) NSString*    myPhone;

@end

@implementation UserModel


#pragma mark - init


+ (instancetype)instance
{
    static id test;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        test = [[[self class] alloc] init];
    });
    return test;
}

#pragma mark - update

- (void)updateWithPhone:(NSString *)phone AccessToken:(NSString *)access TokenType:(NSString *)tokenType Expires:(NSNumber *)expires {
    self.myAccessToken = access;
    self.myTokenType = tokenType;
    self.myExpires = expires;
    self.myPhone = phone;
    
    
    //test
    [self performSelector:@selector(test) withObject:nil afterDelay:1.0];
}

- (void)test {
//    [self requestEditUserInfoWithName:@"loying" Gender:nil Address:nil];
    [self requestLoactionRefreshLocationWithLongitude:[MapInfoModel instance].myPosition.longitude Latitude:[MapInfoModel instance].myPosition.latitude Gender:@"f"];
    
}
#pragma mark - get




#pragma mark - message


- (void)requestOauthLoginWithUserphone:(NSString *)userphone Password:(NSString *)password {
    [[UserMessage instance] requestOauthLoginWithUserphone:userphone Password:password];
}

- (void)requestGetUserInfo {
    [[UserMessage instance] requestGetUserInfoWithAccessToken:self.myAccessToken Userphone:self.myPhone];
}

- (void)requestEditUserInfoWithName:(NSString *)nickName Gender:(NSString *)gender Address:(NSString *)address {
    [[UserMessage instance] requestEditUserInfoWithToken:self.myAccessToken Name:nickName Gender:gender Address:address];
}


- (void)requestLoactionRefreshLocationWithLongitude:(float)x Latitude:(float)y Gender:(NSString *)gender {
    [[LocationMessage instance] requestLocationRefreshLocationWithToken:self.myAccessToken Longitude:x Latitude:y Gender:gender];
}

@end
