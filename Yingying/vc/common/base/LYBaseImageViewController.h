//
//  LYBaseImageViewController.h
//  Yingying
//
//  Created by 林伟池 on 15/12/11.
//  Copyright © 2015年 林伟池. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface LYBaseImageViewController : UIViewController

@property (nonatomic , strong) UIImage* myImage;

- (void)customFromAroundDetailWith:(NSString *)imageUrlString HideRightBarButton:(BOOL)hideAble;

@end
