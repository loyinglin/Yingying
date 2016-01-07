//
//  MinePopController.m
//  Yingying
//
//  Created by 林伟池 on 15/12/28.
//  Copyright © 2015年 林伟池. All rights reserved.
//

#import "MinePopController.h"
#import "MineViewModel.h"

@interface MinePopController ()

@property (nonatomic , strong) IBOutlet UIView* myView0;
@property (nonatomic , strong) IBOutlet UIView* myView1;
@property (nonatomic , strong) IBOutlet UIView* myView2;

@property (nonatomic , strong) IBOutlet NSLayoutConstraint* myConstraint;

@property (nonatomic , strong) NSArray* myViewsArray;
@end

#define LY_LAYOUT_ONE   100
#define LY_LAYOUT_TWO   65
#define LY_LAYOUT_THREE 30


@implementation MinePopController

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.myViewsArray = @[self.myView0, self.myView1, self.myView2];
    [self customView];
    [self customNotify];
}

#pragma mark - view init

- (void)customView {
    if (self.myHarvestArray) {
        for (int i = 0; i < self.myHarvestArray.count && i < self.myViewsArray.count; ++i) {
            UIView* view = self.myViewsArray[i];
            UIImageView* imageView = (UIImageView *)[view viewWithTag:10];
            UILabel* label = (UILabel *)[view viewWithTag:20];
            NSDictionary* dict = self.myHarvestArray[i];
            if ([dict isKindOfClass:[NSDictionary class]]) {
                NSNumber* sum = [dict objectForKey:@"sum"];
                NSNumber* code = [dict objectForKey:@"code"];
                if (code.integerValue == ly_mine_back_coupon) {
                    [imageView setImage:[UIImage imageNamed:@"mine_pop_icon_coupon"]];
                }
                else if (code.integerValue == ly_mine_back_finance){
                    [imageView setImage:[UIImage imageNamed:@"mine_pop_icon_finance"]];
                }
                else {
                    [imageView setImage:nil];
                }
                if (sum) {
                    label.text = [NSString stringWithFormat:@"%@元", sum];
                }
                else {
                    label.text = nil;
                }
            }
        }
        [self initWithCount:self.myHarvestArray.count];
    }
    else {
        [self initWithCount:0];
    }
}

#pragma mark - ibaction

- (IBAction)onSure:(id)sender {
//    [self initWithCount: --self.myCount];
    [self onCancel:sender];
}

- (IBAction)onCancel:(id)sender {
    [self dismissViewControllerAnimated:NO completion:nil];
}
#pragma mark - ui

- (void)initWithCount:(long)count {
    self.myView0.hidden = self.myView1.hidden = self.myView2.hidden = YES;
    if (count == 1) {
        self.myView0.hidden = NO;
        self.myConstraint.constant = LY_LAYOUT_ONE;
    }
    if (count == 2) {
        self.myView0.hidden = self.myView1.hidden = NO;
        self.myConstraint.constant = LY_LAYOUT_TWO;
    }
    if (count == 3) {
        self.myView0.hidden = self.myView1.hidden = self.myView2.hidden = NO;
        self.myConstraint.constant = LY_LAYOUT_THREE;
    }
}


#pragma mark - delegate

#pragma mark - notify

- (void)customNotify {
    
}


@end
