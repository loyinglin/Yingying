//
//  ChatNavigationController.m
//  Yingying
//
//  Created by 林伟池 on 16/1/3.
//  Copyright © 2016年 林伟池. All rights reserved.
//

#import "ChatNavigationController.h"
#import "YingYingUserModel.h"
#import "CDUserFactory.h"
#import "ChatDetailController.h"
#import "LYBaseViewModel.h"

@interface ChatNavigationController ()
@property (nonatomic , strong) NSNumber* uid;
@property (nonatomic , strong) MoodInfo* myMoodInfo;
@end

@implementation ChatNavigationController

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self customView];
    [self customNotify];
}

#pragma mark - view init

- (void)setChatWithUid:(NSNumber *)uid {
    self.uid = uid;
}

- (void)setChatWithUid:(NSNumber *)uid MoodInfo:(id)info {
    self.uid = uid;
    self.myMoodInfo = info;
}

- (void)customView {
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
//    NSLog(@"did");
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        
        
        /**
         *  从其他页面跳转过来的聊天
         */
        if (self.uid) {
            @weakify(self);
            [[CDChatManager manager] fetchConvWithOtherId:[NSString stringWithFormat:@"%@", self.uid] callback : ^(AVIMConversation *conversation, NSError *error) {
                if (error) {
                    LYLog(@"%@", error);
                }
                else {
                    /**
                     *  初始化对话的attribute
                     *  因为这个fetchConvWithOtherId函数重置会 属性
                     */
                    if (conversation.attributes) {
                        AVIMConversationUpdateBuilder* builder = [conversation newUpdateBuilder];
                        builder.attributes = conversation.attributes;
                        NSArray* arr = conversation.members;
                        if (arr.count == 2) {
                            DataUser* user1 = [[YingYingUserModel instance] getDataUserByUid:arr[0]];
                            DataUser* user2 = [[YingYingUserModel instance] getDataUserByUid:arr[1]];
                            if (user1 && user2) {
                                [builder setObject:user1.name forKey:@"name1"];
                                [builder setObject:user2.name forKey:@"name2"];
                                [builder setObject:user1.uid forKey:@"uid1"];
                                [builder setObject:user2.uid forKey:@"uid2"];
                                [builder setObject:user1.avatarUrl forKey:@"avatarUrl1"];
                                [builder setObject:user2.avatarUrl forKey:@"avatarUrl2"];
                            }
                        }
                        NSDictionary* abc = [builder dictionary];
                        [conversation update:abc callback:^(BOOL succeeded, NSError *error) {
                            if (succeeded) {
                                NSLog(@"update success");
                            }
                            NSLog(@"after update %@", [conversation.attributes description]);
                        }];
                    }
                    /**
                     *  如果有要转发的心情
                     */
                    if (self.myMoodInfo) {
                        
                        NSString* thumbUrl = @"";
                        NSString* moodContent = @"";
                        NSString* moodTitle = @"";
                        NSNumber* moodSid = @(0);
                        if (self.myMoodInfo.headUrl) {
                            thumbUrl = self.myMoodInfo.headUrl;
                        }
                        if (self.myMoodInfo.moodContent) {
                            moodContent = self.myMoodInfo.moodContent;
                        }
                        if (self.myMoodInfo.name) {
                            moodTitle = self.myMoodInfo.name;
                        }
                        if (self.myMoodInfo.sid) {
                            moodSid = self.myMoodInfo.sid;
                        }
                        NSDictionary* dict = @{@"yingying":@{
                                                       yingying_msg_key_mood_image_url:[LY_MSG_BASE_URL stringByAppendingString:thumbUrl],
                                                       yingying_msg_key_mood_content:moodContent
                                                       , yingying_msg_key_mood_title:moodTitle,
                                                       yingying_msg_key_mood_sid:moodSid
                                                       }};
                        AVIMTextMessage* message = [AVIMTextMessage messageWithText:[NSString stringWithFormat:@"转发动态"] attributes:dict];
                        
                        [conversation sendMessage:message callback:^(BOOL succeeded, NSError *error) {
                            if (succeeded) {
                                LYLog(@"转发成功");
                            }
                        }];

                    }
                    ChatDetailController *chatRoomVC = [[ChatDetailController alloc] initWithConv:conversation];
                    chatRoomVC.hidesBottomBarWhenPushed = YES;
                    
                    @strongify(self);
                    [self pushViewController:chatRoomVC animated:YES];
                }
                self.uid = nil;
            }];
        }

    });
}

#pragma mark - ibaction

#pragma mark - ui

#pragma mark - delegate

#pragma mark - notify

- (void)customNotify {

}


@end
