//
//  AroundMoodDetailViewModel.m
//  Yingying
//
//  Created by 林伟池 on 16/1/1.
//  Copyright © 2016年 林伟池. All rights reserved.
//

#import "AroundMoodDetailViewModel.h"
#import "UserModel.h"
#import "BaseMessage.h"

@interface AroundMoodDetailViewModel()

@property (nonatomic , strong) NSNumber* myLastIndex;

@end

@implementation AroundMoodDetailViewModel


#pragma mark - init

- (instancetype)init {
    self = [super init];
    self.myCommentInfoArr = @[];
    return self;
}

#pragma mark - update

- (void)updateGetMoodComment {
    [self requestMoodBySidWithToken:[[UserModel instance] getMyAccessToken] Sid:self.myMoodInfo.sid];
}

- (void)updateWithNewArr:(NSArray *)arr {
    self.myCommentInfoArr = arr;
}

#pragma mark - get

- (CommentInfo *)getCommentInfoByIndex:(long)index {
    CommentInfo* ret;
    if (index >= 0 && index < self.myCommentInfoArr.count) {
        ret = self.myCommentInfoArr[index];
    }
    return ret;
}


#pragma mark - message

- (void)requestMoodBySidWithToken:(NSString *)token Sid:(NSNumber *)sid {
    BaseMessage* message = [BaseMessage instance];
    message.myLoadingStrings = @"获取评论列表";
    
    [message sendRequestWithPost:[LY_MSG_BASE_URL stringByAppendingString:LY_MSG_MOOD_GET_COMMENT_BY_SID] Param:@{@"access_token":token, @"sid":sid} success:^(id responseObject) {
        NSDictionary* dict = responseObject;
        if ([dict isKindOfClass:[NSDictionary class]]) {
            NSArray* comments = [dict objectForKey:@"comments"];
            if ([comments isKindOfClass:[NSArray class]]) {
                self.myCommentInfoArr = comments;
            }
        }
    }];
}

- (void)requestComment {
    [self requestCommentWithToken:[[UserModel instance] getMyAccessToken] Sid:self.myMoodInfo.sid CommentSource:self.myCommentString CommentId:nil];
}

- (void)requestCommentWithToken:(NSString *)token Sid:(NSNumber* )sid CommentSource:(NSString *)comment_source CommentId:(NSNumber *)source_comment_id {
    NSMutableDictionary* dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                 token, @"access_token",
                                 sid, @"sid",
                                 comment_source, @"comment_source",
                                 nil];
    if (source_comment_id) {
        [dict setObject:source_comment_id forKey:@"source_comment_id"];
    }
    BaseMessage* message = [BaseMessage instance];
    [message setMyLoadingStrings:@"评论中..."];
    [message sendRequestWithPost:[LY_MSG_BASE_URL stringByAppendingString:LY_MSG_MOOD_COMMENT] Param:dict success:^(id responseObject) {

    }];
}
@end
