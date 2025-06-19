//
//  YCTMintGetLocationModel.m
//  YCT
//
//  Created by 木木木 on 2021/12/26.
//

#import "YCTMintGetLocationModel.h"

@implementation YCTMintGetLocationModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"cid" : @"id"};
}

- (NSComparisonResult)compare:(YCTMintGetLocationModel *)data {
    return [self.name localizedCompare:data.name];
}

@end
