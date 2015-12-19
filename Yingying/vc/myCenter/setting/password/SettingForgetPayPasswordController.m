//
//  SettingForgetPayPasswordController.m
//  Yingying
//
//  Created by 林伟池 on 15/12/20.
//  Copyright © 2015年 林伟池. All rights reserved.
//

#import "SettingForgetPayPasswordController.h"
#import "MySettingTableViewController.h"
#import "UIViewController+YingyingNavigationItem.h"

@interface SettingForgetPayPasswordController ()
@property (nonatomic , strong) IBOutlet UITextField*        myPhone;
@property (nonatomic , strong) IBOutlet UITextField*        myCode;
@end

@implementation SettingForgetPayPasswordController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupLeftItem];
    [self customView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - view init
- (void)customView {
    
    self.myPhone.leftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"login_icon_phone"]];
    self.myPhone.leftViewMode = UITextFieldViewModeAlways;
    
    self.myCode.leftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"login_icon_code"]];
    self.myCode.leftViewMode = UITextFieldViewModeAlways;
    

}

#pragma mark - ibaction

- (IBAction)onClick:(id)sender {
    if ([self checkCode]) {
        NSLog(@"ok");
    }
}

- (IBAction)onGetCode:(id)sender {
    NSLog(@"get code");
}


- (IBAction)onBackToSetting:(id)sender {
    UIViewController* controller;
    NSArray* arr = self.navigationController.viewControllers;
    for (UIViewController* item in arr) {
        if ([item isKindOfClass:[MySettingTableViewController class]]) {
            controller = item;
            break;
        }
    }
    if (controller) {
        [self.navigationController popToViewController:controller animated:YES];
    }
}

#pragma mark - ui

- (BOOL)checkCode {
    return YES;
}

#pragma mark - delegate

#pragma mark - notify


@end
