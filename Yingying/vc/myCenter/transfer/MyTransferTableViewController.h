//
//  MyTransferTableViewController.h
//  Yingying
//
//  Created by 林伟池 on 15/12/4.
//  Copyright © 2015年 林伟池. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyTransferViewModel.h"

@interface MyTransferTableViewController : UITableViewController<UISearchResultsUpdating>

@property (nonatomic , strong) UISearchController* mySearchController;

@property (nonatomic , strong) MyTransferViewModel* myViewModel;

@end
