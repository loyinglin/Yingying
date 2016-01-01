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
@property (nonatomic , strong) LoginInfo*   myLoginInfo;
@property (nonatomic , strong) UserInfo*    myUserInfo;
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

- (instancetype)init {
    self = [super init];
    [self loadCache];
    
    return self;
}


- (void)loadCache
{
    NSData* data = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%@%@", [[self class] description], @"userInfo"]];
    
    if (data) {
        UserInfo* item = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        self.myUserInfo = item;
    }
    
    data = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%@%@", [[self class] description], @"loginInfo"]];
    if (data) {
        LoginInfo* info = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        self.myLoginInfo = info;
    }
    
}

- (void)saveCache
{
    NSData* data = [NSKeyedArchiver archivedDataWithRootObject:self.myUserInfo];
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:[NSString stringWithFormat:@"%@%@", [[self class] description], @"userInfo"]];
    
    data = [NSKeyedArchiver archivedDataWithRootObject:self.myLoginInfo];
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:[NSString stringWithFormat:@"%@%@", [[self class] description], @"loginInfo"]];
}

-(void)clearCache
{
    self.myUserInfo = nil;
    [self saveCache];
}



#pragma mark - update

- (void)updateWithLoginInfo:(LoginInfo *)info {
    self.myLoginInfo = info;
    
    [self saveCache];
    [self onModelChange];
    //test
    [self performSelector:@selector(test) withObject:nil afterDelay:1.0];
}

- (void)updateWithUserInfo:(UserInfo *)info {
    self.myUserInfo = info;
    
    [self saveCache];
    [self onModelChange];
}

- (void)onModelChange {
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_MODEL_USER_MODEL_CHANGE object:nil];
}


- (void)test {
    //登陆成功后获取用户资料
//    [self requestGetUserInfo];
//    [self requestEditUserInfoWithName:@"loying" Gender:@"m" Address:@"cd"];
//    [self requestEditUserInfoWithName:@"loying" Gender:nil Address:nil];
//    [self requestLoactionRefreshLocationWithLongitude:[MapInfoModel instance].myPosition.longitude Latitude:[MapInfoModel instance].myPosition.latitude Gender:@"f"];
    
}
#pragma mark - get

- (UserInfo *)getMyUserInfo {
    return self.myUserInfo;
}

- (BOOL)getNeedLogin {
    BOOL ret = YES;
    if (self.myLoginInfo && self.myUserInfo) {
        ret = NO;
    }
    return ret;
}

- (NSString *)getMyAccessToken {
    NSString* ret = @"";
    if (self.myLoginInfo) {
        ret = self.myLoginInfo.access_token;
    }
    return ret;
}

- (NSString *)getMyUserphone {
    NSString* ret = @"";
    if (self.myLoginInfo) {
        ret = self.myLoginInfo.userphone;
    }
    return ret;
}
#pragma mark - message

- (void)requestSendCodeWithUserphone:(NSString *)userphone {
    [[UserMessage instance] requestSendCodeWithUserphone:userphone];
}

- (void)requestRegisterWithUserphone:(NSString *)userphone Password:(NSString *)password VerifyCode:(NSString *)verifyCode {
    [[UserMessage instance] requestRegisterWithUserphone:userphone Password:password VerifyCode:verifyCode];
}

- (void)requestOauthLoginWithUserphone:(NSString *)userphone Password:(NSString *)password {
    [[UserMessage instance] requestOauthLoginWithUserphone:userphone Password:password];
}

- (void)requestGetUserInfo {
    [[UserMessage instance] requestGetUserInfoWithAccessToken:self.myLoginInfo.access_token Userphone:self.myLoginInfo.userphone];
}

- (void)requestEditUserInfoWithName:(NSString *)nickName Gender:(NSString *)gender Address:(NSString *)address {
    [[UserMessage instance] requestEditUserInfoWithToken:self.myLoginInfo.access_token Name:nickName Gender:gender Address:address];
}


- (void)requestLoactionRefreshLocationWithLongitude:(float)x Latitude:(float)y Gender:(NSString *)gender {
    [[LocationMessage instance] requestLocationRefreshLocationWithToken:self.myLoginInfo.access_token Longitude:x Latitude:y Gender:gender];
}

@end
