//
//  YCTApiBlacklist.m
//  YCT
//
//  Created by 木木木 on 2022/1/9.
//

#import "YCTApiBlacklist.h"

@implementation YCTApiHandleBlacklist {
    YCTHandleBlacklistType _type;
    NSString *_userId;
}

- (instancetype)initWithType:(YCTHandleBlacklistType)type
                      userId:(NSString *)userId {
    self = [super init];
    if (self) {
        _userId = userId;
        _type = type;
    }
    return self;
}

- (NSString *)requestUrl {
    if (_type == YCTHandleBlacklistTypeAdd) {
        return @"/index/report/addBlackList";
    } else {
        return @"/index/report/removeBlackList";
    }
}

- (NSDictionary *)yct_requestArgument {
    return @{@"userId": _userId ?: @""};
}

@end

@implementation YCTApiBlacklist

- (NSString *)requestUrl {
    return @"/index/user/blacklist";
}

- (Class)dataModelClass {
    return YCTBlacklistItemModel.class;
}

@end
