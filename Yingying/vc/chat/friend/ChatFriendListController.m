//
//  ChatFriendListController.m
//  Yingying
//
//  Created by 林伟池 on 15/12/20.
//  Copyright © 2015年 林伟池. All rights reserved.
//

#import "ChatFriendListController.h"
#import "UIViewController+YingyingModalViewController.h"

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


#pragma mark - view init

#pragma mark - ibaction

#pragma mark - ui

#pragma mark - delegate

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.mySearchController setActive:NO];
    [self modalPersonalHomePageWith:@"abc"];
    return nil;
}

#pragma mark - notify


@end