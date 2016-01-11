//
//  MineViewController.m
//  Yingying
//
//  Created by 林伟池 on 15/12/5.
//  Copyright © 2015年 林伟池. All rights reserved.
//

#import "MineViewController.h"
#import "NSObject+LYUITipsView.h"
#import "MineViewModel.h"
#import "MinePopController.h"
#import <AVFoundation/AVFoundation.h>
#import "UIViewController+YingyingNavigationItem.h"

typedef NS_ENUM(NSInteger, LY_MINE_UI) {
    ly_mine_ui_progress_length = 270,
    ly_mine_server_max_manual = 60
};

@interface MineViewController () <AVAudioPlayerDelegate>

@property (nonatomic , strong) AVAudioPlayer*                   myPlayer;
@property (nonatomic , strong) IBOutlet UIImageView*            myMiningImageView;
@property (nonatomic , strong) IBOutlet NSLayoutConstraint*     myProgressConstraint;
@property (nonatomic , strong) IBOutlet UILabel*                myManualLabel;
@property (nonatomic , strong) IBOutlet UILabel*                myMineTipsLabel;
@property (nonatomic , strong) IBOutlet UIButton*               myPauseButton;

@property (nonatomic , strong) NSTimer*                         myTipsTimer;
@property (nonatomic , strong) MineViewModel*                   myViewModel;
//@property (nonatomic , strong) IBOutlet ;

@end

@implementation MineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.myViewModel = [MineViewModel instance];
    [self.myViewModel customSocket];

    @weakify(self);
    [RACObserve(self.myViewModel, myGameStatus) subscribeNext:^(NSNumber* status) {
        if (status && status.integerValue == ly_mine_status_started) { //开始游戏，显示动画
            @strongify(self);
            NSArray* arr = @[@"around_mine_mining0",
                             @"around_mine_mining0",
                             @"around_mine_mining0",
                             @"around_mine_mining1",
                             @"around_mine_mining2",
                             @"around_mine_mining2",
                             @"around_mine_mining2",
                             ];
            NSMutableArray* imgs = [NSMutableArray array];
            for (NSString* name in arr) {
                [imgs addObject:[UIImage imageNamed:name]];
            }
            UIImage* mining = [UIImage animatedImageWithImages:imgs duration:0.7];
            [self.myMiningImageView setImage:mining];
            self.myPauseButton.hidden = NO;
        }
        else {  //暂停、游戏，停止动画
            [self.myMiningImageView setImage:[UIImage imageNamed:@"around_mine_init"]];
            self.myPauseButton.hidden = YES;
        }
    }];
    
    [[RACObserve(self.myViewModel, myGameManual) map:^id(id value) {
        if (!value) {
            return @(0);
        }
        return value;
    }]subscribeNext:^(NSNumber* manual) {
        @strongify(self);
        float constant = manual.floatValue / ly_mine_server_max_manual * ly_mine_ui_progress_length;
        self.myProgressConstraint.constant = constant;
        self.myManualLabel.text = [NSString stringWithFormat:@"体力:%@", manual];
    }];
    
    [RACObserve(self.myViewModel, myTicketsArray) subscribeNext:^(NSArray* array) {
        if (array) {
            @strongify(self);
            [self performSegueWithIdentifier:@"open_mine_pop_board" sender:array];
            self.myViewModel.myTicketsArray = nil;
        }
    }];
    
    [self prepareToPlay];
    [self customView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    LYLog(@"dealloc");
}
#pragma mark - view init

- (void)customView {
    [self lySetupLeftItem];
    self.myTipsTimer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(onTimer:) userInfo:nil repeats:YES];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.myViewModel sendUserOperation:ly_mine_operation_enter];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.myViewModel sendUserOperation:ly_mine_operation_left];
    [self.myTipsTimer invalidate];
    self.myTipsTimer = nil;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

#pragma mark - ibaction

- (IBAction)onMine:(UIButton *)sender {
    if (self.myViewModel.myGameManual && self.myViewModel.myGameManual.integerValue > 0) {
        [self.myViewModel sendStartGame];
    }
    else {
        [self presentMessageTips:@"体力已用完，稍等体力恢复"];
    }
    /*
    [UIView animateWithDuration:3.0 animations:^{
        self.myProgressConstraint.constant = 270;
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        self.myProgressConstraint.constant = 30;
    }];
     */
}

- (IBAction)onBack:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - ui

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"open_mine_pop_board"]) {
        MinePopController* controller = segue.destinationViewController;
        controller.myHarvestArray = sender;
    }
}

- (void)onTimer:(id)sender {
    self.myMineTipsLabel.text = [self.myViewModel getRandTips];
}

- (void)prepareToPlay {
    [self stopPlay];
    NSString* path = [[NSBundle mainBundle] pathForResource:@"awake" ofType:@".mp3"];
    if (path) {
        NSURL* url = [[NSURL alloc] initWithString:path];
        self.myPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
        
        [self.myPlayer setDelegate:self];
        [self.myPlayer setEnableRate:YES];
//        [self.myPlayer setRate:self.myPlayRate / 10.0];
        [self.myPlayer setVolume:0.5];
    }
}


- (void)stopPlay {
    
    if (self.myPlayer) {
        [self.myPlayer stop];
        AVAudioSession* session = [AVAudioSession sharedInstance];
        [session setActive:NO error:nil];
        self.myPlayer = nil;
    }
}

- (void)playRecord {
    AVAudioSession* session = [AVAudioSession sharedInstance];
    [session setActive:YES error:nil];
    [self.myPlayer play];
}

#pragma mark - delegate

- (void) audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    LYLog(@"play end");
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setActive:NO error:nil];
}

- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError * __nullable)error{
    LYLog(@"%@", [error description]);
}

#pragma mark - notify


@end
