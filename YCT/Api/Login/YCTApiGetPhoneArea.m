//
//  YCTApiGetPhoneArea.m
//  YCT
//
//  Created by 木木木 on 2022/1/8.
//

#import "YCTApiGetPhoneArea.h"

@implementation YCTApiGetPhoneArea

- (NSString *)requestUrl{
    return @"/index/login/getPhoneArea";
}

- (Class)dataModelClass{
    return YCTPhoneAreaModel.class;
}

@end
