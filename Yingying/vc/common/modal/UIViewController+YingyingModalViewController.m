//
//  UIViewController+YingyingModalViewController.m
//  Yingying
//
//  Created by 林伟池 on 15/12/20.
//  Copyright © 2015年 林伟池. All rights reserved.
//

#import "UIViewController+YingyingModalViewController.h"
#import "PersonalHomePageController.h"

@implementation UIViewController (YingyingModalViewController)


- (void)lyModalPersonalHomePageWith:(NSString *)userphone {
    UINavigationController* navigatonController = [self.storyboard instantiateViewControllerWithIdentifier:@"personal_home_page_controller"];
    PersonalHomePageController* controller = navigatonController.viewControllers[0];
    if ([controller isKindOfClass:[PersonalHomePageController class]]) {
        [controller initWithUserphone:userphone Uid:nil];
        [self presentViewController:navigatonController animated:YES completion:nil];
    }
    else {
        LYLogError();
    }
}

@end
