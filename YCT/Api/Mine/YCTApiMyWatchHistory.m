//
//  YCTApiMyWatchHistory.m
//  YCT
//
//  Created by 木木木 on 2021/12/31.
//

#import "YCTApiMyWatchHistory.h"

@implementation YCTApiMyWatchHistory

- (NSString *)requestUrl {
    return @"/index/user/myWatchLog";
}

- (Class)dataModelClass {
    return YCTVideoModel.class;
}

@end

@implementation YCTApiClearWatchHistory

- (NSString *)requestUrl {
    return @"/index/user/clearWatchLog";
}

@end
