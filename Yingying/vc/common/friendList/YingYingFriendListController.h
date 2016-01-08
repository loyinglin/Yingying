//
//  YingYingFriendListController.h
//  Yingying
//
//  Created by 林伟池 on 16/1/6.
//  Copyright © 2016年 林伟池. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YingYingFriendListViewModel.h"

@interface YingYingFriendListController : UITableViewController

@property (nonatomic , strong) UISearchController* mySearchController;

@property (nonatomic , strong) YingYingFriendListViewModel* myViewModel;

@end
