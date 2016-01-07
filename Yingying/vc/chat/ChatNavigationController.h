//
//  ChatNavigationController.h
//  Yingying
//
//  Created by 林伟池 on 16/1/3.
//  Copyright © 2016年 林伟池. All rights reserved.
//

#import "LYBaseNavigationController.h"
#import "Yingying.h"

@interface ChatNavigationController : LYBaseNavigationController

- (void)setChatWithUid:(NSNumber *)uid;

- (void)setChatWithUid:(NSNumber *)uid MoodInfo:(MoodInfo *)info;
@end
