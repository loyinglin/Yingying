//
//  MineViewModel.m
//  Yingying
//
//  Created by 林伟池 on 16/1/4.
//  Copyright © 2016年 林伟池. All rights reserved.
//

#import "MineViewModel.h"
#import "UserModel.h"
#import <SocketRocket/SRWebSocket.h>

@interface MineViewModel() <SRWebSocketDelegate>
@property (nonatomic , strong) SRWebSocket* myWebSocket;

@end


@implementation MineViewModel



#pragma mark - init

- (instancetype)init {
    self = [super init];
    [self customSocket];
    return self;
    
}


- (void)customSocket {
    if ([[UserModel instance] getMyAccessToken].length > 0) {
        NSString* urlString = [NSString stringWithFormat:@"ws://120.25.101.195/YinYin/game?access_token=%@", [[UserModel instance] getMyAccessToken]];
        urlString = @"ws://echo.websocket.org";
        LYLog(@"%@", urlString);
        self.myWebSocket = [[SRWebSocket alloc] initWithURL:[NSURL URLWithString:urlString]];
        self.myWebSocket.delegate = self;
        [self.myWebSocket open];
//        [self.myWebSocket send:@"abc"];
    }
    
    [self sendData];
}

#pragma mark - update

- (void)sendData {
    NSDictionary* dict = @{@"game_statue":@(0)};
    if ([NSJSONSerialization isValidJSONObject:dict]) {
        NSData* data= [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];
        NSString* str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        LYLog(@"DATA %@", data);
//        [self.myWebSocket send:data];
    }}


#pragma mark - get




#pragma mark - message


#pragma mark - delgate

- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message {
    LYLog(@"web socket %@", message);
    [self sendData];
}


- (void)webSocketDidOpen:(SRWebSocket *)webSocket {
    LYLog(@"open");
}
- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error {
    LYLog(@"fail %@", error);
}
- (void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean {
    LYLog(@"close %@", reason);
}
- (void)webSocket:(SRWebSocket *)webSocket didReceivePong:(NSData *)pongPayload {
    LYLog(@"pong %@", pongPayload);
}
@end
