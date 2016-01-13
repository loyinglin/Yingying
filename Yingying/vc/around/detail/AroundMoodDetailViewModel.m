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


- (RACSignal *)requestDeleteMood {
    @weakify(self);
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self);
        BaseMessage* message = [BaseMessage instance];
        message.myLoadingStrings = @"删除动态...";
        if (!self.myMoodInfo.sid) {
            [subscriber sendError:nil];
            return nil;
        }
        [message sendRequestWithPost:[LY_MSG_BASE_URL stringByAppendingString:LY_MSG_MOOD_DELETE_MOOD_BY_SID] Param:@{@"access_token":[[UserModel instance] getMyAccessToken], @"sid":self.myMoodInfo.sid} success:^(id responseObject) {
            [subscriber sendCompleted];
        }];
        
        return nil;
    }];
}

- (RACSignal *)requestMoodZan {
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        BaseMessage* message = [BaseMessage instance];
        message.myLoadingStrings = @"请求中...";
        
        [message sendRequestWithPost:[LY_MSG_BASE_URL stringByAppendingString:LY_MSG_MOOD_FAVORITE] Param:@{@"access_token":[[UserModel instance] getMyAccessToken], @"sid":self.myMoodInfo.sid} success:^(id responseObject) {
            [subscriber sendCompleted];
        }];
        return nil;
    }];
}

- (void)requestMoodBySidWithToken:(NSString *)token Sid:(NSNumber *)sid {
    BaseMessage* message = [BaseMessage instance];
    message.myLoadingStrings = @"获取评论列表...";
    
    [message sendRequestWithPost:[LY_MSG_BASE_URL stringByAppendingString:LY_MSG_MOOD_GET_COMMENT_BY_SID] Param:@{@"access_token":token, @"sid":sid} success:^(id responseObject) {
        NSDictionary* dict = responseObject;
        if ([dict isKindOfClass:[NSDictionary class]]) {
            NSArray* comments = [dict objectForKey:@"comments"];
            NSMutableArray* newArr = [NSMutableArray array];
            if ([comments isKindOfClass:[NSArray class]]) {
                for (NSDictionary* commentDict in comments) {
                    if ([commentDict isKindOfClass:[NSDictionary class]]) {
                        [newArr addObject:[commentDict objectForClass:[CommentInfo class]]];
                    }
                }
                self.myCommentInfoArr = newArr;
            }
        }
    }];
}

- (RACSignal *)requestCommentWithSourceCommentId:(NSNumber *)source_comment_id {
    @weakify(self);
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self);
        NSMutableDictionary* dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                     [[UserModel instance] getMyAccessToken], @"access_token",
                                     self.myMoodInfo.sid, @"sid",
                                     self.myCommentString, @"comment_source",
                                     nil];
        if (source_comment_id) {
            [dict setObject:source_comment_id forKey:@"source_comment_id"];
        }
        BaseMessage* message = [BaseMessage instance];
        [message setMyLoadingStrings:@"评论中..."];
        [message sendRequestWithPost:[LY_MSG_BASE_URL stringByAppendingString:LY_MSG_MOOD_COMMENT] Param:dict success:^(id responseObject) {
            [subscriber sendCompleted];
        }];
        return nil;
    }];
}
@end
