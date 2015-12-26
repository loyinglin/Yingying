//
//  MineViewController.m
//  Yingying
//
//  Created by 林伟池 on 15/12/5.
//  Copyright © 2015年 林伟池. All rights reserved.
//

#import "MineViewController.h"
#import "NSObject+LYUITipsView.h"
#import <AVFoundation/AVFoundation.h>

@interface MineViewController () <AVAudioPlayerDelegate>

@property (nonatomic, strong) AVAudioPlayer*    myPlayer;

@end

@implementation MineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self prepareToPlay];
    [self playRecord];

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

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self stopPlay];
}

#pragma mark - ibaction

- (IBAction)onMine:(id)sender {
    [self presentMessageTips:@"挖空了"];
}

- (IBAction)onBack:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - ui

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
