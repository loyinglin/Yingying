//
//  ChatListController.m
//  Yingying
//
//  Created by 林伟池 on 15/12/12.
//  Copyright © 2015年 林伟池. All rights reserved.
//

#import "ChatListController.h"
#import "UIImageView+AFNetworking.h"
#import "ChatSearchController.h"
#import "CDMessageHelper.h"
#import "NSObject+LYUITipsView.h"
#import "MJRefresh.h"
#import "ChatDetailController.h"
#import "NSObject+LYUITipsView.h"
#import "UIViewController+YingyingNavigationItem.h"
#import <DateTools/DateTools.h>
#import <ReactiveCocoa/RACEXTScope.h>

@interface ChatListController () <UISearchResultsUpdating, UISearchControllerDelegate>

@property (nonatomic, strong) NSMutableArray *conversations;

@property (atomic, assign) BOOL isRefreshing;

@property (nonatomic , strong) UISearchController* mySearchController;

@end

@implementation ChatListController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    
    NSString* selfId = @"123";
    
    if (selfId.length > 0) {
        [self.tabBarController presentMessageTips:@"加载中..."];
        [[CDChatManager manager] openWithClientId:selfId callback: ^(BOOL succeeded, NSError *error) {
            if (error) {
                LYLog(@"%@", error);
            }
            else {
                LYLog(@"chat init success");
                [self updateRecent];
            }
        }];
    }
    
    [self setupRefresh];
//    [self setupSearch];
    [self setupNotify];
    [self lySetupLeftItem];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - view init

- (IBAction)onFriendList:(id)sender {
    [self performSegueWithIdentifier:@"open_chat_friend_list_board" sender:self];
}

#pragma mark - ibaction

- (IBAction)onAddFriend:(id)sender {
    LYLog(@"add friend");
    [self presentMessageTips:@"还没有添加页面"];
}

#pragma mark - ui

- (void)setupRefresh {
    @weakify(self);
    [self.tableView addHeaderWithCallback:^{
        @strongify(self);
        [self.tableView headerEndRefreshing];
        [self updateRecent];
    }];
}

- (void)setupSearch {

    ChatSearchController* controller = nil;// [[ChatSearchController alloc] init];
    
    self.mySearchController = [[UISearchController alloc] initWithSearchResultsController:controller];
    self.mySearchController.automaticallyAdjustsScrollViewInsets = NO;
    self.mySearchController.dimsBackgroundDuringPresentation = NO;
//    self.mySearchController.hidesBottomBarWhenPushed = YES;
    self.mySearchController.searchResultsUpdater = self;
    self.mySearchController.delegate = self;
    
    self.tableView.tableHeaderView = self.mySearchController.searchBar;
    [self.mySearchController.searchBar sizeToFit];

}

- (void)updateRecent {
    
    [[CDChatManager manager] findRecentConversationsWithBlock:^(NSArray *conversations, NSInteger totalUnreadCount, NSError *error) {
//            [self stopRefreshControl:refreshControl];
            if (!error) {
                self.conversations = [NSMutableArray arrayWithArray:conversations];
                [self.tableView reloadData];
                self.tabBarItem.badgeValue = [NSString stringWithFormat:@"%ld", (long)totalUnreadCount];
//                [self selectConversationIfHasRemoteNotificatoinConvid];
            }
            self.isRefreshing = NO;
        }];
}



#pragma mark - Table view data source


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    long ret = 0;
    if (self.conversations) {
        ret = self.conversations.count;
    }
    
    return ret;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    UILabel* nameLabel = (UILabel *)[cell viewWithTag:10];
    UILabel* messageTextLabel = (UILabel *)[cell viewWithTag:20];
    UILabel* timestampLabel = (UILabel *)[cell viewWithTag:40];
    UIImageView* imageView = (UIImageView *)[cell viewWithTag:30];
    UIButton* badgeButton = (UIButton *)[cell viewWithTag:50];
    
    AVIMConversation *conversation = [self.conversations objectAtIndex:indexPath.row];
    if (conversation.type == CDConvTypeSingle) {
        id <CDUserModel> user = [[CDChatManager manager].userDelegate getUserById:conversation.otherId];
        nameLabel.text = user.username;
        [imageView setImageWithURL:[NSURL URLWithString:user.avatarUrl]];
    }
    else {
        [imageView setImage:conversation.icon];
        nameLabel.text = conversation.displayName;
    }
    if (conversation.lastMessage) {
        messageTextLabel.attributedText = [[CDMessageHelper helper] attributedStringWithMessage:conversation.lastMessage conversation:conversation];
        timestampLabel.text = [[NSDate dateWithTimeIntervalSince1970:conversation.lastMessage.sendTimestamp / 1000] timeAgoSinceNow];
    }
    

    if (conversation.unreadCount > 0) {
        if (conversation.muted) {
            badgeButton.hidden = YES;
        } else {
            [badgeButton setTitle:[NSString stringWithFormat:@"%ld", conversation.unreadCount] forState:UIControlStateNormal];
            [badgeButton setHidden:NO];
        }
    }
    else {
        badgeButton.hidden = YES;
    }


    return cell;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    [self performSegueWithIdentifier:@"open_chat_detail_board" sender:indexPath];
    ChatDetailController* controller = [[ChatDetailController alloc] initWithConv:self.conversations[indexPath.row]];
    controller.hidesBottomBarWhenPushed = YES;
//    controller.allowsSendMultiMedia = NO;
//    controller.allowsSendVoice = NO;
    [self.navigationController pushViewController:controller animated:YES];
    
    
    return nil;
}

#pragma mark - delegate

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    LYLog(@"text:%@", searchController.searchBar.text);
}


- (void)willPresentSearchController:(UISearchController *)searchController {
//    [self.navigationController setHidesBarsOnTap:YES];
    self.tabBarController.tabBar.hidden = YES;
}

- (void)willDismissSearchController:(UISearchController *)searchController {
    self.tabBarController.tabBar.hidden = NO;
}


#pragma mark - notify

- (void)setupNotify {
    
    [[NSNotificationCenter defaultCenter] addObserverForName:kCDNotificationConnectivityUpdated object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
        LYLog(@"kCDNotificationConnectivityUpdated");
    }];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:kCDNotificationMessageReceived object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
        LYLog(@"new message");
        [self updateRecent];
    }];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:kCDNotificationUnreadsUpdated object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
        LYLog(@"un read");
        [self updateRecent];
    }];
}
@end
