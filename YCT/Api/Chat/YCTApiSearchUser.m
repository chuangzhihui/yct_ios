//
//  YCTApiSearchUser.m
//  YCT
//
//  Created by 木木木 on 2022/1/2.
//

#import "YCTApiSearchUser.h"

@implementation YCTApiSearchUser

- (NSString *)requestUrl {
    if (self.keyWords.length == 0) {
        return @"/index/msg/suggestFloowUserList";
    } else {
        return @"/index/msg/searchUser";
    }
}

- (Class)dataModelClass {
    return YCTCommonUserModel.class;
}

- (NSDictionary *)yct_requestArgument {
    NSMutableDictionary *argument = [NSMutableDictionary dictionaryWithDictionary:[super yct_requestArgument]];
    [argument setValue:self.keyWords forKey:@"keyWords"];
    return argument.copy;
}


@end
