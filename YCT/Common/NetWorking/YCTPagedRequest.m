//
//  YCTPagedRequest.m
//  YCT
//
//  Created by 木木木 on 2021/12/29.
//

#import "YCTPagedRequest.h"

@implementation YCTPagedRequest

- (NSDictionary *)yct_requestArgument {
    return @{
        @"page": @(self.page),
        @"size": @(self.size),
    };
}

@end
