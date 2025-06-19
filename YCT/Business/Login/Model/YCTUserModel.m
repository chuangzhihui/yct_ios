//
//  YCTUserModel.m
//  YCT
//
//  Created by hua-cloud on 2021/12/26.
//

#import "YCTUserModel.h"

@implementation YCTLoginModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
        @"IMName": @[@"IMName", @"imname"]
    };
}

- (NSString *)userIdFromIMName {
    return [self.IMName stringByReplacingOccurrencesOfString:@"user" withString:@""];
}

@end

@implementation YCTWeChatLoginModel
@end

@implementation YCTZaloLoginModel
@end
@implementation YCTFaceBookLoginModel
@end
@implementation YCTOpenAuthLoginModel
@end

@implementation YCTZaloUserModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
        @"userId"  : @"id",
        @"nickName"  : @"name",
        @"avatarUrl"  : @"picture.data.url"
    };
}

@end
