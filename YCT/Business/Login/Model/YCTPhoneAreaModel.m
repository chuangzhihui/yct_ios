//
//  YCTPhoneAreaModel.m
//  YCT
//
//  Created by 木木木 on 2022/1/8.
//

#import "YCTPhoneAreaModel.h"

@implementation YCTPhoneAreaModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"phoneAreaId" : @"id"};
}

- (NSComparisonResult)compare:(YCTPhoneAreaModel *)data {
    return [self.name localizedCompare:data.name];
}

@end
