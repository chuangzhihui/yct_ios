//
//  YCTOtherPeopleVideoListViewModel.m
//  YCT
//
//  Created by 木木木 on 2022/1/5.
//

#import "YCTOtherPeopleVideoListViewModel.h"

@implementation YCTOtherPeopleVideoListViewModel

- (instancetype)initWithType:(YCTOthersVideoListType)type userId:(NSString *)userId {
    self = [super init];
    if (self) {
        self.request = [[YCTApiOthersVideoList alloc] initWithType:type userId:userId];
    }
    return self;
}

@end
