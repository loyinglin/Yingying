//
//  ChatDetailViewModel.h
//  Yingying
//
//  Created by 林伟池 on 16/1/7.
//  Copyright © 2016年 林伟池. All rights reserved.
//

#import "LYBaseViewModel.h"

@interface ChatDetailViewModel : LYBaseViewModel


#pragma mark - init


#pragma mark - update



#pragma mark - get




#pragma mark - message

- (RACSignal *)requestGetMoodInfoBySid:(NSNumber *)sid;

@end
