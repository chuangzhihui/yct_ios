//
//  YCTMyVideoListViewModel.m
//  YCT
//
//  Created by 木木木 on 2022/1/1.
//

#import "YCTMyVideoListViewModel.h"

@implementation YCTMyVideoListViewModel

- (instancetype)initWithType:(YCTMyVideoListType)type {
    self = [super init];
    if (self) {
        self.request = [[YCTApiMyVideoList alloc] initWithType:type];
    }
    return self;
}

@end
