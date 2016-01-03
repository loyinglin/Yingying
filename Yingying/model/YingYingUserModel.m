//
//  YingYingUserModel.m
//  Yingying
//
//  Created by 林伟池 on 16/1/3.
//  Copyright © 2016年 林伟池. All rights reserved.
//

#import "YingYingUserModel.h"

@implementation DataUser



@end

@interface YingYingUserModel()
@property (nonatomic , strong) NSMutableDictionary* myUserDict;
@end

@implementation YingYingUserModel


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
    self.myUserDict = [NSMutableDictionary dictionary];
    [self loadCache];
    return self;
}


- (void)loadCache
{
    NSData* data = [[NSUserDefaults standardUserDefaults] objectForKey:[[self class] description]];
    
    if (data) {
        NSDictionary* dict = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        self.myUserDict = [NSMutableDictionary dictionaryWithDictionary:dict];
    }
}

- (void)saveCache
{
    NSData* data = [NSKeyedArchiver archivedDataWithRootObject:self.myUserDict];
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:[[self class] description]];
}

-(void)clearCache
{
    [self.myUserDict removeAllObjects];
    [self saveCache];
}
#pragma mark - update

- (void)updateAddUser:(DataUser *)user {
    if ([user.uid isKindOfClass:[NSString class]]) {
        [self.myUserDict setObject:user forKey:user.uid];
        [self saveCache];
    }
}

- (void)updateAddUserWithName:(NSString *)name Uid:(NSNumber *)uid Url:(NSString *)avatarUrl {
    if (uid) {
        DataUser* user = [DataUser new];
        user.name = name;
        user.uid = [NSString stringWithFormat:@"%@", uid];
        if (avatarUrl) {
            user.avatarUrl = [LY_MSG_BASE_URL stringByAppendingString:avatarUrl];
        }
        [self updateAddUser:user];
    }
    else {
        LYLog(@"update error");
    }
}

- (void)updateUserFromConversationWithName:(NSString *)name Uid:(NSString *)uid Url:(NSString *)avatarUrl {
    if (uid) {
        if ([self.myUserDict objectForKey:uid]) {
            DataUser* user = [DataUser new];
            user.name = name;
            user.uid = uid;
            user.avatarUrl = avatarUrl;
            [self updateAddUser:user];
        }
    }
}
#pragma mark - get

- (DataUser *)getDataUserByUid:(NSString *)uid {
    DataUser* ret;
    if ([uid isKindOfClass:[NSString class]]) {
        ret = [self.myUserDict objectForKey:uid];
    }
    return ret;
}



#pragma mark - message

@end
