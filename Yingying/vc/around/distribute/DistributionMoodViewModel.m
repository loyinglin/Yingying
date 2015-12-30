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
#import <ReactiveCocoa.h>
#import <ReactiveCocoa/RACEXTScope.h>

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

- (void)requestUploadImage:(NSString *)filePath View:(UIView *)progressParentView {
    
    MBProgressHUD* HUD = [[MBProgressHUD alloc] initWithView:progressParentView];
    HUD.mode = MBProgressHUDModeAnnularDeterminate;
    HUD.labelText = @"上传中";
    [progressParentView addSubview:HUD];
    [HUD show:YES];
    
    BaseMessage* uploadMessage = [BaseMessage instance];
    [uploadMessage sendUploadWithPost:[LY_MSG_BASE_URL stringByAppendingString:LY_MSG_UPLOAD] Param:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        UIImage* image = [UIImage imageWithContentsOfFile:filePath];
        NSData *imageData = UIImagePNGRepresentation(image);
        [formData appendPartWithFileData:imageData name:@"upload" fileName:@"test.png" mimeType:@"image/png"];
    } Progress:^(NSProgress *uploadProgress) {
        dispatch_async(dispatch_get_main_queue(), ^{
            HUD.progress = uploadProgress.fractionCompleted;
        });
    } success:^(id responseObject) {
        [HUD removeFromSuperview];
    } Fail:^{
        [HUD removeFromSuperview];
    }];
}


- (void)test {
    @weakify(self);
    
    [[[RACSignal startLazilyWithScheduler:[RACScheduler scheduler] block:^(id<RACSubscriber> subscriber) {
        sleep(3);
        [subscriber sendNext:@"first"];
        [subscriber sendCompleted];
    }] flattenMap:^RACStream *(NSString* first) {
        LYLog(@"%@", first);
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            sleep(3);
            [subscriber sendNext:@"second"];
            [subscriber sendCompleted];
            return nil;
        }];
    }] subscribeNext:^(id x) {
        LYLog(@"%@", x);
    }];
    
}
@end
