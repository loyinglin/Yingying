//
//  UIViewController+YingyingModalViewController.m
//  Yingying
//
//  Created by 林伟池 on 15/12/20.
//  Copyright © 2015年 林伟池. All rights reserved.
//

#import "UIViewController+YingyingModalViewController.h"

@implementation UIViewController (YingyingModalViewController)


- (void)lyModalPersonalHomePageWith:(NSString *)wait {
    UIViewController* controller = [self.storyboard instantiateViewControllerWithIdentifier:@"personal_home_page_controller"];
    if (controller) {
        [self presentViewController:controller animated:YES completion:nil];
    }

}

@end
