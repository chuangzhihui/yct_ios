//
//  YCTApiSuggestFollowUserList.m
//  YCT
//
//  Created by 木木木 on 2022/1/2.
//

#import "YCTApiSuggestFollowUserList.h"

@implementation YCTApiSuggestFollowUserList

- (NSString *)requestUrl {
    return @"/index/msg/suggestFloowUserList";
}

- (Class)dataModelClass {
    return YCTSearchUserModel.class;
}

@end
