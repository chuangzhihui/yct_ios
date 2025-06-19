//
//  YCTApiMyFriendsList.m
//  YCT
//
//  Created by 木木木 on 2022/1/2.
//

#import "YCTApiMyFriendsList.h"

@implementation YCTApiMyFriendsList

- (NSString *)requestUrl {
    return @"/index/msg/friendList";
}

- (Class)dataModelClass {
    return YCTChatFriendModel.class;
}

@end
