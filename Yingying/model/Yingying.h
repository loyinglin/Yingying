//
//  Yingying.h
//  Yingying
//
//  Created by 林伟池 on 15/12/5.
//  Copyright © 2015年 林伟池. All rights reserved.
//

#import "NSDictionary+LYDictToObject.h"
#import "LYCoding.h"
#import <Foundation/Foundation.h>

@interface Friend : NSObject

@property (nonatomic , strong) NSString* name;
@property (nonatomic , strong) NSString* friendId;
@property (nonatomic , strong) NSString* pingying;

@end



@interface UserInfo : LYCoding

@property (nonatomic , strong) NSString* address;
@property (nonatomic , strong) NSString* gender;
@property (nonatomic , strong) NSString* nickName;

@end

@interface LoginInfo : LYCoding

@property (nonatomic , strong) NSString* access_token;
@property (nonatomic , strong) NSString* token_type;
@property (nonatomic , strong) NSString* refresh_token;
@property (nonatomic , strong) NSString* expires_in;
@property (nonatomic , strong) NSString* userphone;

@end