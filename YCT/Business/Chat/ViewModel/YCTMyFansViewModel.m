//
//  YCTMyFansViewModel.m
//  YCT
//
//  Created by 木木木 on 2022/1/2.
//

#import "YCTMyFansViewModel.h"

@implementation YCTMyFansViewModel

- (instancetype)init {
    self = [super init];
    if (self) {
        self.request = [[YCTApiMyFans alloc] init];
    }
    return self;
}

- (void)handleNewPageData:(NSArray<YCTCommonUserModel *> *)data {
    [data enumerateObjectsUsingBlock:^(YCTCommonUserModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:YCTCommonUserModel.class]) {
            obj.isFollow = obj.isMutual;
        }
    }];
}

@end
