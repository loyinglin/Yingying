//
//  TransferMoodFriendListController.m
//  Yingying
//
//  Created by 林伟池 on 16/1/6.
//  Copyright © 2016年 林伟池. All rights reserved.
//

#import "TransferMoodFriendListController.h"

@interface TransferMoodFriendListController ()

@end

@implementation TransferMoodFriendListController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    return [super tableView:tableView willSelectRowAtIndexPath:indexPath];
}

@end
