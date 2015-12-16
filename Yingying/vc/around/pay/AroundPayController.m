//
//  AroundPayController.m
//  Yingying
//
//  Created by 林伟池 on 15/12/11.
//  Copyright © 2015年 林伟池. All rights reserved.
//

#import "AroundPayController.h"

@interface AroundPayController () <UITextViewDelegate>

@property (nonatomic , strong) IBOutlet UILabel* myPlaceholderLabel;

@end

@implementation AroundPayController

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

- (IBAction)onSelectCoupon:(id)sender {
    NSLog(@"selected coupon");
    [self performSegueWithIdentifier:@"open_my_coupon_board" sender:self];
}

- (IBAction)onSelectAddress:(id)sender {
    [self performSegueWithIdentifier:@"open_around_address_board" sender:self];
}

#pragma mark - ui

#pragma mark - delegate

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    self.myPlaceholderLabel.hidden = YES;
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView {
    if (textView.text.length == 0) {
        self.myPlaceholderLabel.hidden = NO;
    }
    return YES;
}

#pragma mark - notify


@end
