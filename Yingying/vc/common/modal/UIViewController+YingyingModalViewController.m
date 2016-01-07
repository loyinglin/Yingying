//
//  UIViewController+YingyingModalViewController.m
//  Yingying
//
//  Created by 林伟池 on 15/12/20.
//  Copyright © 2015年 林伟池. All rights reserved.
//

#import "UIViewController+YingyingModalViewController.h"
#import "PersonalHomePageController.h"
#import "AroundMessageDetailController.h"

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

- (void)lyModalImageViewWithUrlString:(NSString *)urlString CallBack:(OnImageDeleteCallBack)callback {
    LYBaseImageViewController* controller = [self.storyboard instantiateViewControllerWithIdentifier:@"image_view_controller"];
    if ([controller isKindOfClass:[LYBaseImageViewController class]] && [urlString isKindOfClass:[NSString class]]) {
        [controller customFromAroundDetailWith:urlString CallBack:callback];
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

- (void)lyModalImageViewWithUrlString:(NSString *)urlString {
    [self lyModalImageViewWithUrlString:urlString CallBack:nil];
}

- (void)lyPushMoodDetailControllerWithMoodInfo:(id)info {
    UIStoryboard* board = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    AroundMessageDetailController* controller = [board instantiateViewControllerWithIdentifier:@"around_mood_detail_controller"];
    if ([controller isKindOfClass:[AroundMessageDetailController class]]) {
        [controller setMoodInfo:info];
        if (self.navigationController) {
            [self.navigationController pushViewController:controller animated:YES];
        }
    }
}
@end
