//
//  YCTMyGXListViewModel.m
//  YCT
//
//  Created by 木木木 on 2021/12/31.
//

#import "YCTMyGXListViewModel.h"

@implementation YCTMyGXListViewModel

- (instancetype)initWithType:(YCTMyGXListType)type {
    self = [super init];
    if (self) {
        self.request = [[YCTApiGetMyGXList alloc] initWithType:type];
    }
    return self;
}

@end
