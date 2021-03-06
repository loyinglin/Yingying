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
#import "UserMessage.h"
#import "AroundMessageDetailController.h"
#import "UIViewController+YingyingNavigationItem.h"
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
    
    
    BaseMessage* message = [BaseMessage instance];
    [message sendRequestWithPost:@"http://baike.baidu.com/api/openapi/BaikeLemmaCardApi?scope=103&format=json&appid=379020&bk_key=ABC&bk_length=600" Param:nil success:^(id responseObject) {
        NSLog(@"OK");
    }];
    
    [self lySetupRightItem];
    [self setupNotify];
    
    
    AFHTTPSessionManager* manager = [AFHTTPSessionManager manager];
    [manager GET:@"www.baidu.com" parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(responseObject);
    } failure:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - view init

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"open_around_detail_board"]) {
        AroundMessageDetailController* controller = segue.destinationViewController;
        [controller setMoodInfo:sender];
    }
}

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
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_UI_MAP_FILTER_UPDATE object:nil userInfo:@{NOTIFY_UI_MAP_FILTER_UPDATE:@(notify_enum_map_filter_all)}];
        }];
        [controller addAction:all];
        
        UIAlertAction* man = [UIAlertAction actionWithTitle:@"只看男" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_UI_MAP_FILTER_UPDATE object:nil userInfo:@{NOTIFY_UI_MAP_FILTER_UPDATE:@(notify_enum_map_filter_male)}];
        }];
        [controller addAction:man];
        
        UIAlertAction* woman = [UIAlertAction actionWithTitle:@"只看女" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_UI_MAP_FILTER_UPDATE object:nil userInfo:@{NOTIFY_UI_MAP_FILTER_UPDATE:@(notify_enum_map_filter_female)}];
        }];
        [controller addAction:woman];
        
        
        UIAlertAction* mood = [UIAlertAction actionWithTitle:@"只看心情" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_UI_MAP_FILTER_UPDATE object:nil userInfo:@{NOTIFY_UI_MAP_FILTER_UPDATE:@(notify_enum_map_filter_mood)}];
        }];
        [controller addAction:mood];
        
        
        UIAlertAction* res = [UIAlertAction actionWithTitle:@"只看资源" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_UI_MAP_FILTER_UPDATE object:nil userInfo:@{NOTIFY_UI_MAP_FILTER_UPDATE:@(notify_enum_map_filter_res)}];
        }];
        [controller addAction:res];
        
        
        UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            LYLog(@"cancel");
        }];
        [controller addAction:cancel];
        
        [self presentViewController:controller animated:YES completion:nil];
    }
    else {
        UIViewController* controller = [self.storyboard instantiateViewControllerWithIdentifier:@"modal_distribution_board"];
        
        
        if (self.tabBarController) {
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
        [self performSegueWithIdentifier:@"open_around_detail_board" sender:[note.userInfo objectForKey:NOTIFY_UI_OPEN_AROUND_DETAIL_BOARD]];
    }];
}

@end
