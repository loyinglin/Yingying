//
//  LoginViewController.m
//  Yingying
//
//  Created by 林伟池 on 15/12/26.
//  Copyright © 2015年 林伟池. All rights reserved.
//

#import "LoginViewController.h"
#import "NSObject+LYUITipsView.h"
#import "UserModel.h"

@interface LoginViewController ()

@property (nonatomic , strong) IBOutlet UITextField* myPhone;
@property (nonatomic , strong) IBOutlet UITextField* myPassword;
@end

@implementation LoginViewController

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    
    
    [self customView];
    [self customNotify];
}

#pragma mark - view init

- (void)customView {
    
    self.myPhone.leftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"login_icon_phone"]];
    self.myPhone.leftViewMode = UITextFieldViewModeAlways;
    
    
    
    self.myPassword.leftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"login_icon_password"]];
    self.myPassword.leftViewMode = UITextFieldViewModeAlways;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

#pragma mark - ibaction

- (IBAction)onCancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (IBAction)onLogin:(id)sender {
    if ([self checkInput]) {
        [[UserModel instance] requestOauthLoginWithUserphone:self.myPhone.text Password:self.myPassword.text];
    }
}

- (IBAction)onRegister:(id)sender {
    [self performSegueWithIdentifier:@"open_register_board" sender:nil];
}

- (BOOL)checkInput {
    BOOL ret = YES;
    if (self.myPassword.text.length < 6 || self.myPassword.text.length > 20) {
        [self presentMessageTips:@"密码必须为6~20位数字或者字母"];
        ret = NO;
    }
    
    return ret;
}
#pragma mark - ui



#pragma mark - delegate

#pragma mark - notify

- (void)customNotify {
    [[NSNotificationCenter defaultCenter] addObserverForName:NOTIFY_SERVER_LOGIN_SUCCESS object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
}


@end
