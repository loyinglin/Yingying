//
//  YingYingUserModel.h
//  Yingying
//
//  Created by 林伟池 on 16/1/3.
//  Copyright © 2016年 林伟池. All rights reserved.
//

#import "BaseModel.h"
#import "AllMessage.h"

@interface DataUser : LYCoding
@property (nonatomic , strong) NSString* name;
@property (nonatomic , strong) NSString* avatarUrl;
@property (nonatomic , strong) NSString* uid;
@end

@interface YingYingUserModel : BaseModel



#pragma mark - init

+ (instancetype)instance;

#pragma mark - update

- (void)updateAddUser:(DataUser *)user;

/**
 *  从服务器拉下来的信息，最新
 *
 *  @param name      name
 *  @param uid       uid
 *  @param avatarUrl head
 */
- (void)updateAddUserWithName:(NSString *)name Uid:(NSNumber *)uid Url:(NSString *)avatarUrl;


/**
 *  通过对话表格的信息更新 不一定最新
 *
 *  @param name      <#name description#>
 *  @param uid       <#uid description#>
 *  @param avatarUrl <#avatarUrl description#>
 */
- (void)updateUserFromConversationWithName:(NSString *)name Uid:(NSString *)uid Url:(NSString *)avatarUrl;

#pragma mark - get

- (DataUser *)getDataUserByUid:(NSString *)uid;


#pragma mark - message


@end
