//
//  DataMessage.m
//  Yingying
//
//  Created by 林伟池 on 15/12/25.
//  Copyright © 2015年 林伟池. All rights reserved.
//

#import "DataMessage.h"

@implementation DataMessage

- (void)requestUploadWithUrl:(NSString *)filePath {
    NSURL* url = [NSURL URLWithString:filePath];
    [self sendUploadWithPost:[LY_MSG_BASE_URL stringByAppendingString:LY_MSG_UPLOAD] Param:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileURL:url name:@"loying" error:nil];
    } success:^(id responseObject) {
        LYLog(@"success");
    }];
}

@end
