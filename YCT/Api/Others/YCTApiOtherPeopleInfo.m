//
//  YCTApiOtherPeopleInfo.m
//  YCT
//
//  Created by 木木木 on 2022/1/5.
//

#import "YCTApiOtherPeopleInfo.h"

@implementation YCTApiOtherPeopleInfo {
    NSString *_userId;
}

- (instancetype)initWithUserId:(NSString *)userId {
    self = [super init];
    if (self) {
        _userId = userId;
    }
    return self;
}

- (NSString *)requestUrl {
    return @"/index/people/info";
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}

- (Class)dataModelClass {
    return YCTOtherPeopleInfoModel.class;
}

- (NSDictionary *)yct_requestArgument {
    return @{@"userId": _userId ?: @""};
}

@end

@implementation YCTApiOtherPeopleFollowList {
    NSString *_userId;
}

- (instancetype)initWithUserId:(NSString *)userId {
    self = [super init];
    if (self) {
        _userId = userId;
    }
    return self;
}

- (Class)dataModelClass {
    return YCTCommonUserModel.class;
}

- (NSString *)requestUrl {
    return @"index/people/getPeopleFllowList";
}

- (NSDictionary *)yct_requestArgument {
    NSMutableDictionary *argument = [NSMutableDictionary dictionaryWithDictionary:[super yct_requestArgument]];
    [argument setValue:_userId forKey:@"userId"];
    return argument.copy;
}

@end

@implementation YCTApiOtherPeopleFansList {
    NSString *_userId;
}

- (instancetype)initWithUserId:(NSString *)userId {
    self = [super init];
    if (self) {
        _userId = userId;
    }
    return self;
}

- (Class)dataModelClass {
    return YCTCommonUserModel.class;
}

- (NSString *)requestUrl {
    return @"index/people/getPeopleFansList";
}

- (NSDictionary *)yct_requestArgument {
    NSMutableDictionary *argument = [NSMutableDictionary dictionaryWithDictionary:[super yct_requestArgument]];
    [argument setValue:_userId forKey:@"userId"];
    return argument.copy;
}

@end
