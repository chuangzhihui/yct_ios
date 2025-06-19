//
//  YCTApiOthersVideoList.m
//  YCT
//
//  Created by 木木木 on 2022/1/5.
//

#import "YCTApiOthersVideoList.h"

@implementation YCTApiOthersVideoList {
    YCTOthersVideoListType _type;
    NSString *_userId;
}

- (instancetype)initWithType:(YCTOthersVideoListType)type userId:(NSString *)userId {
    self = [super init];
    if (self) {
        _type = type;
        _userId = userId;
    }
    return self;
}

- (NSString *)requestUrl {
    switch (_type) {
        case YCTOthersVideoListTypeWorks:
            return @"/index/people/getUserVideoList";
            break;
        case YCTOthersVideoListTypeLikes:
            return @"/index/people/getPeopleLikeVideoList";
            break;
    }
}

- (Class)dataModelClass {
    return YCTVideoModel.class;
}

- (NSDictionary *)yct_requestArgument {
    NSMutableDictionary *argument = [NSMutableDictionary dictionaryWithDictionary:[super yct_requestArgument]];
    [argument setValue:_userId forKey:@"userId"];
    [argument setValue:@(_type) forKey:@"type"];
    return argument;
}

@end
