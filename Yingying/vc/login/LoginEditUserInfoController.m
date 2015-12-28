//
//  LoginRegisterController.m
//  Yingying
//
//  Created by 林伟池 on 15/12/14.
//  Copyright © 2015年 林伟池. All rights reserved.
//

#import "LoginEditUserInfoController.h"
#import "UserModel.h"
#import "MapInfoModel.h"

@interface LoginEditUserInfoController ()

@property (nonatomic , strong) IBOutlet UISwitch* mySwitch;

@property (nonatomic , strong) IBOutlet UILabel* myMaleLabel;

@property (nonatomic , strong) IBOutlet UILabel* myFemaleLabel;

@property (nonatomic , strong) IBOutlet UITextField* myInputTextField;

@end

@implementation LoginEditUserInfoController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.navigationController.navigationBarHidden = NO;
//    ((UILabel *)[[[[[[self.mySwitch subviews] lastObject] subviews] objectAtIndex:2] subviews] objectAtIndex:0]).text = @"Foo";
//    ((UILabel *)[[[[[[self.mySwitch subviews] lastObject] subviews] objectAtIndex:2] subviews] objectAtIndex:1]).text = @"Bar";
    [self.myInputTextField setBackgroundColor:[UIColor clearColor]];
    NSString* str = self.myInputTextField.placeholder;
    self.myInputTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:str attributes:@{NSForegroundColorAttributeName:[UIColor lightGrayColor]}];
    
    [self customNotify];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - view init


- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}
#pragma mark - ibaction

- (IBAction)onBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onSwitch:(UISwitch *)sender {
    self.myMaleLabel.hidden = !sender.on;
    self.myFemaleLabel.hidden = sender.on;
}

- (IBAction)onRegister:(id)sender {
    if ([self checkInput]) {
        [[UserModel instance] requestEditUserInfoWithName:self.myInputTextField.text Gender:[self getGender] Address:[MapInfoModel instance].myAddress];
    }
}
#pragma mark - ui

- (BOOL)checkInput {
    BOOL ret = YES;
    
    return ret;
}

- (NSString *)getGender {
    NSString* ret;
    if (self.myMaleLabel.hidden) {
        ret = @"f";
    }
    else {
        ret = @"m";
    }
    return ret;
}
#pragma mark - delegate

#pragma mark - notify

- (void)customNotify {
    [[NSNotificationCenter defaultCenter] addObserverForName:NOTIFY_SERVER_EDIT_USERINFO_SUCCESS object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
        [[UserModel instance] requestGetUserInfo];
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
}

@end
