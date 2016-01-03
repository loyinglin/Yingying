//
//  ModelDistributionController.m
//  Yingying
//
//  Created by 林伟池 on 15/12/4.
//  Copyright © 2015年 林伟池. All rights reserved.
//

#import "ModelDistributionController.h"
#import "LYNotifyCenter.h"

@interface ModelDistributionController ()

@end

@implementation ModelDistributionController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}


- (IBAction)onDistributionMood:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_UI_DISTRIBUTION_MOOD object:nil];
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (IBAction)onDistributionRes:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_UI_DISTRIBUTION_RES object:nil];
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (IBAction)onDismiss:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
