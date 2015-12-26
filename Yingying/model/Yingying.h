//
//  Yingying.h
//  Yingying
//
//  Created by 林伟池 on 15/12/5.
//  Copyright © 2015年 林伟池. All rights reserved.
//

#import "NSDictionary+LYDictToObject.h"
#import <Foundation/Foundation.h>

@interface Friend : NSObject

@property (nonatomic , strong) NSString* name;
@property (nonatomic , strong) NSString* friendId;
@property (nonatomic , strong) NSString* pingying;

@end



@interface UserInfo : NSObject

@property (nonatomic , strong) NSString* address;
@property (nonatomic , strong) NSString* gender;
@property (nonatomic , strong) NSString* nickName;

@end