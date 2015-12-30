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


@interface MoodInfo : LYCoding

@property (nonatomic , strong) NSNumber* sid;
@property (nonatomic , strong) NSString* moodContent;
@property (nonatomic , strong) NSString* sendDate;
@property (nonatomic , strong) NSNumber* x; //longitude
@property (nonatomic , strong) NSNumber* y; //latitude
@property (nonatomic , strong) NSNumber* comment_size;
@property (nonatomic , strong) NSNumber* zan_size;
@property (nonatomic , strong) NSNumber* type;
@property (nonatomic , strong) NSNumber* forward_size;


@end


@interface CommentInfo : LYCoding

@property (nonatomic , strong) NSNumber* comment_id;
@property (nonatomic , strong) NSNumber* to_id;
@property (nonatomic , strong) NSString* comment_source;
@property (nonatomic , strong) NSString* comment_date;
@property (nonatomic , strong) NSString* thumburl;

@end


