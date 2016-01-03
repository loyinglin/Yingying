//
//  UIViewController+YingYingImagePickerController.h
//  Yingying
//
//  Created by 林伟池 on 16/1/3.
//  Copyright © 2016年 林伟池. All rights reserved.
//

#import <UIKit/UIKit.h>

#define NOTIFY_UI_IMAGE_PICKER_DONE     @"NOTIFY_UI_IMAGE_PICKER_DONE"

@interface UIViewController (YingYingImagePickerController) <UINavigationControllerDelegate,UIImagePickerControllerDelegate>
@property (nonatomic , strong) UIImage* myPickImage;

- (void)lyModalChoosePicker;

@end
