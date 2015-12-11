//
//  LYBaseImageViewController.m
//  Yingying
//
//  Created by 林伟池 on 15/12/11.
//  Copyright © 2015年 林伟池. All rights reserved.
//

#import "LYBaseImageViewController.h"

@interface LYBaseImageViewController ()

@property (nonatomic , strong) IBOutlet UIImageView* myImageView;

@end

@implementation LYBaseImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (self.myImage) {
        [self.myImageView setImage:self.myImage];
        
        [self setupGes];
    }
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


#pragma mark - view init

- (void)setupGes {
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTap:)];
    [self.view addGestureRecognizer:tap];
}

#pragma mark - ibaction

#pragma mark - ui

- (void)onTap:(UITapGestureRecognizer *)tap {
    [self.navigationController setNavigationBarHidden:!self.navigationController.navigationBarHidden animated:YES];
}

#pragma mark - delegate

#pragma mark - notify


@end
