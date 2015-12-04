//
//  MyTransferTableViewController.m
//  Yingying
//
//  Created by 林伟池 on 15/12/4.
//  Copyright © 2015年 林伟池. All rights reserved.
//

#import "MyTransferTableViewController.h"

@interface MyTransferTableViewController ()

@property (nonatomic , strong) UISearchController* mySearchController;

@end

@implementation MyTransferTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.mySearchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    self.mySearchController.automaticallyAdjustsScrollViewInsets = NO;
    self.mySearchController.dimsBackgroundDuringPresentation = NO;
    self.mySearchController.searchResultsUpdater = self;

    self.tableView.tableHeaderView = self.mySearchController.searchBar;
    [self.mySearchController.searchBar sizeToFit];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 26;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"head"];
    cell.textLabel.text = [NSString stringWithFormat:@"%c", (char)('A' + section)];
    
    return cell;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    NSMutableArray* arr = [NSMutableArray array];
//    [arr addObject:UITableViewIndexSearch];
    for (int i = 0; i < 26; ++i) {
        NSString* item = [NSString stringWithFormat:@"%c", (char)('A' + i)];
        [arr addObject:item];
    }
    return arr;
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

#pragma mark - ibaction

#pragma mark - ui

#pragma mark - delegate

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    NSLog(@"text:%@", searchController.searchBar.text);
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSLog(@"y %f", scrollView.contentOffset.y);
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self performSegueWithIdentifier:@"open_transfer_detail_board" sender:self];
    
    return nil;
}
#pragma mark - notify


@end
