//
//  MyTransferViewModel.m
//  Yingying
//
//  Created by 林伟池 on 15/12/5.
//  Copyright © 2015年 林伟池. All rights reserved.
//

#import "MyTransferViewModel.h"

@interface MyTransferViewModel()

@property (nonatomic , strong) NSMutableDictionary* myFriendDict;

@property (nonatomic , strong) NSMutableDictionary* mySearchDict;

@end

@implementation MyTransferViewModel



#pragma mark - init

- (instancetype)init {
    self = [super init];
    self.myFriendDict = [NSMutableDictionary dictionary];
    self.mySearchDict = [NSMutableDictionary dictionary];
    
    NSArray *stringsToSort=[NSArray arrayWithObjects:
                            @"￥hhh, .$",@" ￥Chin ese ",@"开源中国 ",@"www.oschina.net",
                            @"开源技术",@"社区",@"开发者",@"传播",
                            @"2013",@"100",@"中国",@"暑假作业",
                            @"键盘", @"鼠标",@"hello",@"world",
                            nil];
    
    [self transToFriends:stringsToSort];
    
    return self;
}

#pragma mark - set

- (void)transToFriends:(NSArray *)arr {
    NSMutableArray* friends = [NSMutableArray array];
    
    for (NSString* str in arr) {
        if ([str isKindOfClass:[NSString class]]) {
            Friend* item = [Friend new];
            item.name = str;
            item.pingying = [self getPinyinWithStr:str];
            [friends addObject:item];
        }
    }
    
    [friends sortUsingComparator:^NSComparisonResult(Friend* obj1, Friend* obj2) {
        return [obj1.pingying compare:obj2.pingying options:NSCaseInsensitiveSearch];
    }];
    
    for (Friend* item in friends) {
        NSString* key;
        NSMutableArray* friendArr;
        if ([self getIsCharWithStr:item.pingying]) {
            key = [item.pingying substringToIndex:1];
        }
        else {
            key = @"#";
        }
        
        friendArr = [self.myFriendDict objectForKey:key];
        if (friendArr) {
            [friendArr addObject:item];
        }
        else {
            friendArr = [NSMutableArray arrayWithObjects:item, nil];
            [self.myFriendDict setObject:friendArr forKey:key];
        }
    }
    
    self.myFriends = friends;
    

}

#pragma mark - get


- (long)getSectionsCount {
    long ret;
    ret = [self.myFriendDict allKeys].count;
    return ret;
}

- (long)getFriendsCountBySection:(long)section {
    long ret = 0;
    NSArray* arr = [self getIndexsArray];
    if (section >= 0 && section < arr.count) {
        NSString* key = arr[section];
        NSMutableArray* friendArr = [self.myFriendDict objectForKey:key];
        ret = friendArr.count;
    }
    return ret;
}

- (NSArray<NSString *> *)getIndexsArray {
    NSArray* arr = [self.myFriendDict allKeys];
    arr = [arr sortedArrayUsingComparator:^NSComparisonResult(NSString* obj1, NSString* obj2) {
        return [obj1 compare:obj2];
    }];
    
    return arr;
}

- (Friend *)getFriendByIndex:(long)index Section:(long)section {
    Friend* ret;
    NSArray* arr = [self getIndexsArray];
    if (section >= 0 && section < arr.count) {
        NSString* key = arr[section];
        NSMutableArray* friendArr = [self.myFriendDict objectForKey:key];
        if (friendArr && friendArr.count > index) {
            ret = [friendArr objectAtIndex:index];
        }
    }
    return ret;
}

// search

- (long)getSearchSectionsCount {
    long ret;
    ret = [self.mySearchDict allKeys].count;
    return ret;
}

- (long)getSearchFriendsCountBySection:(long)section {
    long ret = 0;
    NSArray* arr = [self getSearchIndexsArray];
    if (section >= 0 && section < arr.count) {
        NSString* key = arr[section];
        NSMutableArray* friendArr = [self.mySearchDict objectForKey:key];
        ret = friendArr.count;
    }
    return ret;
}

- (NSArray<NSString *> *)getSearchIndexsArray {
    NSArray* arr = [self.mySearchDict allKeys];
    arr = [arr sortedArrayUsingComparator:^NSComparisonResult(NSString* obj1, NSString* obj2) {
        return [obj1 compare:obj2];
    }];
    
    return arr;
}

- (Friend *)getSearchFriendByIndex:(long)index Section:(long)section {
    Friend* ret;
    NSArray* arr = [self getSearchIndexsArray];
    if (section >= 0 && section < arr.count) {
        NSString* key = arr[section];
        NSMutableArray* friendArr = [self.mySearchDict objectForKey:key];
        if (friendArr && friendArr.count > index) {
            ret = [friendArr objectAtIndex:index];
        }
    }
    return ret;
}




- (NSString *)getPinyinWithStr:(NSString *)str {
    
    NSString* ret;
    
    NSMutableString *lin = [[NSMutableString alloc] initWithString:str];
    if (CFStringTransform((__bridge CFMutableStringRef)lin, 0, kCFStringTransformMandarinLatin, NO)) {
        if (CFStringTransform((__bridge CFMutableStringRef)lin, 0, kCFStringTransformStripDiacritics, NO)) {
            ret = [lin uppercaseString];
        }
    }
    
    return ret;
}

- (BOOL)getIsCharWithStr:(NSString *)str {
    BOOL ret;
    char word = [str characterAtIndex:0];
    if ('A' <= word && word <= 'Z') {
        ret = YES;
    }
    else {
        ret = NO;
    }
    
    return ret;
}

#pragma mark - update

- (void)searchWithText:(NSString *)text {
    NSArray* allKey = [self.myFriendDict allKeys];
    self.mySearchDict = [NSMutableDictionary dictionary];
    NSPredicate* predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"SELF.name LIKE[cd] '*%@*'", text]];
    
    for (NSString* key in allKey) {
        NSArray* arr = [self.myFriendDict objectForKey:key];
        
        arr = [arr filteredArrayUsingPredicate:predicate];
        if (arr.count > 0) {
            [self.mySearchDict setObject:arr forKey:key];
        }
    }
}

#pragma mark - message

@end
