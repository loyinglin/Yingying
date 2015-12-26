//
//  MyCashViewController.m
//  Yingying
//
//  Created by 林伟池 on 15/12/4.
//  Copyright © 2015年 林伟池. All rights reserved.
//

#import "MyCashViewController.h"
#import <ReactiveCocoa.h>
#import <ReactiveCocoa/RACEXTScope.h>

@interface MyCashViewController ()
@property (nonatomic , strong) NSString* myPassword;
@end

@implementation MyCashViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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

#pragma mark - ibaction

- (IBAction)onSure:(id)sender {
    [self performSegueWithIdentifier:@"modal_comfirm_cash_board" sender:self];
}

- (IBAction)onNext:(id)sender {
    UIAlertController* controller = [UIAlertController alertControllerWithTitle:nil message:@"请输入密码" preferredStyle:UIAlertControllerStyleAlert];
    
    @weakify(self);
    [controller addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        @strongify(self);
        textField.placeholder = @"请输入密码";
        [textField setSecureTextEntry:YES];
        RAC(self, myPassword) = textField.rac_textSignal;
    }];
    
    UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        LYLog(@"cancel");
    }];
    [controller addAction:cancel];
    
    
    UIAlertAction* sure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        @strongify(self);
        LYLog(@"sure with %@", self.myPassword);
    }];
    
    [controller addAction:sure];
    
    [self presentViewController:controller animated:YES completion:nil];    
}

#pragma mark - ui

#pragma mark - delegate


#pragma mark - notify


@end
