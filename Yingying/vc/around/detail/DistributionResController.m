//
//  DistributionResController.m
//  Yingying
//
//  Created by 林伟池 on 15/12/4.
//  Copyright © 2015年 林伟池. All rights reserved.
//

#import "DistributionResController.h"

@interface DistributionResController ()

@property (nonatomic , strong) IBOutlet UITextView* myResDesc;

@end

@implementation DistributionResController

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.myResDesc.layer.borderColor = UIColorFromRGB(0xcdcdcd).CGColor;
    self.myResDesc.layer.borderWidth = 1;
    self.myResDesc.layer.cornerRadius = 3;
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


- (IBAction)onDistribute:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - ui

#pragma mark - delegate

#pragma mark - notify


@end
