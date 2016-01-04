//
//  UIViewController+YingyingModalViewController.m
//  Yingying
//
//  Created by 林伟池 on 15/12/20.
//  Copyright © 2015年 林伟池. All rights reserved.
//

#import "UIViewController+YingyingModalViewController.h"
#import "LYBaseImageViewController.h"
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
        LYLog(@"error here");
    }
}

- (void)lyModalImageViewWithUrlString:(NSString *)urlString {
    LYBaseImageViewController* controller = [self.storyboard instantiateViewControllerWithIdentifier:@"image_view_controller"];
    if ([controller isKindOfClass:[LYBaseImageViewController class]] && [urlString isKindOfClass:[NSString class]]) {
        [controller customFromAroundDetailWith:urlString HideRightBarButton:YES];
        if (self.navigationController) {
            [self.navigationController pushViewController:controller animated:YES];
        }
        else {
            [self presentViewController:controller animated:NO completion:nil];
        }
    }
    else {
        LYLog(@"error");
    }

}
@end
