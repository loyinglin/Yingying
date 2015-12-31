//
//  DistributionMoodViewModel.h
//  Yingying
//
//  Created by 林伟池 on 15/12/6.
//  Copyright © 2015年 林伟池. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveCocoa.h>
#import <ReactiveCocoa/RACEXTScope.h>
#import <MBProgressHUD.h>

@interface DistributionMoodViewModel : NSObject

@property (nonatomic , strong) NSArray*     myImagesArr;
@property (nonatomic , strong) NSString*    myMoodConent;
@property (nonatomic , strong) NSString*    myLocName;
@property (nonatomic , weak) UIView*        myView;


#pragma mark - init


#pragma mark - update


- (void)updateAddImage:(UIImage *)img;

- (void)updateDeleteImage:(UIImage *)img;



#pragma mark - get




#pragma mark - message

- (void)requestSendMood;


@end
