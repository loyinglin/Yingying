//
//  LoginRegisterController.m
//  Yingying
//
//  Created by 林伟池 on 15/12/14.
//  Copyright © 2015年 林伟池. All rights reserved.
//

#import "LoginRegisterController.h"

@interface LoginRegisterController ()

@property (nonatomic , strong) IBOutlet UISwitch* mySwitch;

@end

@implementation LoginRegisterController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.navigationController.navigationBarHidden = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - view init

#pragma mark - ibaction

- (IBAction)onBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - ui

#pragma mark - delegate

#pragma mark - notify


@end
