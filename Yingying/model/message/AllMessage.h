//
//  AllMessage.h
//  Yingying
//
//  Created by 林伟池 on 15/12/17.
//  Copyright © 2015年 林伟池. All rights reserved.
//

#import <Foundation/Foundation.h>

#define LY_MSG_BASE_URL                     @"http://120.25.101.195/YinYin"


//login
#define LY_MSG_GET_CODE                     @"/sendCode"
#define LY_MSG_OAUTH_LOGIN                  @"/oauth/login"
#define LY_MSG_SEND_CODE                    @"/sendCode"
#define LY_MSG_REGISTER                     @"/register"


//user
#define LY_MSG_USER_GET_USER_INFO           @"/user/getUserInfo"
#define LY_MSG_USER_EDIT_USER_INFO          @"/user/editUserInfo"

#define LY_MSG_USER_UPLOAD_USER_HEADIMG     @"/user/uploadHeadImg"
#define LY_MSG_USER_ADD_PHOTO               @"/user/addPhoto"


//upload
#define LY_MSG_UPLOAD                       @"/upload"
