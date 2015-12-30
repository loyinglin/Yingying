//
//  DistributionMoodViewModel.m
//  Yingying
//
//  Created by 林伟池 on 15/12/6.
//  Copyright © 2015年 林伟池. All rights reserved.
//

#import "DistributionMoodViewModel.h"
#import "UserModel.h"
#import "MoodMessage.h"
#import "NSObject+LYUITipsView.h"

@implementation DistributionMoodViewModel



#pragma mark - init

- (instancetype)init {
    self = [super init];
    self.myImagesArr = [NSArray arrayWithObjects:[UIImage imageNamed:@"distribution_add_button"], nil];
    return self;
}


#pragma mark - set

- (void)updateAddImage:(UIImage *)img {
    NSArray* arr = [NSArray arrayWithObjects:img, nil];
    self.myImagesArr = [arr arrayByAddingObjectsFromArray:self.myImagesArr];
}

#pragma mark - get



#pragma mark - update



#pragma mark - message


- (void)requestSendMoodWithContent:(NSString *)moodContent {
    
    if ([[UserModel instance] getNeedLogin]) {
        [self presentMessageTips:@"请先登录"];
    }
    else {
        MoodMessage* message = [MoodMessage instance];
        message.myLoadingStrings = @"发布中...";
        [message requestSendMoodWithToken:[[UserModel instance] getMyAccessToken] MoodContent:moodContent ThumbsUrl:nil];
    }
}
@end
