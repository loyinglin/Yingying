//
//  SettingNewPayPasswordController.m
//  Yingying
//
//  Created by 林伟池 on 15/12/19.
//  Copyright © 2015年 林伟池. All rights reserved.
//

#import "SettingNewPayPasswordController.h"
#import "LYColor.h"
#import "UIViewController+YingyingNavigationItem.h"
#import "MySettingTableViewController.h"

@interface SettingNewPayPasswordController ()

@property (nonatomic , strong) IBOutlet UITextField* myEmptyTextField;

@property (nonatomic , strong) IBOutlet UIButton* myPasswordButton0;
@property (nonatomic , strong) IBOutlet UIButton* myPasswordButton1;
@property (nonatomic , strong) IBOutlet UIButton* myPasswordButton2;
@property (nonatomic , strong) IBOutlet UIButton* myPasswordButton3;
@property (nonatomic , strong) IBOutlet UIButton* myPasswordButton4;
@property (nonatomic , strong) IBOutlet UIButton* myPasswordButton5;

@property (nonatomic , strong) NSArray* myPasswords;
@property (nonatomic , strong) NSString* myPasswordString;


@end

@implementation SettingNewPayPasswordController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.myEmptyTextField becomeFirstResponder];
    
    self.myPasswords = [NSArray arrayWithObjects:self.myPasswordButton0, self.myPasswordButton1
                        , self.myPasswordButton2, self.myPasswordButton3
                        , self.myPasswordButton4, self.myPasswordButton5
                        ,nil];
    

    [self lySetupLeftItem];
  
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - view init

#pragma mark - ibaction

- (IBAction)onTap:(id)sender {
    [self.myEmptyTextField becomeFirstResponder];
}

- (IBAction)onComplete:(id)sender {
    [self onBackToSetting:sender];
}

- (IBAction)onBackToSetting:(id)sender {
    UIViewController* controller;
    NSArray* arr = self.navigationController.viewControllers;
    for (UIViewController* item in arr) {
        if ([item isKindOfClass:[MySettingTableViewController class]]) {
            controller = item;
            break;
        }
    }
    if (controller) {
        [self.navigationController popToViewController:controller animated:YES];
    }
}

#pragma mark - ui

- (void)updateByPassword:(NSString *)password {
    LYLog(@"password : %@", password);
    self.myPasswordString = password;
    UIButton* button;
    for (int i = 0; i < self.myPasswords.count; ++i) {
        button = self.myPasswords[i];
        if (i < self.myPasswordString.length) {
            [button setImage:[UIImage imageNamed:@"first"] forState:UIControlStateNormal];
        }
        else {
            [button setImage:nil forState:UIControlStateNormal];
        }
    }
}

#pragma mark - delegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {  //string就是此时输入的那个字符 textField就是此时正在输入的那个输入框 返回YES就是可以改变输入框的值 NO相反
    
    if ([string isEqualToString:@"\n"])  //按会车可以改变
    {
        return YES;
    }
    
    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string]; //得到输入框的内容
    
    if (self.myEmptyTextField == textField)  //判断是否时我们想要限定的那个输入框
    {
        if ([toBeString length] > 6) { //如果输入框内容大于20则弹出警告
            return NO;
        }
        else {
            [self updateByPassword:toBeString];
        }
    }
    return YES;
}



#pragma mark - notify



@end
