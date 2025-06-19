//
//  YCTApiGetMyGXList.m
//  YCT
//
//  Created by 木木木 on 2021/12/31.
//

#import "YCTApiGetMyGXList.h"

@implementation YCTApiGetMyGXList {
    YCTMyGXListType _type;
}

- (instancetype)initWithType:(YCTMyGXListType)type {
    self = [super init];
    if (self) {
        _type = type;
    }
    return self;
}

- (NSString *)requestUrl {
    return @"/index/user/getMyGXList";
}

- (Class)dataModelClass {
    return YCTMyGXListModel.class;
}

- (NSDictionary *)yct_requestArgument {
    NSMutableDictionary *argument = [NSMutableDictionary dictionaryWithDictionary:[super yct_requestArgument]];
    [argument setValue:@(_type) forKey:@"status"];
    return argument.copy;
}

@end
