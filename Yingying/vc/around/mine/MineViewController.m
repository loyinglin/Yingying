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
#import <AVFoundation/AVFoundation.h>
#import "UIViewController+YingyingNavigationItem.h"

@interface MineViewController () <AVAudioPlayerDelegate>

@property (nonatomic , strong) AVAudioPlayer*                   myPlayer;
@property (nonatomic , strong) IBOutlet UIImageView*            myMiningImageView;
@property (nonatomic , strong) IBOutlet NSLayoutConstraint*     myProgressConstraint;


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
        LYLog(@"ABCABC %@", status);
        if (status && status.integerValue >= 0) {
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
        }
        else {
            [self.myMiningImageView setImage:[UIImage imageNamed:@"around_mine_init"]];
        }
    }];
    
    [RACObserve(self.myViewModel, myGameManual) subscribeNext:^(id x) {
        
    }];
    
    
    [self prepareToPlay];
//    [self playRecord];
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
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self stopPlay];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

#pragma mark - ibaction

- (IBAction)onMine:(UIButton *)sender {
    
    [self.myViewModel sendStartGame];
    [UIView animateWithDuration:3.0 animations:^{
        self.myProgressConstraint.constant = 270;
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        self.myProgressConstraint.constant = 30;
        [self performSegueWithIdentifier:@"open_mine_pop_board" sender:nil];
    }];
}

- (IBAction)onBack:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - ui

- (void)customProgressWithManual:(NSNumber *)manual {

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
