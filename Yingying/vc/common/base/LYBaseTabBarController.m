//
//  LYBaseTabBarController.m
//  Yingying
//
//  Created by 林伟池 on 15/12/10.
//  Copyright © 2015年 林伟池. All rights reserved.
//

#import "LYBaseTabBarController.h"
#import "LYBaseNavigationController.h"
#import "ChatDetailController.h"
#import "UserModel.h"
#import "CDUserFactory.h"
#import "ChatNavigationController.h"
#import "LYBaseViewModel.h"
@interface LYBaseTabBarController ()

@end

@implementation LYBaseTabBarController

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.tabBar.barTintColor = [UIColor blackColor];
    
    [[RACObserve([UserModel instance], myUid) filter:^BOOL(id value) {
        return value != nil;
    }] subscribeNext:^(NSNumber* uid) {
        [[CDChatManager manager] openWithClientId:[NSString stringWithFormat:@"%@", uid] callback: ^(BOOL succeeded, NSError *error) {
            if (error) {
                LYLog(@"%@", error);
            }
            else {
                LYLog(@"chat init success id:%@", uid);
                [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_CHAT_LOGIN_WITH_UID_SUCCESS object:nil];
//                [[CDChatManager manager] fecthConvWithConvid:@"5689d4f39accde5e1980635b" callback:^(AVIMConversation *conversation, NSError *error) {
//                    LYLog(@"back %@", [conversation description]);
//                    NSDictionary* dict = @{@"yingying":@{
//                                                   yingying_msg_key_mood_image_url:@"http://120.25.101.195/YinYin/img/12c5e37a-ccdc-43ea-a1bf-23655f686683.jpg",
//                                                         yingying_msg_key_mood_content:@"test_content"
//                                                         , yingying_msg_key_mood_title:@"test_title" ,
//                                                   yingying_msg_key_mood_sid:@(33)
//                                                         }};
//                    AVIMTextMessage* message = [AVIMTextMessage messageWithText:@"这条带四个属性的测试文本" attributes:dict];
//                    
//                    [conversation sendMessage:message callback:^(BOOL succeeded, NSError *error) {
//                        if (succeeded) {
//                            LYLog(@"测试成功");
//                        }
//                    }];
//                }];
            }
        }];
    }];
    
    
    
    [self customView];
    [self customNotify];
}

#pragma mark - view init

- (void)customView {
    
    
    
}

#pragma mark - ibaction

#pragma mark - ui



#pragma mark - delegate

#pragma mark - notify

- (void)customNotify {
    @weakify(self);
    [[NSNotificationCenter defaultCenter] addObserverForName:NOTIFY_UI_REQUEST_TO_CHAT object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
        @strongify(self);
        [self setSelectedIndex:1];  //不规范的做法，没有等待动画完成
        
        ChatNavigationController* navigationController = [self.viewControllers objectAtIndex:1];
        if (navigationController.view && [navigationController isKindOfClass:[ChatNavigationController class]]) {
            NSNumber* uid = [note.userInfo objectForKey:NOTIFY_UI_REQUEST_TO_CHAT];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [navigationController popToRootViewControllerAnimated:NO];
                [navigationController setChatWithUid:uid MoodInfo:[note.userInfo objectForKey:@"MoodInfo"]];
            });
        }

    }];
}


@end
