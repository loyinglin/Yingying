//
//  ModalConfirmCashController.m
//  Yingying
//
//  Created by 林伟池 on 15/12/19.
//  Copyright © 2015年 林伟池. All rights reserved.
//

#import "ModalConfirmCashController.h"

@interface ModalConfirmCashController () <UITextFieldDelegate>

@property (nonatomic , strong) IBOutlet UITextField* myPassword;

@end

@implementation ModalConfirmCashController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.myPassword becomeFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - view init

#pragma mark - ibaction

- (IBAction)onCancel:(id)sender {
    NSLog(@"cancel");
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)onSure:(id)sender {
    NSLog(@"sure with %@", self.myPassword.text);
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - ui

#pragma mark - delegate

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    
    [self onSure:nil];
    
    return YES;
}
#pragma mark - notify




@end
