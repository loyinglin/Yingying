//
//  MyLoanController.m
//  Yingying
//
//  Created by 林伟池 on 15/12/5.
//  Copyright © 2015年 林伟池. All rights reserved.
//

#import "MyLoanController.h"

@interface MyLoanController ()

@end

@implementation MyLoanController

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
    if ([self selectedButton]) {
        [self performSegueWithIdentifier:@"open_my_loan_deital_board" sender:self];
    }
}

#pragma mark - ui

- (BOOL)selectedButton {
    return YES;
}

#pragma mark - delegate

#pragma mark - notify


@end
