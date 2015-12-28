//
//  MyCenterTotalCell.m
//  Yingying
//
//  Created by 林伟池 on 15/12/28.
//  Copyright © 2015年 林伟池. All rights reserved.
//

#import "MyCenterTotalCell.h"

@implementation MyCenterTotalCell

- (void)awakeFromNib {
    // Initialization code
    NSLog(@"AWAKE");
    [self initTapOnView:self.myCouponView];
    [self initTapOnView:self.myFinanceView];
    [self initTapOnView:self.myHeadView];
    [self initTapOnView:self.myTotalView];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)initTapOnView:(UIView *)view {
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTap:)];
    if (view) {
        [view addGestureRecognizer:tap];
    }
}


- (void)onTap:(UITapGestureRecognizer *)tap {
    LY_MY_CENTER_TOTAL index = LY_MY_CENTER_TOTAL_NONE;
    if (tap.view == self.myTotalView) {
        index = LY_MY_CENTER_TOTAL_TOTAL;
    }
    if (tap.view == self.myCouponView) {
        index = LY_MY_CENTER_TOTAL_COUPON;
    }
    if (tap.view == self.myFinanceView) {
        index = LY_MY_CENTER_TOTAL_FINANCE;
    }
    if (tap.view == self.myHeadView) {
        index = LY_MY_CENTER_TOTAL_HEAD;
    }
    if (index != LY_MY_CENTER_TOTAL_NONE && self.myController) {
        [self.myController onTotalCellTapWith:index];
    }
}
@end
