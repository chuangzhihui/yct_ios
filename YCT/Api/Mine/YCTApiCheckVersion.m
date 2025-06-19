//
//  YCTApiCheckVersion.m
//  YCT
//
//  Created by 张大爷的 on 2024/6/23.
//

#import "YCTApiCheckVersion.h"
#import "YCTApiCheckVersionModel.h"
@implementation YCTApiCheckVersion
- (NSString *)requestUrl {
    return @"/index/home/checkVersion";
}

- (Class)dataModelClass {
    return YCTApiCheckVersionModel.class;
}
@end
