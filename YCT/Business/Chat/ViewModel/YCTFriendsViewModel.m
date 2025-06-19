//
//  YCTFriendsViewModel.m
//  YCT
//
//  Created by 木木木 on 2022/1/2.
//

#import "YCTFriendsViewModel.h"

@implementation YCTFriendsViewModel

- (instancetype)init {
    self = [super init];
    if (self) {
        self.request = [[YCTApiMyFriendsList alloc] init];
    }
    return self;
}

@end
