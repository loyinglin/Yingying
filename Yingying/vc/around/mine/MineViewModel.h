//
//  MineViewModel.h
//  Yingying
//
//  Created by 林伟池 on 16/1/4.
//  Copyright © 2016年 林伟池. All rights reserved.
//

#import "LYBaseViewModel.h"

typedef NS_ENUM(NSInteger, LY_MINE) {
    ly_mine_back_cost =     100,
    ly_mine_back_end =      101,
    ly_mine_back_coupon =   102,
    ly_mine_back_finance =  103
};

#define ly_key_game_status      @"game_statue"
#define ly_key_uer_operation    @"usr_opt"
#define ly_key_msg_code         @"code"
#define ly_key_msg_manual       @"manual"

@interface MineViewModel : LYBaseViewModel


#pragma mark - init

+ (instancetype)instance;


#pragma mark - update
- (void)customSocket;


#pragma mark - get




#pragma mark - message

@end
