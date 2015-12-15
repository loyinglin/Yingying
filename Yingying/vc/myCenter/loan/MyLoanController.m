//
//  MyLoanController.m
//  Yingying
//
//  Created by 林伟池 on 15/12/5.
//  Copyright © 2015年 林伟池. All rights reserved.
//

#import "MyLoanController.h"

@interface MyLoanController ()

@property (nonatomic , strong) IBOutlet UIButton* myAgreeButton;

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

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tabBarController.tabBar setHidden:YES];
}

#pragma mark - ibaction

- (IBAction)onSure:(id)sender {
    if ([self selectedButton]) {
        [self performSegueWithIdentifier:@"open_my_loan_deital_board" sender:self];
    }
}

- (IBAction)onAgree:(id)sender {
    UIImage* selected = [UIImage imageNamed:@"my_loan_selected"];
    if ([self.myAgreeButton.currentImage isEqual:selected]) {
        [self.myAgreeButton setImage:nil forState:UIControlStateNormal];
    }
    else {
        [self.myAgreeButton setImage:selected forState:UIControlStateNormal];
    }
}
#pragma mark - ui

- (BOOL)selectedButton {
    return YES;
}

#pragma mark - delegate

#pragma mark - notify


@end
