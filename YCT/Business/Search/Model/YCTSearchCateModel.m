//
//  YCTSearchCateModel.m
//  YCT
//
//  Created by 张大爷的 on 2022/10/10.
//

#import "YCTSearchCateModel.h"

@implementation YCTSearchCateModel
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
        @"cateId" : @"id",
    };
}
@end
