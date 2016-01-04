//
//  PersonalHomePageViewModel.m
//  Yingying
//
//  Created by 林伟池 on 15/12/9.
//  Copyright © 2015年 林伟池. All rights reserved.
//

#import "BaseMessage.h"
#import "YingYingUserModel.h"
#import "UserModel.h"
#import <MBProgressHUD.h>
#import <ReactiveCocoa.h>
#import <ReactiveCocoa/RACEXTScope.h>
#import "PersonalHomePageViewModel.h"

@interface PersonalHomePageViewModel()

@property (nonatomic , strong) NSArray* myImagesUrlArr;

@end


@implementation PersonalHomePageViewModel

#pragma mark - init


#pragma mark - update


#pragma mark - get

- (NSString *)getImageUrlbyIndex:(long)index {
    NSString* ret = @"";
    if (index >= 0 && index < self.myPhotosArr.count) {
        NSDictionary* dict = self.myPhotosArr[index];
        ret = [dict objectForKey:@"photoUrl"];
    }
    ret = [LY_MSG_BASE_URL stringByAppendingString:ret];
    
    return ret;
}

- (NSNumber *)getImageIdbyIndex:(long)index {
    NSNumber* ret = @(0);
    if (index >= 0 && index < self.myPhotosArr.count) {
        NSDictionary* dict = self.myPhotosArr[index];
        ret = [dict objectForKey:@"photoId"];
    }
    return ret;
}


- (MoodInfo *)getMoodInfoByIndex:(long)index {
    MoodInfo* ret;
    if (index >= 0 && index < self.myMoodsArr.count) {
        ret = self.myMoodsArr[index];
    }
    return ret;
}

#pragma mark - message

- (RACSignal *)requestGetMoodList {
    
    @weakify(self);
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self);
        BaseMessage* message = [BaseMessage instance];
        message.myLoadingStrings = @"获取动态...";
        if (!self.myUid) {
            [subscriber sendError:nil];
            return nil;
        }
        [message sendRequestWithPost:[LY_MSG_BASE_URL stringByAppendingString:LY_MSG_MOOD_GET_MOODLIST_BY_UID] Param:@{@"access_token":[[UserModel instance] getMyAccessToken], @"uid":self.myUid} success:^(id responseObject) {
            NSDictionary* dict = responseObject;
            if ([dict isKindOfClass:[NSDictionary class]]) {
                NSArray* moodsArr = [dict objectForKey:@"mood"];
                NSMutableArray* newArr = [NSMutableArray array];
                if ([moodsArr isKindOfClass:[NSArray class]]) {
                    for (NSDictionary* moodDict in moodsArr) {
                        if ([moodDict isKindOfClass:[NSDictionary class]]) {
                            [newArr addObject:[moodDict objectForClass:[MoodInfo class]]];
                        }
                    }
                    self.myMoodsArr = newArr;
                }
            }
            [subscriber sendNext:@"ok"];
            [subscriber sendCompleted];
        }];
        
        return nil;
    }];
}


- (RACSignal *)requestDeletePhoteWithPhotoId:(NSNumber *)photoId {
    @weakify(self);
    
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self);
        BaseMessage* message = [BaseMessage instance];
        message.myLoadingStrings = @"删除中..";
        [message sendRequestWithPost:[NSString stringWithFormat:@"%@%@/%@", LY_MSG_BASE_URL, LY_MSG_USER_REMOVE_PHOTO, photoId] Param:@{@"access_token":[[UserModel instance] getMyAccessToken]} success:^(id responseObject) {
            [subscriber sendNext:@"second ok"];
            [subscriber sendCompleted];
        }];
        return nil;
    }];
}


- (RACSignal *)requestUploadAvatarWithImage:(UIImage *)image {
    @weakify(self);
    
    return [[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        MBProgressHUD* HUD = [[MBProgressHUD alloc] initWithView:self.myView];
        HUD.mode = MBProgressHUDModeAnnularDeterminate;
        HUD.labelText = @"上传中";
        [self.myView addSubview:HUD];
        [HUD show:YES];
        
        BaseMessage* uploadMessage = [BaseMessage instance];
        [uploadMessage sendUploadWithPost:[LY_MSG_BASE_URL stringByAppendingString:LY_MSG_UPLOAD] Param:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            NSData *imageData = UIImageJPEGRepresentation(image, 0.5);
            [formData appendPartWithFileData:imageData name:@"upload" fileName:@"test.jpg" mimeType:@"image/jpg"];
        } Progress:^(NSProgress *uploadProgress) {
            dispatch_async(dispatch_get_main_queue(), ^{
                HUD.progress = uploadProgress.fractionCompleted;
            });
        } success:^(id responseObject) {
            [HUD removeFromSuperview];
            NSDictionary* dict = responseObject;
            self.myImagesUrlArr = [dict objectForKey:@"msg_desc"];
            [subscriber sendNext:@"first ok"];
            [subscriber sendCompleted];
        } Fail:^{
            [HUD removeFromSuperview];
        }];
        return nil;
    }] flattenMap:^RACStream *(id value) {
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            @strongify(self);
            BaseMessage* message = [BaseMessage instance];
            message.myLoadingStrings = @"更新中..";
            [message sendRequestWithPost:[LY_MSG_BASE_URL stringByAppendingString:LY_MSG_USER_UPLOAD_USER_HEADIMG] Param:@{@"access_token":[[UserModel instance] getMyAccessToken], @"thumbUrl":self.myImagesUrlArr} success:^(id responseObject) {
                [subscriber sendNext:@"second ok"];
                [subscriber sendCompleted];
            }];
            return nil;
        }];
    }];
}




