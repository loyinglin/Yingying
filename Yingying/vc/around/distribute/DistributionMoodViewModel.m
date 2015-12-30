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

@interface DistributionMoodViewModel()
@property (nonatomic , strong) NSArray* myImagesUrlArr;

@end

@implementation DistributionMoodViewModel

#pragma mark - init

- (instancetype)init {
    self = [super init];
    self.myImagesArr = [NSArray arrayWithObjects:[UIImage imageNamed:@"distribution_add_button"], nil];
    return self;
}


#pragma mark - set

- (void)updateAddImage:(UIImage *)img {
    NSArray* arr = [NSArray arrayWithObject:img];
    self.myImagesArr = [arr arrayByAddingObjectsFromArray:self.myImagesArr];
}

- (void)updateDeleteImage:(UIImage *)img {
    NSMutableArray* arr = [NSMutableArray arrayWithArray:self.myImagesArr];
    [arr removeObject:img];
    self.myImagesArr = arr;
}
#pragma mark - get



#pragma mark - update



#pragma mark - message


- (void)requestSendMoodWithContent:(NSString *)moodContent View:(UIView *)progressParentView {
    if ([[UserModel instance] getNeedLogin]) {
        [self presentMessageTips:@"请先登录"];
    }
    else {

        @weakify(self);
        [[[RACSignal startLazilyWithScheduler:[RACScheduler mainThreadScheduler] block:^(id<RACSubscriber> subscriber) {
            if (self.myImagesArr.count > 1) {
                MBProgressHUD* HUD = [[MBProgressHUD alloc] initWithView:progressParentView];
                HUD.mode = MBProgressHUDModeAnnularDeterminate;
                HUD.labelText = @"上传中";
                [progressParentView addSubview:HUD];
                [HUD show:YES];
                
                BaseMessage* uploadMessage = [BaseMessage instance];
                [uploadMessage sendUploadWithPost:[LY_MSG_BASE_URL stringByAppendingString:LY_MSG_UPLOAD] Param:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                    @strongify(self);
                    for (int i = 0; i < self.myImagesArr.count - 1; ++i) {
                        UIImage* img = self.myImagesArr[i];
                        NSData *imageData = UIImagePNGRepresentation(img);
                        [formData appendPartWithFileData:imageData name:[NSString stringWithFormat:@"upload%d", i] fileName:[NSString stringWithFormat:@"mood%d.png", i] mimeType:@"image/png"];
                    }
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
            else {
                [subscriber sendNext:@"first ok"];
                [subscriber sendCompleted];
            }
        }] flattenMap:^RACStream *(NSString* first) {
            LYLog(@"%@", first);
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                @strongify(self);
                MoodMessage* mood = [MoodMessage new];
                [mood requestSendMoodWithToken:[[UserModel instance] getMyAccessToken] MoodContent:moodContent ThumbsUrl:self.myImagesUrlArr];
                [subscriber sendCompleted];
                return nil;
            }];
        }] subscribeNext:^(id x) {
            LYLog(@"%@", x);
        }];

    }
}

@end
