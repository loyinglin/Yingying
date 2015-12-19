//
//  MyChargeController.m
//  Yingying
//
//  Created by 林伟池 on 15/12/18.
//  Copyright © 2015年 林伟池. All rights reserved.
//

#import "MyChargeController.h"

@interface MyChargeController ()
@property (nonatomic , strong) IBOutlet UITextField* myChargeTextField;
@end

@implementation MyChargeController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - view init

#pragma mark - ibaction

- (IBAction)oncharge:(id)sender {
    NSLog(@"charge %@", self.myChargeTextField.text);
}

#pragma mark - ui

#pragma mark - delegate

#pragma mark - notify


@end
