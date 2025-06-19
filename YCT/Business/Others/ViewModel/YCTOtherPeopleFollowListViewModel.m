//
//  YCTOtherPeopleFollowListViewModel.m
//  YCT
//
//  Created by 木木木 on 2022/1/12.
//

#import "YCTOtherPeopleFollowListViewModel.h"

@implementation YCTOtherPeopleFollowListViewModel

- (instancetype)initWithUserId:(NSString *)userId {
    self = [super init];
    if (self) {
        self.request = [[YCTApiOtherPeopleFollowList alloc] initWithUserId:userId];
    }
    return self;
}

@end
