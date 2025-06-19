//
//  CompanyAuditApi.m
//  YCT
//
//  Created by 林涛 on 2025/4/1.
//

#import "CompanyAuditApi.h"

@implementation CompanyAuditApi
- (NSString *)requestUrl {
    return @"index/user/getIsPay";
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}

- (Class)dataModelClass {
    return CompanyAuditModel.class;
}
@end
