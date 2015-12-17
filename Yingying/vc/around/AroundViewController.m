//
//  AroundViewController.m
//  Yingying
//
//  Created by 林伟池 on 15/12/4.
//  Copyright © 2015年 林伟池. All rights reserved.
//

#import "AroundViewController.h"
#import "LYNotifyCenter.h"
#import "LYColor.h"
#import "UserModel.h"
#import "AddressMessage.h"
#import "UserMessage.h"
#import <ReactiveCocoa.h>
#import <ReactiveCocoa/RACEXTScope.h>

@interface AroundViewController ()

@property (nonatomic , strong) UITabBarController* myTabbarController;

@property (nonatomic , strong) IBOutlet UIView* myAroundUnderline;
@property (nonatomic , strong) IBOutlet UIView* myMapUnderline;

@property (nonatomic , strong) IBOutlet UIButton* myRightButton;
@end

@implementation AroundViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.myTabbarController = self.childViewControllers[0];
    [self.myTabbarController.tabBar setHidden:YES];
    
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14], NSForegroundColorAttributeName:UIColorFromRGB(0x778c93)} forState:UIControlStateNormal];
//    [self.navigationItem.rightBarButtonItem setTitlePositionAdjustment:UIOffsetMake(0, 0) forBarMetrics:UIBarMetricsDefault];
//    [self.navigationItem.rightBarButtonItem setBackgroundVerticalPositionAdjustment:<#(CGFloat)#> forBarMetrics:<#(UIBarMetrics)#>]
    
//    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]} forState:UIControlStateSelected];
    
    

    [self setupNotify];
    [self test];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)test {
//    [[AddressMessage instance] requestAddUserAddress:nil Address:nil];
    [[UserModel instance] requestOauthLoginWithUserphone:@"13535107063" Password:@"12345678"];
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

#pragma mark - ibaction

- (IBAction)onSelectMap:(id)sender {
    [self.myTabbarController setSelectedIndex:0];
    [self.myRightButton setBackgroundImage:nil forState:UIControlStateNormal];
    [self.myRightButton setTitle:@"筛选" forState:UIControlStateNormal];
    
    self.myAroundUnderline.hidden = YES;
    self.myMapUnderline.hidden = NO;
}

- (IBAction)onSelectAround:(id)sender {
    [self.myTabbarController setSelectedIndex:1];
    
    [self.myRightButton setBackgroundImage:[UIImage imageNamed:@"icon_distribution"] forState:UIControlStateNormal];
    [self.myRightButton setTitle:nil forState:UIControlStateNormal];
    
    self.myAroundUnderline.hidden = NO;
    self.myMapUnderline.hidden = YES;

}

- (IBAction)onRightButton:(id)sender {
    if (self.myTabbarController.selectedIndex == 0) { //地图 筛选功能
        UIAlertController* controller = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        
        UIAlertAction* all = [UIAlertAction actionWithTitle:@"全部" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"all");
        }];
        [controller addAction:all];
        
        UIAlertAction* man = [UIAlertAction actionWithTitle:@"只看男" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"man");
        }];
        [controller addAction:man];
        
        UIAlertAction* woman = [UIAlertAction actionWithTitle:@"只看女" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"woman");
        }];
        [controller addAction:woman];
        
        
        UIAlertAction* mood = [UIAlertAction actionWithTitle:@"只看心情" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"mood");
        }];
        [controller addAction:mood];
        
        
        UIAlertAction* res = [UIAlertAction actionWithTitle:@"只看资源" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"res");
        }];
        [controller addAction:res];
        
        
        UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"cancel");
        }];
        [controller addAction:cancel];
        
        [self presentViewController:controller animated:YES completion:nil];        
    }
    else {
        UIViewController* controller = [self.storyboard instantiateViewControllerWithIdentifier:@"modal_distribution_board"];
        

        if (self.tabBarController) {
//            self.tabBarController.modalPresentationStyle = UIModalPresentationCurrentContext;
            [self.tabBarController presentViewController:controller animated:NO completion:nil];
        }
    }
}
#pragma mark - ui

#pragma mark - delegate

#pragma mark - notify

- (void)setupNotify {
    @weakify(self);
    [[NSNotificationCenter defaultCenter] addObserverForName:NOTIFY_UI_DISTRIBUTION_MOOD object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
        @strongify(self);
        [self performSegueWithIdentifier:@"open_distribution_mood_board" sender:self];
    }];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:NOTIFY_UI_DISTRIBUTION_RES object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
        @strongify(self);
        [self performSegueWithIdentifier:@"open_distribution_res_board" sender:self];
    }];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:NOTIFY_UI_OPEN_AROUND_DETAIL_BOARD object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
        @strongify(self);
        [self performSegueWithIdentifier:@"open_around_detail_board" sender:self];
    }];
}

@end
