//
//  YCTMyFollowViewModel.m
//  YCT
//
//  Created by 木木木 on 2022/1/16.
//

#import "YCTMyFollowViewModel.h"

@implementation YCTMyFollowViewModel

- (instancetype)init {
    self = [super init];
    if (self) {
        self.request = [[YCTApiMyFollow alloc] init];
    }
    return self;
}

- (void)handleNewPageData:(NSArray<YCTCommonUserModel *> *)data {
    [data enumerateObjectsUsingBlock:^(YCTCommonUserModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:YCTCommonUserModel.class]) {
            obj.isFollow = YES;
        }
    }];
}

@end
