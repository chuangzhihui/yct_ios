//
//  YCTBlacklistViewModel.m
//  YCT
//
//  Created by 木木木 on 2022/1/9.
//

#import "YCTBlacklistViewModel.h"

@implementation YCTBlacklistViewModel

- (instancetype)init {
    self = [super init];
    if (self) {
        self.request = [[YCTApiBlacklist alloc] init];
    }
    return self;
}

- (void)handleNewPageData:(NSArray<YCTBlacklistItemModel *> *)data {
    [data enumerateObjectsUsingBlock:^(YCTBlacklistItemModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.isBlack = YES;
    }];
}

@end
