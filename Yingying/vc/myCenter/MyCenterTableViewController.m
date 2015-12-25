//
//  MyCenterTableViewController.m
//  Yingying
//
//  Created by 林伟池 on 15/12/4.
//  Copyright © 2015年 林伟池. All rights reserved.
//

#import "MyCenterTableViewController.h"
#import "UIViewController+YingyingNavigationItem.h"
#import <objc/runtime.h>

@interface MyCenterTableViewController ()

@end

@implementation MyCenterTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    
    [self customView];
    [self test];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)test {
    
    if (YES) { //未登录
        UIViewController* controller = [self.storyboard instantiateViewControllerWithIdentifier:@"login_view_controller"];
        NSLog(@"show login");
        [self.tabBarController presentViewController:controller animated:YES completion:nil];
    }
    
    unsigned int		propertyCount = 0;
    objc_property_t *	properties = class_copyPropertyList([self class], &propertyCount );
    
    NSLog(@"test count %ud", propertyCount);
}

#pragma mark - view init

- (void)customView {
    self.tableView.estimatedRowHeight = 50;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    [self lySetupRightItem];
}

#pragma mark - ibaction

- (IBAction)onOpenMessage:(id)sender {
    [self performSegueWithIdentifier:@"open_my_message_board" sender:self];
}

#pragma mark - ui

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 7;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"cell%ld", indexPath.row] forIndexPath:indexPath];
    
    
    return cell;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == my_transfer) {
        [self performSegueWithIdentifier:@"open_my_transfer_board" sender:self];
    }
    else if (indexPath.row == my_total) {
        [self performSegueWithIdentifier:@"open_my_total_board" sender:self];
    }
    else if (indexPath.row == my_loan) {
        [self performSegueWithIdentifier:@"open_my_loan_board" sender:self];
    }
    else if (indexPath.row == my_charge) {
        [self performSegueWithIdentifier:@"open_my_charge_board" sender:self];
    }
    else if (indexPath.row == my_cash) {
        [self performSegueWithIdentifier:@"open_my_cash_board" sender:self];
    }
    else if (indexPath.row == my_setting) {
        [self performSegueWithIdentifier:@"open_my_setting_board" sender:self];
    }
    else if (indexPath.row == my_finance) {
        [self performSegueWithIdentifier:@"open_my_finance_board" sender:self];
    }
    return nil;
}
#pragma mark - delegate

#pragma mark - notify


@end
