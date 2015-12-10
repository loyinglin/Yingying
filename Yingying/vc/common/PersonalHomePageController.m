//
//  PersonalHomePageController.m
//  Yingying
//
//  Created by 林伟池 on 15/12/8.
//  Copyright © 2015年 林伟池. All rights reserved.
//

#import "PersonalHomePageController.h"
#import "PersonalHomePageViewModel.h"


@interface PersonalHomePageController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic , strong) IBOutlet UITableView* myTableView;


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
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"message" forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}

#pragma mark - view init

#pragma mark - ibaction

- (IBAction)onCancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - ui

#pragma mark - delegate

#pragma mark - notify


@end
