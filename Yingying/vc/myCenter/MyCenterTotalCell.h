//
//  MyCenterTotalCell.h
//  Yingying
//
//  Created by 林伟池 on 15/12/28.
//  Copyright © 2015年 林伟池. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyCenterTableViewController.h"

typedef NS_ENUM(NSInteger, LY_MY_CENTER_TOTAL) {
    LY_MY_CENTER_TOTAL_NONE,
    LY_MY_CENTER_TOTAL_HEAD,
    LY_MY_CENTER_TOTAL_TOTAL,
    LY_MY_CENTER_TOTAL_COUPON,
    LY_MY_CENTER_TOTAL_FINANCE
};

@interface MyCenterTotalCell : UITableViewCell

@property (nonatomic , strong) IBOutlet UIView* myHeadView;
@property (nonatomic , strong) IBOutlet UIView* myTotalView;
@property (nonatomic , strong) IBOutlet UIView* myCouponView;
@property (nonatomic , strong) IBOutlet UIView* myFinanceView;

@property (nonatomic , weak) IBOutlet MyCenterTableViewController* myController;

@end
