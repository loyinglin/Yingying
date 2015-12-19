//
//  MyCashSwitchAccountController.m
//  Yingying
//
//  Created by 林伟池 on 15/12/19.
//  Copyright © 2015年 林伟池. All rights reserved.
//

#import "MyCashSwitchAccountController.h"

@interface MyCashSwitchAccountController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic , strong) IBOutlet UITableView*        myTableView;


@property (nonatomic , assign) long     mySelect;
@end

@implementation MyCashSwitchAccountController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.myTableView.rowHeight = UITableViewAutomaticDimension;
    self.myTableView.estimatedRowHeight = 80;
    
    self.mySelect = 0;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - view init

#pragma mark - ibaction

- (IBAction)onComfirm:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - ui

- (long)getCount {
    return 4;
}

#pragma mark - delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self getCount];
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell* cell;
    if (indexPath.row + 1 == [self getCount]) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"bottom" forIndexPath:indexPath];
        
    }
    else {
        cell = [tableView dequeueReusableCellWithIdentifier:@"item" forIndexPath:indexPath];
        UIImageView* selected = (UIImageView *)[cell viewWithTag:10];
        selected.hidden = indexPath.row != self.mySelect;
    }
    
    return cell;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row + 1 < [self getCount]) {
        self.mySelect = indexPath.row;
        [self.myTableView reloadData];
    }
    
    return nil;
}

#pragma mark - notify




@end
