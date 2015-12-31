//
//  AroundMoodViewModel.h
//  Yingying
//
//  Created by 林伟池 on 15/12/30.
//  Copyright © 2015年 林伟池. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Yingying.h"

@interface AroundMoodViewModel : NSObject

@property (nonatomic , strong) NSArray<MoodInfo *>* myMoodsArr;

#pragma mark - init


#pragma mark - update

- (void)updateRequestMoreMoods;

- (void)updateRequestInitMoods;


#pragma mark - get


- (long)getMoodsCount;

- (MoodInfo *)getMoodInfoByIndex:(long)index;

#pragma mark - message



@end
