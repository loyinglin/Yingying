//
//  MyCenterTableViewController.h
//  Yingying
//
//  Created by 林伟池 on 15/12/4.
//  Copyright © 2015年 林伟池. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, LYMYCENTER) {
    my_total,
    my_charge,
    my_cash,
    my_transfer,
    my_finance,
    my_loan,
    my_setting
};


@interface MyCenterTableViewController : UITableViewController

@property (nonatomic , strong) NSString* myForTest;

@end
