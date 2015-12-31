//
//  AroundMoodDetailViewModel.h
//  Yingying
//
//  Created by 林伟池 on 16/1/1.
//  Copyright © 2016年 林伟池. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Yingying.h"

@interface AroundMoodDetailViewModel : NSObject

@property (nonatomic , strong) MoodInfo* myMoodInfo;
@property (nonatomic , strong) NSString* myCommentString;


#pragma mark - init


#pragma mark - update

- (void)updateGetMoodComment;


#pragma mark - get




#pragma mark - message


@end
