//
//  AllMessage.h
//  Yingying
//
//  Created by 林伟池 on 15/12/17.
//  Copyright © 2015年 林伟池. All rights reserved.
//

#import <Foundation/Foundation.h>

#define LY_MSG_BASE_URL                     @"http://120.25.101.195/YinYin"
#define LY_MSG_CODE_SUCCESS                 20000

//login
#define LY_MSG_GET_CODE                     @"/sendCode"
#define LY_MSG_OAUTH_LOGIN                  @"/oauth/login"
#define LY_MSG_SEND_CODE                    @"/sendCode"
#define LY_MSG_REGISTER                     @"/register"
#define LY_MSG_JUDGE_CODE                   @"/judgecode"


//user
#define LY_MSG_USER_GET_USER_INFO           @"/user/getUserInfo"
#define LY_MSG_USER_EDIT_USER_INFO          @"/user/editUserInfo"

#define LY_MSG_USER_UPLOAD_USER_HEADIMG     @"/user/uploadUserHeadImg"
#define LY_MSG_USER_ADD_PHOTO               @"/user/addPhoto"
#define LY_MSG_USER_REMOVE_PHOTO            @"/user/deletePhoto"
#define LY_MSG_USER_CHANGE_PASSWORD         @"/user/changepassword"


//upload
#define LY_MSG_UPLOAD                       @"/upload"


//location
#define LY_MSG_LOCATION_REFRESH_LOCATION    @"/location/refreshLocation"



//mood
#define LY_MSG_MOOD_GET_NEAR_MOOD           @"/mood/nearmood"
#define LY_MSG_MOOD_SEND_MOOD               @"/mood/send"
#define LY_MSG_MOOD_COMMENT                 @"/mood/comment"
#define LY_MSG_MOOD_GET_COMMENT_BY_SID      @"/mood/getCommentBySid"
#define LY_MSG_MOOD_FAVORITE                @"/mood/zan"
#define LY_MSG_MOOD_GET_MOODLIST_BY_UID     @"/mood/getmoodlistbyuid"


//friend
#define LY_MSG_FRIEND_ADD_FRIEND            @"/friend/addfriend"
#define LY_MSG_FRIEND_DELETE_FRIEND         @"/friend/deletefriend"
#define LY_MSG_FRIEND_GET_FRIEND_LIST       @"/friend/getfriendlist"
#define LY_MSG_FRIEND_FIND_FRIEND           @"/friend/findfriend"






