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


+ (instancetype)instance {
    static id test;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        test = [[[self class] alloc] init];
    });
    return test;
}


- (instancetype)init {
    self = [super init];
//    self.myGameStatus = @(0);
    return self;
    
}


- (void)customSocket {
//    self.myGameStatus = @(0);
    if (self.myWebSocket) {
        return ;
    }
    if ([[UserModel instance] getMyAccessToken].length > 0) {
        NSString* urlString = [NSString stringWithFormat:@"ws://120.25.101.195/YinYin/game?access_token=%@", [[UserModel instance] getMyAccessToken]];
        LYLog(@"connecting %@", urlString);
        self.myWebSocket = [[SRWebSocket alloc] initWithURL:[NSURL URLWithString:urlString]];
        self.myWebSocket.delegate = self;
        [self.myWebSocket open];
    }
}

#pragma mark - update

- (void)sendDataWithDict:(NSDictionary *)dict {
    if ([NSJSONSerialization isValidJSONObject:dict]) {
        NSData* data= [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];
        NSString* str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        LYLog(@"send %@", str);
        [self.myWebSocket send:str];
    }
    else {
        LYLog(@"dict error");
    }
}


#pragma mark - get




#pragma mark - message

- (void)sendStartGame {
    [self sendDataWithDict:@{ly_key_game_status:@(0)}];
}

- (void)sendLeftInGame {
    [self sendDataWithDict:@{ly_key_game_status:@(1), ly_key_uer_operation:@(2)}];
}

- (void)sendEnterInGame {
    [self sendDataWithDict:@{ly_key_game_status:@(1), ly_key_uer_operation:@(3)}];
}

- (void)sendPauseInGame {
    [self sendDataWithDict:@{ly_key_game_status:@(1), ly_key_uer_operation:@(4)}];
}

- (void)sendExitInGame {
    [self sendDataWithDict:@{ly_key_game_status:@(1), ly_key_uer_operation:@(5)}];
}

#pragma mark - delgate

- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message {
    LYLog(@"socket back:%@", message);
    NSDictionary* dict = [NSDictionary dictionaryWithJsonString:message];
    if (dict) {
        NSNumber* manual = [dict objectForKey:ly_key_msg_manual];
        NSNumber* status = [dict objectForKey:ly_key_game_status];
        NSNumber* code = [dict objectForKey:ly_key_msg_code];
        
        if (manual) {
            self.myGameManual = manual;
        }
        if (status) {
            self.myGameStatus = status;
        }
        if (code) {
            
        }
        
//        LYLog(@"%@", manual);
    }
}

- (void)webSocketDidOpen:(SRWebSocket *)webSocket {
    LYLog(@"open");
}

- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error {
    LYLog(@"fail %@", error);
    self.myWebSocket = nil;
}

- (void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean {
    LYLog(@"close %@", reason);
    self.myWebSocket = nil;
}

- (void)webSocket:(SRWebSocket *)webSocket didReceivePong:(NSData *)pongPayload {
    LYLog(@"pong %@", pongPayload);
}
@end
