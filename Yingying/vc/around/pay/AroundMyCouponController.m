//
//  AroundMyCouponController.m
//  Yingying
//
//  Created by 林伟池 on 15/12/13.
//  Copyright © 2015年 林伟池. All rights reserved.
//

#import "AroundMyCouponController.h"
#import "AroundMyCouponViewModel.h"

@interface AroundMyCouponController ()

@property (nonatomic , strong) AroundMyCouponViewModel* myViewModel;

@end

@implementation AroundMyCouponController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.myViewModel = [AroundMyCouponViewModel new];
    self.myViewModel.myType = self.myType;
    
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 10)];
//    self.tableView.rowHeight = UITableViewAutomaticDimension;
    @weakify(self);
    [[self.myViewModel requestGetMyCoupon] subscribeCompleted:^{
        @strongify(self);
        [self.tableView reloadData];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UI



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.myViewModel getCouponCount];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    // Configure the cell...
    TicketInfo* info = [self.myViewModel getCouponbyIndex:indexPath.row];
    if (info) {
        UILabel* expireLabel = (UILabel *)[cell viewWithTag:10];
        UILabel* sumLabel = (UILabel *)[cell viewWithTag:20];
        expireLabel.text = info.expire_date;
        if (info.sum) {
            sumLabel.text = [NSString stringWithFormat:@"%@元", info.sum];
        }
        else {
            sumLabel.text = nil;
        }
    }
    
    return cell;
}




@end
