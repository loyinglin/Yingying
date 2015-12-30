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
        LYLog(@"back");
        @strongify(self);
        [self.myTableView headerEndRefreshing];
    }];
        
    self.myTableView.estimatedRowHeight = 140;
    self.myTableView.rowHeight = UITableViewAutomaticDimension;
    
    CLLocationCoordinate2D pos = [MapInfoModel instance].myPosition;
    if (pos.latitude) { //注意pos不是指针
        [self.myViewModel requestGetMoodNearMoodWithLongitude:@(pos.longitude) Latitude:@(pos.latitude) PageIndex:nil];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - view init

#pragma mark - ibaction

#pragma mark - ui

#pragma mark - delegate

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    static UITableViewCell* cell;
//    if (!cell) {
//        cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
//    }
//    CGSize ret;
//    ret = [cell systemLayoutSizeFittingSize:ret];
//    
//
//    return ret.height;
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    
    return cell;
}

-(NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_UI_OPEN_AROUND_DETAIL_BOARD object:nil];
    
    return nil;
}
#pragma mark - notify


@end
