//
//  YCTApiChangePhoneNumber.m
//  YCT
//
//  Created by 木木木 on 2022/3/17.
//

#import "YCTApiChangePhoneNumber.h"

@implementation YCTApiChangePhoneNumber

- (NSString *)requestUrl {
    return @"/index/user/changeOrginalPhone";
}

- (NSDictionary *)yct_requestArgument {
    NSMutableDictionary *argument = @{}.mutableCopy;
    [argument setValue:self.originalSmsCode forKey:@"originalSmsCode"];
    [argument setValue:self.mobile forKey:@"mobile"];
    [argument setValue:self.smsCode forKey:@"smsCode"];
    return argument.copy;
}

@end
