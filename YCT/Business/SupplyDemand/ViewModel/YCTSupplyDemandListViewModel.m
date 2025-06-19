//
//  YCTSupplyDemandListViewModel.m
//  YCT
//
//  Created by 木木木 on 2021/12/10.
//

#import "YCTSupplyDemandListViewModel.h"

@implementation YCTSupplyDemandListViewModel

- (instancetype)initWithType:(NSUInteger)type {
    self = [super init];
    if (self) {
        self.request = [[YCTApiSupplyDemandList alloc] init];
        self.request.type=(int)type;
    }
    return self;
}

@end
