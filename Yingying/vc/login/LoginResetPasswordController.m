//
//  LoginResetPasswordController.m
//  Yingying
//
//  Created by 林伟池 on 16/1/4.
//  Copyright © 2016年 林伟池. All rights reserved.
//

#import "LoginResetPasswordController.h"
#import <ReactiveCocoa/RACEXTScope.h>
#import "UserModel.h"
#import "LYColor.h"


@interface LoginResetPasswordController ()

@property (nonatomic , strong) IBOutlet UITextField* myCode1;
@property (nonatomic , strong) IBOutlet UITextField* myCode2;

@end

@implementation LoginResetPasswordController

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self customView];
    [self customNotify];
}

#pragma mark - view init

- (void)customView {
    self.myCode1.leftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"login_icon_code"]];
    self.myCode1.leftViewMode = UITextFieldViewModeAlways;
    
    self.myCode2.leftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"login_icon_code"]];
    self.myCode2.leftViewMode = UITextFieldViewModeAlways;
}
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}




#pragma mark - ibaction

#pragma mark - ui

- (IBAction)onCancel:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onSure:(id)sender {
    if ([self checkInput]) {
        [[UserModel instance] requestChangePasswordWithPassword:self.myCode1.text];
    }
}

- (BOOL)checkInput {
    BOOL ret = YES;
    if (![self.myCode1.text isEqualToString:self.myCode2.text
        ]) {
        [self presentMessageTips:@"密码必须相同"];
        ret = NO;
    }
    else if (self.myCode1.text.length == 0) {
        [self presentMessageTips:@"密码不能为空"];
        ret = NO;
    }
    else if (self.myCode1.text.length < 6 || self.myCode1.text.length > 20) {
        [self presentMessageTips:@"密码必须为6~20位数字或者字母"];
        ret = NO;
    }
    
    return ret;
}


#pragma mark - delegate

#pragma mark - notify

- (void)customNotify {
    @weakify(self);
    [[NSNotificationCenter defaultCenter] addObserverForName:NOTIFY_SERVER_CHANGE_PASSWORD_SUCCESS object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
        @strongify(self);
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
}


@end
