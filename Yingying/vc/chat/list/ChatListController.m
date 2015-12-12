//
//  ChatListController.m
//  Yingying
//
//  Created by 林伟池 on 15/12/12.
//  Copyright © 2015年 林伟池. All rights reserved.
//

#import "ChatListController.h"
#import "UIImageView+AFNetworking.h"
#import "CDMessageHelper.h"
#import <DateTools/DateTools.h>

@interface ChatListController () <UISearchResultsUpdating>

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
        [[CDChatManager manager] openWithClientId:selfId callback: ^(BOOL succeeded, NSError *error) {
            if (error) {
                NSLog(@"%@", error);
            }
            else {
                NSLog(@"chat init success");
                [self updateRecent];
            }
        }];
    }
    
    [self setupRefresh];
    [self setupSearch];
    [self setupNotify];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - view init


#pragma mark - ibaction

#pragma mark - ui

- (void)setupRefresh {
    self.refreshControl = [[UIRefreshControl alloc] init];
//    self.refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"加载中..."];
    [self.refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
}

- (void)refresh:(UIRefreshControl *)control {
    NSLog(@"refresh");
    [self.refreshControl endRefreshing];
//    self performSelector:<#(nonnull SEL)#> withObject:<#(nullable id)#> afterDelay:<#(NSTimeInterval)#>
}


- (void)setupSearch {
    
    self.mySearchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    self.mySearchController.automaticallyAdjustsScrollViewInsets = NO;
    self.mySearchController.dimsBackgroundDuringPresentation = NO;
    self.mySearchController.searchResultsUpdater = self;
    
    self.tableView.tableHeaderView = self.mySearchController.searchBar;
    [self.mySearchController.searchBar sizeToFit];

}

- (void)updateRecent {
    
    [[CDChatManager manager] findRecentConversationsWithBlock:^(NSArray *conversations, NSInteger totalUnreadCount, NSError *error) {
//            [self stopRefreshControl:refreshControl];
            if (!error) {
                self.conversations = [NSMutableArray arrayWithArray:conversations];
                [self.tableView reloadData];
                self.tabBarItem.badgeValue = [NSString stringWithFormat:@"%ld", totalUnreadCount];
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
//    if (conversation.unreadCount > 0) {
//        if (conversation.muted) {
//            cell.litteBadgeView.hidden = NO;
//        } else {
//            cell.badgeView.badgeText = [NSString stringWithFormat:@"%ld", conversation.unreadCount];
//        }
//    }

    
    return cell;
}



#pragma mark - delegate

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    NSLog(@"text:%@", searchController.searchBar.text);
}


#pragma mark - notify

- (void)setupNotify {
    
    [[NSNotificationCenter defaultCenter] addObserverForName:kCDNotificationConnectivityUpdated object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
        NSLog(@"kCDNotificationConnectivityUpdated");
    }];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:kCDNotificationMessageReceived object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
        NSLog(@"new message");
    }];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:kCDNotificationUnreadsUpdated object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
        NSLog(@"un read");
    }];
}
@end
