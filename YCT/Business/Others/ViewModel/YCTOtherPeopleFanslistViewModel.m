//
//  YCTOtherPeopleFanslistViewModel.m
//  YCT
//
//  Created by 木木木 on 2022/1/12.
//

#import "YCTOtherPeopleFanslistViewModel.h"

@implementation YCTOtherPeopleFanslistViewModel

- (instancetype)initWithUserId:(NSString *)userId {
    self = [super init];
    if (self) {
        self.request = [[YCTApiOtherPeopleFansList alloc] initWithUserId:userId];
    }
    return self;
}

@end
