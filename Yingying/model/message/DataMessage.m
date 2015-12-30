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
//    NSURL* url = [NSURL URLWithString:filePath];
//    self.background = YES;
//    
//    [self setMyFailBack:^(){
////        [[NSNotificationCenter defaultCenter] postNotificationName:<#(nonnull NSString *)#> object:<#(nullable id)#> userInfo:<#(nullable NSDictionary *)#>]
//    }];
//    
//    [self sendUploadWithPost:[LY_MSG_BASE_URL stringByAppendingString:LY_MSG_UPLOAD] Param:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
////        [formData appendPartWithFileURL:url name:@"upload" error:nil];
////        [formData appendPartWithFileURL:url name:@"upload" fileName:@"test.png" mimeType:@"image/png" error:nil];
////
//        UIImage* image = [UIImage imageWithContentsOfFile:filePath];
//        NSData *imageData = UIImagePNGRepresentation(image);
//        [formData appendPartWithFileData:imageData name:@"upload" fileName:@"test.png" mimeType:@"image/png"];
//
//    } success:^(id responseObject) {
//        NSDictionary* dict = responseObject;
//        NSString *retStr = [dict objectForKey:@"msg_desc"];
//        retStr = [retStr stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//        LYLog(@"back %@", retStr);
//    }];
}

@end
