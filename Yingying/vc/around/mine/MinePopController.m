//
//  MinePopController.m
//  Yingying
//
//  Created by 林伟池 on 15/12/28.
//  Copyright © 2015年 林伟池. All rights reserved.
//

#import "MinePopController.h"

@interface MinePopController ()

@property (nonatomic , strong) IBOutlet UIView* myView0;
@property (nonatomic , strong) IBOutlet UIView* myView1;
@property (nonatomic , strong) IBOutlet UIView* myView2;

@property (nonatomic , strong) IBOutlet NSLayoutConstraint* myConstraint;

@property (nonatomic , assign) long myCount;
@end

#define LY_LAYOUT_ONE   100
#define LY_LAYOUT_TWO   65
#define LY_LAYOUT_THREE 30


@implementation MinePopController

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.myCount = 3;

    
    [self customView];
    [self customNotify];
}

#pragma mark - view init

- (void)customView {
    
}

#pragma mark - ibaction

- (IBAction)onSure:(id)sender {
//    [self initWithCount: --self.myCount];
    [self onCancel:sender];
}

- (IBAction)onCancel:(id)sender {
    [self dismissViewControllerAnimated:NO completion:nil];
}
#pragma mark - ui

- (void)initWithCount:(long)count {
    if (count == 1) {
        self.myView1.hidden = self.myView2.hidden = YES;
        self.myConstraint.constant = LY_LAYOUT_ONE;
    }
    if (count == 2) {
        self.myView2.hidden = YES;
        self.myConstraint.constant = LY_LAYOUT_TWO;
    }
    if (count == 3) {
        self.myConstraint.constant = LY_LAYOUT_THREE;
    }
}


#pragma mark - delegate

#pragma mark - notify

- (void)customNotify {
    
}


@end
