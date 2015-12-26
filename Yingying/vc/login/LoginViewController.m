//
//  LoginViewController.m
//  Yingying
//
//  Created by 林伟池 on 15/12/7.
//  Copyright © 2015年 林伟池. All rights reserved.
//

#import "LoginViewController.h"
#import "UserModel.h"
#import "LYColor.h"

@interface LoginViewController ()
@property (nonatomic , strong) IBOutlet UITextField* myPhone;
@property (nonatomic , strong) IBOutlet UITextField* myCode;
@property (nonatomic , strong) IBOutlet UITextField* myPassword;
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14], NSForegroundColorAttributeName:UIColorFromRGB(0x999999)} forState:UIControlStateNormal];
    
    self.navigationController.navigationBarHidden = YES;
//    self.extendedLayoutIncludesOpaqueBars = NO;
//    self.edgesForExtendedLayout = UIRectEdgeBottom | UIRectEdgeLeft | UIRectEdgeRight;
    
    [self customView];
    [self customNotify];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - view init

- (void)customView {
    
    self.myPhone.leftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"login_icon_phone"]];
    self.myPhone.leftViewMode = UITextFieldViewModeAlways;
    
    self.myCode.leftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"login_icon_code"]];
    self.myCode.leftViewMode = UITextFieldViewModeAlways;
    
    self.myPassword.leftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"login_icon_password"]];
    self.myPassword.leftViewMode = UITextFieldViewModeAlways;
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
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)onRegister:(id)sender {
    if ([self checkInput]) {
        [[UserModel instance] requestRegisterWithUserphone:self.myPhone.text Password:self.myPassword.text VerifyCode:self.myCode.text];
    }
}

- (BOOL)checkInput {
    BOOL ret = YES;
    if (self.myCode.text.length == 0) {
        [self presentMessageTips:@"验证码不能为空"];
        ret = NO;
    }
    else if (self.myPassword.text.length < 6 || self.myPassword.text.length > 20) {
        [self presentMessageTips:@"密码必须为6~20位数字或者字母"];
        ret = NO;
    }
    
    return ret;
}
#pragma mark - ui

#pragma mark - delegate

#pragma mark - notify

- (void)customNotify {
    [[NSNotificationCenter defaultCenter] addObserverForName:NOTIFY_SERVER_REGISTER_SUCCESS object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
        [self performSegueWithIdentifier:@"open_register_board" sender:self];
    }];
}

@end
