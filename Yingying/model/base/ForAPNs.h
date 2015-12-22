//
//  ForAPNs.h
//  Yingying
//
//  Created by 林伟池 on 15/12/22.
//  Copyright © 2015年 林伟池. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ForAPNs : NSObject

+ (instancetype)instance;


#pragma mark - init


#pragma mark - update



- (void)updateAPNs;

- (void)updateAPNsSettingWith:(BOOL)open;

- (void)updateSoundSettingWith:(BOOL)open;

- (void)updateVibrateSettingWith:(BOOL)open;

#pragma mark - get


- (BOOL)getPushOn;

- (BOOL)getSoundOn;

- (BOOL)getVibrateOn;

@end
