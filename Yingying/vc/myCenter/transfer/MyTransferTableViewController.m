//
//  MyTransferTableViewController.m
//  Yingying
//
//  Created by 林伟池 on 15/12/4.
//  Copyright © 2015年 林伟池. All rights reserved.
//

#import "MyTransferTableViewController.h"
#import "MyTransferViewModel.h"

@interface MyTransferTableViewController ()

@property (nonatomic , strong) MyTransferViewModel* myViewModel;
@end

@implementation MyTransferTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.myViewModel = [MyTransferViewModel new];
    
    [self customView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    long ret;
    if ([self.mySearchController isActive]) {
        ret = [self.myViewModel getSearchSectionsCount];
    }
    else {
        ret = [self.myViewModel getSectionsCount];
    }
    
    return ret;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if ([self.mySearchController isActive]) {
        return [self.myViewModel getSearchFriendsCountBySection:section];
    }
    else {
        return [self.myViewModel getFriendsCountBySection:section];
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    Friend* item;
    
    if ([self.mySearchController isActive]) {
        item = [self.myViewModel getSearchFriendByIndex:indexPath.row Section:indexPath.section];
    }
    else {
        item = [self.myViewModel getFriendByIndex:indexPath.row Section:indexPath.section];
    }
    
    UILabel* nameLabel = (UILabel *)[cell viewWithTag:10];
    nameLabel.text = item.name;
    // Configure the cell...
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"head"];
    NSArray* arr;
    
    if ([self.mySearchController isActive]) {
        arr = [self.myViewModel getSearchIndexsArray];
    }
    else {
        arr = [self.myViewModel getIndexsArray];
    }
    
    cell.textLabel.text = arr[section];
    
    return cell;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    
    if ([self.mySearchController isActive]) {
        return [self.myViewModel getSearchIndexsArray];
    }
    else {
        return [self.myViewModel getIndexsArray];   
    }
}

-(NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    NSLog(@"===%@  ===%ld",title,index);
    
    //点击索引，列表跳转到对应索引的行
    

        [tableView
         scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:index]
         atScrollPosition:UITableViewScrollPositionTop animated:YES];

    
    
    return index;
}

#pragma mark - view init

- (void)customView {
    
    self.mySearchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    self.mySearchController.automaticallyAdjustsScrollViewInsets = NO;
    self.mySearchController.dimsBackgroundDuringPresentation = NO;
    self.mySearchController.searchResultsUpdater = self;
    
    self.tableView.tableHeaderView = self.mySearchController.searchBar;
    [self.mySearchController.searchBar sizeToFit];
    
    
    
    self.tableView.sectionIndexBackgroundColor = [UIColor clearColor];
}

#pragma mark - ibaction

#pragma mark - ui

#pragma mark - delegate

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    NSLog(@"text:%@", searchController.searchBar.text);
    [self.myViewModel searchWithText:searchController.searchBar.text];
    [self.tableView reloadData];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    NSLog(@"y %f", scrollView.contentOffset.y);
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
//    [self.mySearchController dismissViewControllerAnimated:YES completion:nil];
    [self.mySearchController setActive:NO];
    
    [self performSegueWithIdentifier:@"open_transfer_detail_board" sender:self];
    
    return nil;
}
#pragma mark - notify


@end
