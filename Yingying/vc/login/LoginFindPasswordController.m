//
//  LoginFindPasswordController.m
//  Yingying
//
//  Created by 林伟池 on 16/1/4.
//  Copyright © 2016年 林伟池. All rights reserved.
//

#import "LoginFindPasswordController.h"
#import <ReactiveCocoa/RACEXTScope.h>
#import "UserModel.h"
#import "LYColor.h"


@interface LoginFindPasswordController ()
@property (nonatomic , strong) IBOutlet UITextField* myPhone;
@property (nonatomic , strong) IBOutlet UITextField* myCode;

@end

@implementation LoginFindPasswordController

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
    self.myPhone.leftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"login_icon_phone"]];
    self.myPhone.leftViewMode = UITextFieldViewModeAlways;
    
    self.myCode.leftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"login_icon_code"]];
    self.myCode.leftViewMode = UITextFieldViewModeAlways;
    

}
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}


#pragma mark - ibaction

- (IBAction)onGetCode:(id)sender {
    if (self.myPhone.text.length == 0) {
        [self presentMessageTips:@"手机号码不能为空"];
    }
    else {
        [[UserModel instance] requestSendCodeWithUserphone:self.myPhone.text];
    }
}

- (IBAction)onCancel:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onSure:(id)sender {
    if ([self checkInput]) {
        [[UserModel instance] requestLoginWithUserphone:self.myPhone.text Code:self.myCode.text];
    }
}

- (BOOL)checkInput {
    BOOL ret = YES;
    if (self.myCode.text.length == 0) {
        [self presentMessageTips:@"验证码不能为空"];
        ret = NO;
    }
    
    return ret;
}
#pragma mark - ui



#pragma mark - delegate

#pragma mark - notify

- (void)customNotify {
    @weakify(self);
    [[NSNotificationCenter defaultCenter] addObserverForName:NOTIFY_SERVER_JUDGE_CODE_SUCCESS object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
        @strongify(self);
        [self performSegueWithIdentifier:@"open_reset_password_board" sender:nil];
    }];
}


@end