- (RACSignal *)requestAddPhotoWithImage:(UIImage *)image {
    @weakify(self);
    
    return [[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        MBProgressHUD* HUD = [[MBProgressHUD alloc] initWithView:self.myView];
        HUD.mode = MBProgressHUDModeAnnularDeterminate;
        HUD.labelText = @"上传中";
        [self.myView addSubview:HUD];
        [HUD show:YES];
        
        BaseMessage* uploadMessage = [BaseMessage instance];
        [uploadMessage sendUploadWithPost:[LY_MSG_BASE_URL stringByAppendingString:LY_MSG_UPLOAD] Param:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            NSData *imageData = UIImageJPEGRepresentation(image, 0.5);
            [formData appendPartWithFileData:imageData name:@"upload" fileName:@"test.jpg" mimeType:@"image/jpg"];
            
        } Progress:^(NSProgress *uploadProgress) {
            dispatch_async(dispatch_get_main_queue(), ^{
                HUD.progress = uploadProgress.fractionCompleted;
            });
        } success:^(id responseObject) {
            [HUD removeFromSuperview];
            NSDictionary* dict = responseObject;
            self.myImagesUrlArr = [dict objectForKey:@"msg_desc"];
            [subscriber sendNext:@"first ok"];
            [subscriber sendCompleted];
        } Fail:^{
            [HUD removeFromSuperview];
        }];
        return nil;
    }] flattenMap:^RACStream *(id value) {
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            @strongify(self);
            BaseMessage* message = [BaseMessage instance];
            message.myLoadingStrings = @"添加中..";
            [message sendRequestWithPost:[LY_MSG_BASE_URL stringByAppendingString:LY_MSG_USER_ADD_PHOTO] Param:@{@"access_token":[[UserModel instance] getMyAccessToken], @"photoUrl":self.myImagesUrlArr} success:^(id responseObject) {
                [subscriber sendNext:@"second ok"];
                [subscriber sendCompleted];
            }];
            return nil;
        }];
    }];
}



-(RACSignal *)requestGetUserInfo {
    @weakify(self);
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self);
        if ([[UserModel instance] getNeedLogin]) {
            [self presentMessageTips:@"请先登录"];
            [subscriber sendError:nil];
            return nil;
        }
        if (!self.myUserphone) {
            [self presentMessageTips:@"用户手机号为空"];
            [subscriber sendError:nil];
            return nil;
        }
        
        BaseMessage* message = [BaseMessage instance];
        message.myLoadingStrings = @"获取个人信息..";
        
        [message sendRequestWithPost:[LY_MSG_BASE_URL stringByAppendingString:LY_MSG_USER_GET_USER_INFO] Param:@{@"access_token":[[UserModel instance] getMyAccessToken], @"userphone":self.myUserphone} success:^(id responseObject) {
            @strongify(self);
            NSDictionary* dict = responseObject;
            NSDictionary* head = [dict objectForKey:@"headImg"];
            NSString* headUrl;
            if (head) {
                headUrl = [head objectForKey:@"thumbUrl"];
                self.myAvatarUrl = [LY_MSG_BASE_URL stringByAppendingString:headUrl];
            }
            self.myUid = [dict objectForKey:@"id"];
            self.myPhotosArr = [dict objectForKey:@"photos"];
            self.myIsFriend = [dict objectForKey:@"isfriend"];
            
            //下面的赋值会触发UI 先做上面
            if ([dict isKindOfClass:[NSDictionary class]]) {
                if ([dict objectForKey:@"userInfo"]) {
                    NSDictionary* userDict = [dict objectForKey:@"userInfo"];
                    if ([userDict isKindOfClass:[NSDictionary class]]) {
                        self.myUserInfo = [userDict objectForClass:[UserInfo class]];
                    }
                }
            }
            [[YingYingUserModel instance] updateAddUserWithName:self.myUserInfo.nickName Uid:self.myUid Url:headUrl];

            [subscriber sendNext:@"get back"];
            [subscriber sendCompleted];            
        }];


        return nil;
    }];
}
@end
