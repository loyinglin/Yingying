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

- (void)didSelectedAvatorOnMessage:(id<XHMessageModel>)message atIndexPath:(NSIndexPath *)indexPath {
    XHMessage *msg = [self.messages objectAtIndex:indexPath.row];
    if (msg.bubbleMessageType == XHBubbleMessageTypeSending) {
        NSLog(@"click %@", [CDChatManager manager].selfId);
        [self lyModalPersonalHomePageWithUserId:@([CDChatManager manager].selfId.integerValue)];
    }
    else {
        NSString* str = @"";
        for (NSString* item in self.conv.members) {
            if ([item isEqualToString:[CDChatManager manager].selfId]) {
                
            }
            else {
                str = item;
            }
        }
        NSLog(@"click %@", str);
        [self lyModalPersonalHomePageWithUserId:@(str.intValue)];
    }
}

- (void)multiMediaMessageDidSelectedOnMessage:(id<XHMessageModel>)message atIndexPath:(NSIndexPath *)indexPath onMessageTableViewCell:(XHMessageTableViewCell *)messageTableViewCell {
    [super multiMediaMessageDidSelectedOnMessage:message atIndexPath:indexPath onMessageTableViewCell:messageTableViewCell];
    if (message.messageMediaType == XHBubbleMessageMediaTypeYingyingMood) {
        [[self.myViewModel requestGetMoodInfoBySid:message.yingyingSid] subscribeCompleted:^{
            if ([self.myViewModel getTransferMoodInfo]) {
                [self lyPushMoodDetailControllerWithMoodInfo:[self.myViewModel getTransferMoodInfo]];
            }
            else {
                [self presentMessageTips:@"分享的链接有误"];
            }
        }
         ];
    }
}
#pragma mark - notify

- (void)customNotify {
    
}

@end
