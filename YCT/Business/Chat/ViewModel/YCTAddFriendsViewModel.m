//
//  YCTAddFriendsViewModel.m
//  YCT
//
//  Created by 木木木 on 2022/1/2.
//

#import "YCTAddFriendsViewModel.h"

@implementation YCTAddFriendsViewModel

- (instancetype)init {
    self = [super init];
    if (self) {
        self.request = [[YCTApiSearchUser alloc] init];
    }
    return self;
}

- (void)setKeywords:(NSString *)keywords {
    _keywords = keywords;
    self.request.keyWords = keywords;
}

@end

@implementation YCTSuggestFollowViewModel

- (instancetype)init {
    self = [super init];
    if (self) {
        self.request = [[YCTApiSuggestFollowUserList alloc] init];
    }
    return self;
}

@end
