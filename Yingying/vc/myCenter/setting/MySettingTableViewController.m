//
//  MySettingTableViewController.m
//  Yingying
//
//  Created by 林伟池 on 15/12/5.
//  Copyright © 2015年 林伟池. All rights reserved.
//

#import "MySettingTableViewController.h"

typedef NS_ENUM(NSInteger, LY_MY_SETTING) {
    ly_pay_password,
    ly_login_password,
    ly_message_notify,
    ly_sound,
    ly_shake,
    ly_about_yingying
};

@interface MySettingTableViewController ()

@end

@implementation MySettingTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];

//    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.tableView.bounds.size.width, 20.0f)]; //顶部留白
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 60;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - view init

#pragma mark - ibaction

#pragma mark - ui

#pragma mark - delegate

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 6;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString* str = [NSString stringWithFormat:@"cell%ld", indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:str forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.row) {
        case ly_pay_password:
            [self performSegueWithIdentifier:@"open_modify_pay_password_board" sender:self];
            break;
            
            
        default:
            break;
    }
    
    return nil;
}

#pragma mark - notify


@end
