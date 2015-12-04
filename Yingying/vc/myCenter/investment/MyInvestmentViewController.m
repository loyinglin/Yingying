//
//  MyInvestmentViewController.m
//  Yingying
//
//  Created by 林伟池 on 15/12/4.
//  Copyright © 2015年 林伟池. All rights reserved.
//

#import "MyInvestmentViewController.h"

@interface MyInvestmentViewController ()
@property (nonatomic , strong) UITabBarController* myTabbarController;
@end

@implementation MyInvestmentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.myTabbarController= self.childViewControllers[0];
    self.myTabbarController.tabBar.hidden = YES;
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

- (IBAction)onSelect:(UISegmentedControl *)sender {
    [self.myTabbarController setSelectedIndex:sender.selectedSegmentIndex];
}

#pragma mark - ui

#pragma mark - delegate

#pragma mark - notify


@end
