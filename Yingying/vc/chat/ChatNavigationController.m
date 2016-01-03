//
//  ChatNavigationController.m
//  Yingying
//
//  Created by 林伟池 on 16/1/3.
//  Copyright © 2016年 林伟池. All rights reserved.
//

#import "ChatNavigationController.h"
#import "CDUserFactory.h"
#import "ChatDetailController.h"
#import "LYBaseViewModel.h"

@interface ChatNavigationController ()
@property (nonatomic , strong) NSNumber* uid;
@end

@implementation ChatNavigationController

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self customView];
    [self customNotify];
}

#pragma mark - view init

- (void)setChatWithUid:(NSNumber *)uid {
    self.uid = uid;
}

- (void)customView {
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
//    NSLog(@"did");
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        if (self.uid) {
            @weakify(self);
            [[CDChatManager manager] fetchConvWithOtherId:[NSString stringWithFormat:@"%@", self.uid] callback : ^(AVIMConversation *conversation, NSError *error) {
                if (error) {
                    LYLog(@"%@", error);
                }
                else {
                    if (conversation.attributes) {
                        [conversation update:@{@"nickname":@"abc"} callback:^(BOOL succeeded, NSError *error) {
                            if (succeeded) {
                                NSLog(@"update success");
                            }
                            NSLog(@"after update %@", [conversation.attributes description]);
                        }];
                    }
                    NSLog(@"attributes %@", [conversation.attributes description]);
                    
                    ChatDetailController *chatRoomVC = [[ChatDetailController alloc] initWithConv:conversation];
                    chatRoomVC.hidesBottomBarWhenPushed = YES;
                    
                    @strongify(self);
                    [self pushViewController:chatRoomVC animated:YES];
                }
                self.uid = nil;
            }];
        }

    });
}


#pragma mark - ibaction

#pragma mark - ui

#pragma mark - delegate

#pragma mark - notify

- (void)customNotify {

}


@end
