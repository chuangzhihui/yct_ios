//
//  YCTApiUpdateBanner.m
//  YCT
//
//  Created by 木木木 on 2022/1/7.
//

#import "YCTApiUpdateBanner.h"

@implementation YCTApiAddBanner{
    NSString *_bannerUrl;
}

- (instancetype)initWithBannerUrl:(NSString *)bannerUr {
    self = [super init];
    if (self) {
        _bannerUrl = bannerUr;
    }
    return self;
}

- (NSString *)requestUrl {
    return @"/index/user/addBanner";
}

- (NSDictionary *)yct_requestArgument {
    return @{@"url": _bannerUrl ?: @""};
}

@end

@implementation YCTApiDeleteBanner{
    NSString *_bannerId;
}

- (instancetype)initWithBannerId:(NSString *)bannerId {
    self = [super init];
    if (self) {
        _bannerId = bannerId;
    }
    return self;
}

- (NSString *)requestUrl {
    return @"/index/user/deleteBanner";
}

- (NSDictionary *)yct_requestArgument {
    NSMutableDictionary *argument = @{}.mutableCopy;
    [argument setValue:_bannerId forKey:@"id"];
    return argument.copy;
}

@end

@implementation YCTApiSetBannerTop{
    NSString *_bannerId;
}

- (instancetype)initWithBannerId:(NSString *)bannerId {
    self = [super init];
    if (self) {
        _bannerId = bannerId;
    }
    return self;
}

- (NSString *)requestUrl {
    return @"/index/user/setBannerTop";
}

- (NSDictionary *)yct_requestArgument {
    NSMutableDictionary *argument = @{}.mutableCopy;
    [argument setValue:_bannerId forKey:@"id"];
    return argument.copy;
}

@end
