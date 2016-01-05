//
//  DistributionMoodViewModel.m
//  Yingying
//
//  Created by 林伟池 on 15/12/6.
//  Copyright © 2015年 林伟池. All rights reserved.
//

#import "DistributionResViewModel.h"
#import "UserModel.h"
#import "MapInfoModel.h"
#import "NSObject+LYUITipsView.h"
#import <MBProgressHUD.h>
#import <ReactiveCocoa.h>
#import <ReactiveCocoa/RACEXTScope.h>


@interface DistributionResViewModel()
@property (nonatomic , strong) NSArray* myImagesUrlArr;

@end

@implementation DistributionResViewModel



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

- (RACSignal *)requestSendRes {
    @weakify(self);
    
    return [[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        if ([[UserModel instance] getNeedLogin]) {
            [self presentMessageTips:@"请先登录"];
            [subscriber sendError:nil];
            return nil;
        }
        if (self.myImagesArr.count > 1) {
            MBProgressHUD* HUD = [[MBProgressHUD alloc] initWithView:self.myView];
            HUD.mode = MBProgressHUDModeAnnularDeterminate;
            HUD.labelText = @"上传中";
            [self.myView addSubview:HUD];
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
                NSDictionary* dict = responseObject;
                self.myImagesUrlArr = [dict objectForKey:@"msg_desc"];
                [subscriber sendNext:@"first ok"];
                [subscriber sendCompleted];
            } Fail:^{
                [HUD removeFromSuperview];
            }];
        }
        else {
            [subscriber sendNext:@"first ok"];
            [subscriber sendCompleted];
        }
        
        return nil;
    }] flattenMap:^RACStream *(id value) {
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            @strongify(self);
            
            BaseMessage* message = [BaseMessage instance];
            message.myLoadingStrings = @"发布中...";
            
            NSMutableDictionary* dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                         [[UserModel instance] getMyAccessToken], @"access_token",
                                         self.myMoodConent, @"moodContent",
                                         @(1),  @"type",
                                         self.myName, @"name",
                                         self.myPirce, @"price",
                                         nil];
            if (self.myImagesUrlArr) {
                [dict setObject:self.myImagesUrlArr forKey:@"thumbsurl"];
            }
            if (self.myLocName.length > 0) {
                [dict setObject:@([MapInfoModel instance].myPosition.longitude) forKey:@"x"];
                [dict setObject:@([MapInfoModel instance].myPosition.latitude) forKey:@"y"];
                [dict setObject:self.myLocName forKey:@"locName"];
            }
            
            [message sendRequestWithPost:[LY_MSG_BASE_URL stringByAppendingString:LY_MSG_MOOD_SEND_MOOD] Param:dict success:^(id responseObject) {
                [subscriber sendCompleted];
            }];
            
            return nil;
        }];
    }];
}

@end
