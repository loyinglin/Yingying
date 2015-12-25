//
//  DataModel.h
//  Yingying
//
//  Created by 林伟池 on 15/12/25.
//  Copyright © 2015年 林伟池. All rights reserved.
//

#import "BaseModel.h"

@interface DataModel : BaseModel



#pragma mark - init

+(instancetype)instance;

#pragma mark - update



#pragma mark - get




#pragma mark - message

- (void)requestUploadWith:(NSString *)url;

@end
