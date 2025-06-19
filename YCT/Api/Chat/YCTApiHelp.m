//
//  YCTApiHelp.m
//  YCT
//
//  Created by 木木木 on 2022/1/19.
//

#import "YCTApiHelp.h"

@implementation YCTApiHelp

- (NSString *)requestUrl {
    return @"/index/user/help";
}

- (Class)dataModelClass {
    return YCTHelpItemModel.class;
}

@end
