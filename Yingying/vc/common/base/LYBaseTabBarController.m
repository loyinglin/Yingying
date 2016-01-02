//
//  LYBaseTabBarController.m
//  Yingying
//
//  Created by 林伟池 on 15/12/10.
//  Copyright © 2015年 林伟池. All rights reserved.
//

#import "LYBaseTabBarController.h"
#import "UserModel.h"
#import "CDUserFactory.h"
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
        return value;
    }] subscribeNext:^(NSNumber* uid) {
        [[CDChatManager manager] openWithClientId:[NSString stringWithFormat:@"%@", uid] callback: ^(BOOL succeeded, NSError *error) {
            if (error) {
                LYLog(@"%@", error);
            }
            else {
                LYLog(@"chat init success id:%@", uid);
                [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_CHAT_LOGIN_WITH_UID_SUCCESS object:nil];
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
        [self setSelectedIndex:1];
        LYLog(@"abc");
    }];
}


@end
