//
//  UIViewController+YingyingNavigationItem.m
//  Yingying
//
//  Created by 林伟池 on 15/12/20.
//  Copyright © 2015年 林伟池. All rights reserved.
//

#import "UIViewController+YingyingNavigationItem.h"
#import "LYColor.h"

@implementation UIViewController (YingyingNavigationItem)

- (void)lySetupLeftItem {
    [self.navigationItem.leftBarButtonItem setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14], NSForegroundColorAttributeName:UIColorFromRGB(0x778c93)} forState:UIControlStateNormal];
}

- (void)lySetupRightItem {
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14], NSForegroundColorAttributeName:UIColorFromRGB(0x778c93)} forState:UIControlStateNormal];
}

@end
