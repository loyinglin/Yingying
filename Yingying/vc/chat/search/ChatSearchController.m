//
//  ChatSearchController.m
//  Yingying
//
//  Created by 林伟池 on 16/1/2.
//  Copyright © 2016年 林伟池. All rights reserved.
//

#import "ChatSearchController.h"
#import "ChatSearchViewModel.h"
#import "UIImageView+AFNetworking.h"
#import "UIViewController+YingyingModalViewController.h"

@interface ChatSearchController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic , strong) IBOutlet UITextField*    mySearchTextField;
@property (nonatomic , strong) IBOutlet UITableView*    myTableView;



@property (nonatomic , strong) ChatSearchViewModel* myViewModel;
@end

@implementation ChatSearchController


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.myViewModel = [ChatSearchViewModel new];
    
    RAC(self.myViewModel, mySearchString) = self.mySearchTextField.rac_textSignal;
    
    @weakify(self);
    [[[[self.mySearchTextField.rac_textSignal throttle:1] filter:^BOOL(NSString* text) {
        return text.length > 0;
    }] flattenMap:^RACStream *(id value) {
        @strongify(self);
        return [self.myViewModel requestSearchFriend];
    }] subscribeNext:^(id x) {
        NSLog(@"abc");
        [self.myTableView reloadData];
    } completed:^ {
        LYLog(@"abck reload");
    }];
    
    [self customView];
    [self customNotify];
}

#pragma mark - view init

- (void)customView {
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO];
}

#pragma mark - ibaction

- (IBAction)onCancel:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - ui

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}


#pragma mark - delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.myViewModel getFriendInfoCount];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    FriendInfo* item = [self.myViewModel getFriendInfoByIndex:indexPath.row];
    
    UILabel* nameLabel = (UILabel *)[cell viewWithTag:10];
    UIImageView* avatarImageView = (UIImageView *)[cell viewWithTag:20];
    if (item) {
        nameLabel.text = item.nickname;
        if (item.thumburl) {
            [avatarImageView setImageWithURL:[NSURL URLWithString:[LY_MSG_BASE_URL stringByAppendingString:item.thumburl]]];
        }
        else {
            [avatarImageView setImage:[UIImage imageNamed:@"base_avatar"]];
        }
    }
    
    return cell;
}


- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    FriendInfo* info = [self.myViewModel getFriendInfoByIndex:indexPath.row];
    
    if (info && info.phone) {
        [self lyModalPersonalHomePageWithUserphone:info.phone];
    }

    
    return nil;
}

#pragma mark - notify

- (void)customNotify {
    
}


@end
