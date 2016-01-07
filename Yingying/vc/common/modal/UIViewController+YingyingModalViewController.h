//
//  UIViewController+YingyingModalViewController.h
//  Yingying
//
//  Created by 林伟池 on 15/12/20.
//  Copyright © 2015年 林伟池. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Yingying.h"

@interface UIViewController (YingyingModalViewController)

//回调通过notify 


- (void)lyModalPersonalHomePageWith:(NSString *)userphone;

- (void)lyModalImageViewWithUrlString:(NSString *)urlString;

- (void)lyPushMoodDetailControllerWithMoodInfo:(MoodInfo *)info;

@end
