//
//  MineViewModel.h
//  Yingying
//
//  Created by 林伟池 on 16/1/4.
//  Copyright © 2016年 林伟池. All rights reserved.
//

#import "LYBaseViewModel.h"

typedef NS_ENUM(NSInteger, LY_MINE) {
    ly_mine_back_cost =     100, //体力变化
    ly_mine_back_end =      101, //体力耗尽
    ly_mine_back_coupon =   102, //购物券
    ly_mine_back_finance =  103, //理财券
    ly_mine_back_tips =     104, //挖矿tips
    ly_mine_back_harvest =  105, //离线到现在挖到的东西
};

typedef NS_ENUM(NSInteger, LY_MINE_STATUS) {
    ly_mine_status_not_start = -1,
    ly_mine_status_pause = 0,
    ly_mine_status_started  = 1
};

typedef NS_ENUM(NSInteger, LY_MINE_USER_OPERATION) {
    ly_mine_operation_left = 2,
    ly_mine_operation_enter = 3,
    ly_mine_operation_pause = 4,
    ly_mine_operation_exit = 5
};


#define ly_key_game_status      @"game_statue"
#define ly_key_uer_operation    @"usr_opt"
#define ly_key_msg_code         @"code"
#define ly_key_msg_manual       @"manual"

@interface MineViewModel : LYBaseViewModel

@property (nonatomic , strong) NSNumber* myGameStatus;
@property (nonatomic , strong) NSNumber* myGameManual;

@property (nonatomic , strong) NSArray*  myTicketsArray;
#pragma mark - init

+ (instancetype)instance;


#pragma mark - update
- (void)customSocket;

- (void)sendStartGame;

- (void)sendUserOperation:(LY_MINE_USER_OPERATION)operation;

#pragma mark - get


- (NSString *)getRandTips;

#pragma mark - message

@end
