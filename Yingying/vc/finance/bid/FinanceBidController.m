//
//  FinanceBidController.m
//  Yingying
//
//  Created by 林伟池 on 15/12/12.
//  Copyright © 2015年 林伟池. All rights reserved.
//

#import "FinanceBidController.h"

@interface FinanceBidController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic , strong) IBOutlet UITableView* myTableView;

@end

@implementation FinanceBidController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.myTableView.rowHeight = UITableViewAutomaticDimension;
//    self.myTableView.sectionHeaderHeight = UITableViewAutomaticDimension;
    self.myTableView.estimatedRowHeight = 120;
//    self.myTableView.estimatedSectionHeaderHeight = 30;
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
    return 10;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString* cellStr = [NSString stringWithFormat:@"cell%ld", indexPath.row];
    if (indexPath.row >= 3) {
        cellStr = @"cell3";
    }
    
    UITableViewCell* ret = [tableView dequeueReusableCellWithIdentifier:cellStr forIndexPath:indexPath];
    
    return ret;
}


#pragma mark - notify


@end
