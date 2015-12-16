//
//  AroundAddressController.m
//  Yingying
//
//  Created by 林伟池 on 15/12/16.
//  Copyright © 2015年 林伟池. All rights reserved.
//

#import "AroundAddressController.h"
#import "LYColor.h"

@interface AroundAddressController () <UITextFieldDelegate>

@property (nonatomic , strong) IBOutlet UITextField* myName;
@property (nonatomic , strong) IBOutlet UITextField* myPhone;
@property (nonatomic , strong) IBOutlet UITextField* myAddress;
@property (nonatomic , strong) IBOutlet UITextField* myDetail;

@end

@implementation AroundAddressController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.myAddress.rightView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_right_arrow"]];
    self.myAddress.rightViewMode = UITextFieldViewModeAlways;
    
    
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14], NSForegroundColorAttributeName:UIColorFromRGB(0x778c93)} forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - view init

#pragma mark - ibaction

#pragma mark - ui

#pragma mark - delegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (textField == self.myAddress) {
        [self performSegueWithIdentifier:@"modal_address_detail_board" sender:self];
        return NO;
    }
    return YES;
}

#pragma mark - notify


@end
