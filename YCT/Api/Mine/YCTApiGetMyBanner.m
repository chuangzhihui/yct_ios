//
//  YCTApiGetMyBanner.m
//  YCT
//
//  Created by 木木木 on 2022/1/10.
//

#import "YCTApiGetMyBanner.h"

@implementation YCTApiGetMyBanner

- (NSString *)requestUrl {
    return @"/index/user/getMyBanner";
}

- (Class)dataModelClass {
    return YCTUserBannerItemModel.class;
}

@end
