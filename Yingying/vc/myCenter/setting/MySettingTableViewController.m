//
//  MySettingTableViewController.m
//  Yingying
//
//  Created by 林伟池 on 15/12/5.
//  Copyright © 2015年 林伟池. All rights reserved.
//

#import "MySettingTableViewController.h"
#import "CDUserFactory.h"
#import "ForAPNs.h"

typedef NS_ENUM(NSInteger, LY_MY_SETTING) {
    ly_pay_password,
    ly_login_password,
    ly_message_notify,
    ly_sound,
    ly_vibrate,
    ly_about_yingying
};

typedef NS_ENUM(NSInteger, LY_SWITCH_SETTING) {
    ly_switch_sound = 20,
    ly_switch_notify = 10,
    ly_switch_vibrate = 30,
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

- (IBAction)onChange:(UISwitch *)sender {
    if (sender.tag == ly_switch_sound) {
        [[ForAPNs instance] updateSoundSettingWith:sender.on];
    }
    else if (sender.tag == ly_switch_vibrate ) {
        [[ForAPNs instance] updateVibrateSettingWith:sender.on];
    }
    else if (sender.tag == ly_switch_notify) {
        [[ForAPNs instance] updateAPNsSettingWith:sender.on];
    }
}

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
    
    if (indexPath.row == ly_message_notify) {
        UISwitch* push = (UISwitch *)[cell viewWithTag:ly_switch_notify];
        if ([push isKindOfClass:[UISwitch class]]) {
            push.on = [[ForAPNs instance] getPushOn];
        }
    }
    else if (indexPath.row == ly_sound) {
        UISwitch* push = (UISwitch *)[cell viewWithTag:ly_switch_sound];
        if ([push isKindOfClass:[UISwitch class]]) {
            push.on = [[ForAPNs instance] getSoundOn];
        }
    }
    else if (indexPath.row == ly_vibrate) {
        UISwitch* push = (UISwitch *)[cell viewWithTag:ly_switch_vibrate];
        if ([push isKindOfClass:[UISwitch class]]) {
            push.on = [[ForAPNs instance] getVibrateOn];
        }
    }
    
    return cell;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.row) {
        case ly_pay_password:
            [self performSegueWithIdentifier:@"open_modify_pay_password_board" sender:self];
            break;
            
        case ly_about_yingying:
            [[UIApplication sharedApplication] openURL:[NSURL
                                                        URLWithString:UIApplicationOpenSettingsURLString]];
            break;
            
        default:
            break;
    }
    
    return nil;
}

#pragma mark - notify


@end
