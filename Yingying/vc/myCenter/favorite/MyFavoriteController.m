//
//  MyFavoriteController.m
//  Yingying
//
//  Created by 林伟池 on 15/12/23.
//  Copyright © 2015年 林伟池. All rights reserved.
//

#import "MyFavoriteController.h"

@interface MyFavoriteController ()

@end

@implementation MyFavoriteController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self customView];
    [self customNotify];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - view init

- (void)customView {
    
}

#pragma mark - ibaction

#pragma mark - ui



#pragma mark - delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}

#pragma mark - notify

- (void)customNotify {
    
}


@end
