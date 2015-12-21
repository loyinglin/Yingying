//
//  PersonalHomePageController.m
//  Yingying
//
//  Created by 林伟池 on 15/12/8.
//  Copyright © 2015年 林伟池. All rights reserved.
//

#import "PersonalHomePageController.h"
#import "PersonalHomePageViewModel.h"
#import "LYColor.h"
#import "UIView+LYModify.h"
#import "UIViewController+YingyingNavigationItem.h"

typedef NS_ENUM(NSInteger, LYHOMEPAGE) {
    ly_photo,
    ly_information,
    ly_message
};



@interface PersonalHomePageController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic , strong) IBOutlet UITableView* myTableView;

@property (nonatomic , strong) IBOutlet UIView* myBottomView;

@property (nonatomic , strong) IBOutlet UIView* myPopView;

@property (nonatomic , strong) PersonalHomePageViewModel* myViewModel;

@end

@implementation PersonalHomePageController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.myViewModel = [PersonalHomePageViewModel new];
    
    [self customView];
    [self setupLeftItem];
    [self test];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - view init

- (void)customView {
    
    [self.myBottomView lySetupBorderwithColor:0xf0f0f0 Width:1 Radius:0];
    
    self.myTableView.rowHeight = UITableViewAutomaticDimension;
    self.myTableView.estimatedRowHeight = 100;
    
    self.myTableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.myTableView.bounds.size.width, 20)];
    [self.myTableView.tableHeaderView setBackgroundColor:UIColorFromRGB(0xf0f0f0)];
    
    self.myTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.myTableView.bounds.size.width, self.myBottomView.bounds.size.height + 10)];
}

- (void)test {
    
    [RACObserve(self.myViewModel, mySelf) subscribeNext:^(id x) {
        NSLog(@"test1 %@", x);
    }];
    
    self.myViewModel.mySelf = YES;
    
    
    [RACObserve(self.myViewModel, mySelf) subscribeNext:^(id x) {
        NSLog(@"test2 %@", x);
    }];
    
    self.myViewModel.mySelf = NO;
    
    
    [RACObserve(self.myViewModel, mySelf) subscribeNext:^(id x) {
        NSLog(@"test3 %@", x);
    }];
}
#pragma mark - ibaction

- (IBAction)onCancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (IBAction)onAddFriend:(id)sender {
    NSLog(@"add friend");
}

- (IBAction)onContact:(id)sender {
    NSLog(@"contace him");
}

- (IBAction)onTransfer:(id)sender {
    NSLog(@"transfer");
}

- (IBAction)onDeleteFriend:(id)sender {
    NSLog(@"delelte");
}

- (IBAction)onRightButtonClick:(id)sender {
    self.myPopView.hidden = !self.myPopView.hidden;
    [self.view bringSubviewToFront:self.myPopView]; //为了方便在IB中编辑，把pop放在最下层。
}
#pragma mark - ui

#pragma mark - delegate


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    long ret = 0;
    
    switch (section) {
        case ly_photo:
            ret = 2;
            break;
            
        case ly_information:
            ret = 4;
            break;
            
        case ly_message:
            ret = 5;
            break;
            
        default:
            break;
    }
    
    return ret;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    UITableViewCell *cell;
    
    switch (indexPath.section) {
        case ly_photo:
            cell = [tableView dequeueReusableCellWithIdentifier:@"photo" forIndexPath:indexPath];
            
            break;
            
        case ly_information:
            cell = [tableView dequeueReusableCellWithIdentifier:@"information" forIndexPath:indexPath];
            break;
            
        case ly_message:
            if (indexPath.row == 0) {
                cell = [tableView dequeueReusableCellWithIdentifier:@"message_head" forIndexPath:indexPath];
            }
            else {
                cell = [tableView dequeueReusableCellWithIdentifier:@"message" forIndexPath:indexPath];
            }
            break;
            
    }
    

    return cell;
}

//- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//    UIView* ret = nil;
//    if (section == ly_message) {
//        ret = [tableView dequeueReusableCellWithIdentifier:@"message_head"];
//    }
//    return ret;
//}
#pragma mark - notify


@end
