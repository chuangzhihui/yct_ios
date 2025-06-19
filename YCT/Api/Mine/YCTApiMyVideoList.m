//
//  YCTApiMyVideoList.m
//  YCT
//
//  Created by 木木木 on 2022/1/1.
//

#import "YCTApiMyVideoList.h"

@implementation YCTApiMyVideoList {
    YCTMyVideoListType _type;
}

- (instancetype)initWithType:(YCTMyVideoListType)type {
    self = [super init];
    if (self) {
        _type = type;
    }
    return self;
}

- (NSString *)requestUrl {
    switch (_type) {
        case YCTMyVideoListTypeWorks:
            return @"/index/user/getMyVideoList";
            break;
        case YCTMyVideoListTypeLikes:
            return @"/index/user/myLikeList";
            break;
        case YCTMyVideoListTypeCollection:
            return @"/index/user/myCollectionList";
            break;
        case YCTMyVideoListTypeAudit:
            return @"/index/user/getMyApplyVideoList";
            break;
        case YCTMyVideoListTypeDraft:
            return @"/index/user/getMyDraftVideoList";
            break;
    }
}

- (Class)dataModelClass {
    return YCTVideoModel.class;
}

- (NSDictionary *)yct_requestArgument {
    NSMutableDictionary *argument = [NSMutableDictionary dictionaryWithDictionary:[super yct_requestArgument]];
    [argument setValue:@(_type) forKey:@"status"];
    return argument.copy;
}

@end
