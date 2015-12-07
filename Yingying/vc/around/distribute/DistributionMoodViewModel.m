//
//  DistributionMoodViewModel.m
//  Yingying
//
//  Created by 林伟池 on 15/12/6.
//  Copyright © 2015年 林伟池. All rights reserved.
//

#import "DistributionMoodViewModel.h"

@implementation DistributionMoodViewModel



#pragma mark - init

- (instancetype)init {
    self = [super init];
    self.myImagesArr = [NSArray arrayWithObjects:[UIImage imageNamed:@"first"], nil];
    return self;
}


#pragma mark - set

- (void)updateAddImage:(UIImage *)img {
    NSArray* arr = [NSArray arrayWithObjects:img, nil];
    self.myImagesArr = [arr arrayByAddingObjectsFromArray:self.myImagesArr];
}

#pragma mark - get



#pragma mark - update



#pragma mark - message


@end
