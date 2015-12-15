//
//  LoginProtocalController.m
//  Yingying
//
//  Created by 林伟池 on 15/12/15.
//  Copyright © 2015年 林伟池. All rights reserved.
//

#import "LoginProtocalController.h"

@interface LoginProtocalController ()

@property (nonatomic , strong) IBOutlet UITextView* myTextView;

@end

@implementation LoginProtocalController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    [self.myTextView setBackgroundColor:[UIColor clearColor]];
    self.myTextView.textColor = [UIColor whiteColor];
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
