//
//  AppDelegate.m
//  Yingying
//
//  Created by 林伟池 on 15/12/4.
//  Copyright © 2015年 林伟池. All rights reserved.
//

#import "AppDelegate.h"
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import "CDUserFactory.h"

@interface AppDelegate ()
@property (nonatomic , strong) BMKMapManager* myMapManager;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    self.myMapManager = [[BMKMapManager alloc] init];
    
    BOOL ret = [self.myMapManager start:@"lstHo03FUcRXBw8Ni0s5t0Ug" generalDelegate:nil];
    if (ret) {
        NSLog(@"baiduMap init success");
    }
    else {
        NSLog(@"baiduMap init failed");
    }
    
    /***************     chat            *************/
    [AVOSCloud setApplicationId:@"xcalhck83o10dntwh8ft3z5kvv0xc25p6t3jqbe5zlkkdsib" clientKey:@"m9fzwse7od89gvcnk1dmdq4huprjvghjtiug1u2zu073zn99"];
    [CDChatManager manager].userDelegate = [[CDUserFactory alloc] init];
    
#ifdef DEBUG
//    [AVOSCloud setAllLogsEnabled:YES];
#endif
    
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
