//
//  PersonalHomePageController.m
//  Yingying
//
//  Created by 林伟池 on 15/12/8.
//  Copyright © 2015年 林伟池. All rights reserved.
//

#import "PersonalHomePageController.h"
#import "PersonalHomePageViewModel.h"

typedef NS_ENUM(NSInteger, LYHOMEPAGE) {
    ly_photo,
    ly_information,
    ly_message
};



@interface PersonalHomePageController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic , strong) IBOutlet UITableView* myTableView;

@property (nonatomic , strong) IBOutlet UIView* myBottomView;

@property (nonatomic , strong) PersonalHomePageViewModel* myViewModel;

@end

@implementation PersonalHomePageController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.myViewModel = [PersonalHomePageViewModel new];
    
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
    
    self.myTableView.rowHeight = UITableViewAutomaticDimension;
    self.myTableView.estimatedRowHeight = 100;
    
    self.myTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.myTableView.bounds.size.width, self.myBottomView.bounds.size.height)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - view init

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
            cell = [tableView dequeueReusableCellWithIdentifier:@"message" forIndexPath:indexPath];
            break;
            
    }
    

    return cell;
}


#pragma mark - notify


@end
