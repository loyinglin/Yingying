//
//  ChatFriendListController.m
//  Yingying
//
//  Created by 林伟池 on 15/12/20.
//  Copyright © 2015年 林伟池. All rights reserved.
//

#import "ChatFriendListController.h"
#import "ChatDetailController.h"
#import "UIViewController+YingyingModalViewController.h"
#import "CDUserFactory.h"

@interface ChatFriendListController ()

@end

@implementation ChatFriendListController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
//    LYLog(@"%@ dea", self);
}

#pragma mark - view init

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    NSLog(@"will app");
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
//    NSLog(@"did app");
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
//    NSLog(@"will dis");
}
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
//    NSLog(@"did dis");
}

#pragma mark - ibaction

#pragma mark - ui

#pragma mark - delegate

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.mySearchController setActive:NO];
//    [self lyModalPersonalHomePageWithUserphone:@"abc"];
    
    Friend* info;
    if (self.mySearchController.active) {
        info = [self.myViewModel getSearchFriendByIndex:indexPath.row Section:indexPath.section];
    }
    else {
        info = [self.myViewModel getFriendByIndex:indexPath.row Section:indexPath.section];
    }

    if (info && info.phone) {
        [self.navigationController lyModalPersonalHomePageWithUserphone:info.phone];
    }
    
//    [[CDChatManager manager] fetchConvWithOtherId:[self.myViewModel getFriendByIndex:indexPath.row Section:indexPath.section].nickname callback : ^(AVIMConversation *conversation, NSError *error) {
//        if (error) {
//            LYLog(@"%@", error);
//        }
//        else {
//            ChatDetailController *chatRoomVC = [[ChatDetailController alloc] initWithConv:conversation];
//            [self.navigationController pushViewController:chatRoomVC animated:YES];
//        }
//    }];

    return nil;
}

#pragma mark - notify


@end
