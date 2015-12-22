//
//  ForAPNs.m
//  Yingying
//
//  Created by 林伟池 on 15/12/22.
//  Copyright © 2015年 林伟池. All rights reserved.
//

#import "ForAPNs.h"
#import "CDUserFactory.h"
#import <UIKit/UIKit.h>

@implementation ForAPNs

#define yinging_push_key        @"yingying_push_key"
#define yingying_sound_key      @"yingying_sound_key"
#define yingying_vibrate_key    @"yingying_vibrate_key"

#pragma mark - init


+ (instancetype)instance
{
    static id test;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        test = [[[self class] alloc] init];
    });
    return test;
}

#pragma mark - update

- (void)updateAPNs {
    NSNumber* push = [[NSUserDefaults standardUserDefaults] objectForKey:yinging_push_key];
    
    
    
    if (push && push.boolValue) {
        UIUserNotificationSettings *settings;
        settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge|UIUserNotificationTypeSound|UIUserNotificationTypeAlert categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }
    else {
        [[UIApplication sharedApplication] unregisterForRemoteNotifications];
    }
    
    
}

- (void)updateAPNsSettingWith:(BOOL)open {
    [[NSUserDefaults standardUserDefaults] setObject:@(open) forKey:yinging_push_key];
    [self updateAPNs];
}


- (void)updateSoundSettingWith:(BOOL)open {
    [[CDSoundManager manager] setNeedPlaySoundWhenChatting:open];
    [[CDSoundManager manager] setNeedPlaySoundWhenNotChatting:open];
    [[NSUserDefaults standardUserDefaults] setObject:@(open) forKey:yingying_sound_key];
}


- (void)updateVibrateSettingWith:(BOOL)open {
    [[CDSoundManager manager] setNeedVibrateWhenNotChatting:open];
    [[NSUserDefaults standardUserDefaults] setObject:@(open) forKey:yingying_vibrate_key];
}

#pragma mark - get

- (BOOL)getPushOn {
    BOOL ret = NO;
    NSNumber* number = [[NSUserDefaults standardUserDefaults] objectForKey:yinging_push_key];
    if (number && number.boolValue) {
        ret = YES;
    }
    
    return ret;
}


- (BOOL)getSoundOn {
    BOOL ret = NO;
    NSNumber* number = [[NSUserDefaults standardUserDefaults] objectForKey:yingying_sound_key];
    if (number && number.boolValue) {
        ret = YES;
    }
    
    return ret;
}


- (BOOL)getVibrateOn {
    BOOL ret = NO;
    NSNumber* number = [[NSUserDefaults standardUserDefaults] objectForKey:yingying_vibrate_key];
    if (number && number.boolValue) {
        ret = YES;
    }
    
    return ret;
}


#pragma mark - message

@end
