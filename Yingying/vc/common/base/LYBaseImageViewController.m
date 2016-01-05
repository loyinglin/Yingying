//
//  LYBaseImageViewController.m
//  Yingying
//
//  Created by 林伟池 on 15/12/11.
//  Copyright © 2015年 林伟池. All rights reserved.
//

#import "LYBaseImageViewController.h"
#import "LYNotifyCenter.h"
#import "UIImageView+AFNetworking.h"

@interface LYBaseImageViewController ()<UIScrollViewDelegate>

@property (nonatomic , strong) NSString*    myImageUrlString;
@property (nonatomic , assign) BOOL         myHideRightBarButton;
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
    else if (self.myImageUrlString) {
        [self.myImageView setImageWithURL:[NSURL URLWithString:self.myImageUrlString]];
    }
    
    if (self.myHideRightBarButton) {
        self.navigationItem.rightBarButtonItem = nil;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - view init

- (void)customFromAroundDetailWith:(NSString *)imageUrlString HideRightBarButton:(BOOL)hideAble{
    self.myImageUrlString = imageUrlString;
    self.myHideRightBarButton = YES;
}


- (void)setupGes {
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTap:)];
    [self.view addGestureRecognizer:tap];
}

#pragma mark - ibaction

- (IBAction)onDelete:(id)sender {
    if (self.myImage) {
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_UI_DELETE_PHOTO object:nil userInfo:@{NOTIFY_UI_DELETE_PHOTO:self.myImage}];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - ui

- (void)onTap:(UITapGestureRecognizer *)tap {
    [self.navigationController setNavigationBarHidden:!self.navigationController.navigationBarHidden animated:YES];
}

#pragma mark - delegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.myImageView;
}

#pragma mark - notify


@end
