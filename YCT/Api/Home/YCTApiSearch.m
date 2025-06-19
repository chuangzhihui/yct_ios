//
//  YCTApiSearchVideo.m
//  YCT
//
//  Created by hua-cloud on 2022/1/12.
//

#import "YCTApiSearch.h"
#import "YCTVideoModel.h"

#import "YCTSearchUserModel.h"
@implementation YCTApiSearch{
    NSString * _locationId;
    NSString * _keyWords;
    NSInteger _page;
    YCTApiSearchType _type;
}

- (instancetype)initWithLocationId:(NSString *)locationId
                           keyword:(NSString *)keyword
                              page:(NSInteger)page
                              type:(YCTApiSearchType)type{
    self = [super init];
    if (self) {
        _locationId = locationId;
        _keyWords = keyword;
        _page = page;
        _type = type;
        
    }
    return self;
}

- (NSString *)requestUrl {
    return _type == YCTApiSearchTypeComprehensive ? @"/index/home/search" : _type == YCTApiSearchTypeVideo ? @"index/home/searchVideo" : @"/index/home/searchUser";
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}

- (Class)dataModelClass {
    if (_type == YCTApiSearchTypeComprehensive) {
        return YCTComprehensiveSearchModel.class;
    }else if (_type == YCTApiSearchTypeVideo){
        return YCTVideoModel.class;
    }else{
        return YCTSearchUserModel.class;
    }
    
}

- (NSDictionary *)yct_requestArgument {
    NSMutableDictionary * para = @{
        @"locationId": _locationId,
        @"keyWords": _keyWords,
    }.mutableCopy;
    if (_type != YCTApiSearchTypeComprehensive) {
        [para addEntriesFromDictionary:@{@"page":@(_page),@"size":@(20)}];
    }
    return para.copy;
}

@end
