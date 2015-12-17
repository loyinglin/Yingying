//
//  AddressMessage.h
//  Supermark
//
//  Created by 林伟池 on 15/8/18.
//  Copyright (c) 2015年 林伟池. All rights reserved.
//

#import "BaseMessage.h"

@interface AddressMessage : BaseMessage

-(void)requestAddUserAddress:(NSString*)phone Address:(NSString*)addr;

@end
