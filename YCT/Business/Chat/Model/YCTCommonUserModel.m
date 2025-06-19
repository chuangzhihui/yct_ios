//
//  YCTCommonUserModel.m
//  YCT
//
//  Created by 木木木 on 2022/1/10.
//

#import "YCTCommonUserModel.h"

@implementation YCTCommonUserModel

- (instancetype)init {
    self = [super init];
    if (self) {
        [[YCTSharedDataManager sharedInstance] addObject:self];
    }
    return self;
}

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
        @"isFollow" : @[@"isFllow", @"isFloow"],
        @"userId" : @[@"id", @"userId"],
        @"intro": @[@"interduce"]
    };
}

- (NSString *)id {
    return self.userId;
}

- (NSString *)dataType {
    return NSStringFromSelector(@selector(isFollow));
}

@end
