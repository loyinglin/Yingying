//
//  DataMessage.h
//  Yingying
//
//  Created by 林伟池 on 15/12/25.
//  Copyright © 2015年 林伟池. All rights reserved.
//

#import "BaseMessage.h"

@interface DataMessage : BaseMessage

- (void)requestUploadWithUrl:(NSString *)filePath;

@end
