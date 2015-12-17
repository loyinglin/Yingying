//
//  AddressMessage.m
//  Supermark
//
//  Created by 林伟池 on 15/8/18.
//  Copyright (c) 2015年 林伟池. All rights reserved.
//

#import "AddressMessage.h"
#import "AllMessage.h"

@implementation AddressMessage
{
    long del_address_id;
}
/**
 *  增加地址
 *
 *  @param phone 地址的手机
 *  @param addr  收货地址
 */
-(void)requestAddUserAddress:(NSString*)phone Address:(NSString*)addr
{
    NSDictionary* dict = [[NSDictionary alloc] initWithObjectsAndKeys:
                          @"13535107063", @"userphone",
                          @"12345678", @"password",
                          nil];
    
    [self sendRequestWithPost:[LY_MSG_BASE_URL stringByAppendingString:(NSString*)LY_MSG_OAUTH_LOGIN] Param:dict success:^(id responseObject) {
    }];
    
}

@end
