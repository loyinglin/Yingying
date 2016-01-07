//
//  ChatDetailController.m
//  Yingying
//
//  Created by 林伟池 on 15/12/12.
//  Copyright © 2015年 林伟池. All rights reserved.
//

#import "ChatDetailController.h"
#import "ChatDetailViewModel.h"
#import "UIViewController+YingyingModalViewController.h"
#import "BaseMessage.h"
#import "UIViewController+YingyingNavigationItem.h"

@interface ChatDetailController ()
@property (nonatomic , strong) ChatDetailViewModel* myViewModel;
@end

@implementation ChatDetailController

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.myViewModel = [ChatDetailViewModel new];
    
    [self lySetupLeftItem];
    [self customView];
    [self customNotify];
}

#pragma mark - view init

- (void)customView {
    
}

#pragma mark - ibaction

#pragma mark - ui



#pragma mark - delegate

- (void)multiMediaMessageDidSelectedOnMessage:(id<XHMessageModel>)message atIndexPath:(NSIndexPath *)indexPath onMessageTableViewCell:(XHMessageTableViewCell *)messageTableViewCell {
    [super multiMediaMessageDidSelectedOnMessage:message atIndexPath:indexPath onMessageTableViewCell:messageTableViewCell];
    if (message.messageMediaType == XHBubbleMessageMediaTypeYingyingMood) {
        [[self.myViewModel requestGetMoodInfoBySid:message.yingyingSid] subscribeNext:^(id x) {
            MoodInfo* info = [MoodInfo new];
            info.sid = message.yingyingSid;
            info.moodContent = message.yingyingMoodConent;
            info.name = message.yingyingMoodTitle;
            [self lyPushMoodDetailControllerWithMoodInfo:info];
        }];
    }
}
#pragma mark - notify

- (void)customNotify {
    
}

@end
