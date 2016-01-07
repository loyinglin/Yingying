//
//  LYBaseImageViewController.h
//  Yingying
//
//  Created by 林伟池 on 15/12/11.
//  Copyright © 2015年 林伟池. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^OnImageDeleteCallBack)(void);

@interface LYBaseImageViewController : UIViewController

@property (nonatomic , strong) UIImage*     myImage;
@property (nonatomic , strong) OnImageDeleteCallBack myDeleteCallBack;

- (void)customFromAroundDetailWith:(NSString *)imageUrlString HideRightBarButton:(BOOL)hideAble;

- (void)customFromAroundDetailWith:(NSString *)imageUrlString CallBack:(OnImageDeleteCallBack)callBack;

@end
