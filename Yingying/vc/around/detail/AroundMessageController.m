//
//  AroundDetailController.m
//  Yingying
//
//  Created by 林伟池 on 15/12/4.
//  Copyright © 2015年 林伟池. All rights reserved.
//

#import "AroundMessageController.h"
#import "LYNotifyCenter.h"
#import "MJRefresh.h"
#import "MapInfoModel.h"
#import "AroundMoodViewModel.h"
#import "AroundMoodTableViewCell.h"
#import "UIImageView+AFNetworking.h"
#import <ReactiveCocoa.h>
#import <ReactiveCocoa/RACEXTScope.h>

@interface AroundMessageController ()
@property (nonatomic , strong) IBOutlet UITableView* myTableView;

@property (nonatomic , strong) AroundMoodViewModel* myViewModel;
@end

@implementation AroundMessageController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.myViewModel = [AroundMoodViewModel new];
    
    @weakify(self);
    [self.myTableView addHeaderWithCallback:^{
        @strongify(self);
        [self.myViewModel updateRequestInitMoods];
//        disp
    }];
    [self.myTableView addFooterWithCallback:^{
        @strongify(self);
        [self.myViewModel updateRequestMoreMoods];
    }];
    
    [RACObserve(self.myViewModel, myMoodsArr) subscribeNext:^(id x) {
        @strongify(self);
        [self.myTableView reloadData];
        [self.myTableView headerEndRefreshing];
        [self.myTableView footerEndRefreshing];
    }];
        
    self.myTableView.estimatedRowHeight = 104;
    self.myTableView.rowHeight = UITableViewAutomaticDimension;
    

    [self.myViewModel updateRequestInitMoods];
    [self customNotify];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - view init

#pragma mark - ibaction

#pragma mark - ui

#pragma mark - delegate


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.myViewModel getMoodsCount];
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AroundMoodTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    [cell customCellWithMoodInfo:[self.myViewModel getMoodInfoByIndex:indexPath.row]];
    return cell;
}

-(NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    MoodInfo* info = [self.myViewModel getMoodInfoByIndex:indexPath.row];
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_UI_OPEN_AROUND_DETAIL_BOARD object:nil userInfo:@{NOTIFY_UI_OPEN_AROUND_DETAIL_BOARD:info}];
    
    return nil;
}
#pragma mark - notify

- (void)customNotify {
    @weakify(self);
    [[NSNotificationCenter defaultCenter] addObserverForName:NOTIFY_UI_REFRESH_AROUND_MOOD object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
        @strongify(self);
        [self.myViewModel updateRequestInitMoods];
    }];
}

@end
