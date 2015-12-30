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

@interface DistributionMoodViewModel : NSObject

@property (nonatomic , strong) NSArray* myImagesArr;



#pragma mark - init


#pragma mark - set


- (void)updateAddImage:(UIImage *)img;

#pragma mark - get



#pragma mark - update



#pragma mark - message

- (void)requestSendMoodWithContent:(NSString *)moodContent;

@end
