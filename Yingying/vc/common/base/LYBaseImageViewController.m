//
//  LYBaseImageViewController.m
//  Yingying
//
//  Created by 林伟池 on 15/12/11.
//  Copyright © 2015年 林伟池. All rights reserved.
//

#import "LYBaseImageViewController.h"
#import "LYNotifyCenter.h"

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


#pragma mark - view init

- (void)setupGes {
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTap:)];
    [self.view addGestureRecognizer:tap];
}

#pragma mark - ibaction

- (IBAction)onDelete:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_UI_DELETE_PHOTO object:nil userInfo:@{NOTIFY_UI_DELETE_PHOTO:self.myImage}];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - ui

- (void)onTap:(UITapGestureRecognizer *)tap {
    [self.navigationController setNavigationBarHidden:!self.navigationController.navigationBarHidden animated:YES];
}

#pragma mark - delegate

#pragma mark - notify


@end
