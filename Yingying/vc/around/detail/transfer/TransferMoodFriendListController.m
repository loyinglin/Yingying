//
//  TransferMoodFriendListController.m
//  Yingying
//
//  Created by 林伟池 on 16/1/6.
//  Copyright © 2016年 林伟池. All rights reserved.
//

#import "TransferMoodFriendListController.h"
#import "CDUserFactory.h"

@interface TransferMoodFriendListController ()

@property (nonatomic , strong) MoodInfo* myMoodInfo;

@end

@implementation TransferMoodFriendListController

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self customNotify];
}

#pragma mark - view init

- (void)customWithMoodInfo:(MoodInfo *)info {
    self.myMoodInfo = info;
}

#pragma mark - ibaction

#pragma mark - ui



#pragma mark - delegate

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    Friend* friend;
    if (self.mySearchController.active) {
        friend = [self.myViewModel getSearchFriendByIndex:indexPath.row Section:indexPath.section];
    }
    else {
        friend = [self.myViewModel getFriendByIndex:indexPath.row Section:indexPath.section];
    }
    
    if (friend.frduid && [CDChatManager manager].selfId && self.myMoodInfo) {
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_UI_REQUEST_TO_CHAT object:nil userInfo:@{NOTIFY_UI_REQUEST_TO_CHAT:@(friend.frduid.integerValue), @"MoodInfo":self.myMoodInfo}];
    }
    [self dismissViewControllerAnimated:YES completion:nil]; //个人中心过来的
    [self.navigationController popToRootViewControllerAnimated:NO]; //周边过来的
    
    
    return [super tableView:tableView willSelectRowAtIndexPath:indexPath];
}

#pragma mark - notify

- (void)customNotify {
    
}


@end
