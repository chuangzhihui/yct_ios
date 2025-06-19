//
//  YCTMineUserInfoModel.m
//  YCT
//
//  Created by 木木木 on 2021/12/30.
//

#import "YCTMineUserInfoModel.h"

@implementation YCTMineUserInfoModel

- (instancetype)init {
    self = [super init];
    if (self) {
        self.canEdituuid = NO;
        self.sex = YCTMineUserSexUnknown;
    }
    return self;
}

- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic {
    self.banners = [self.banners sortedArrayUsingComparator:^NSComparisonResult(YCTUserBannerItemModel * _Nonnull obj1, YCTUserBannerItemModel * _Nonnull obj2) {
        return obj1.sort < obj2.sort ? NSOrderedAscending : NSOrderedDescending;
    }];
    return YES;
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"banners": YCTUserBannerItemModel.class,
    };
}

- (NSUInteger)hash {
    return self.userTag.hash;
}

- (BOOL)isEqual:(id)object {
    if ([object isKindOfClass:[YCTMineUserInfoModel class]]) {
        YCTMineUserInfoModel *u = object;
        return [self.userTag isEqualToString:u.userTag];
    }
    return NO;
}


- (BOOL)isMerchant {
    if (self.status == 1) {
        if ([self.reason isEqualToString:@""] || self.reason == nil) {
            if (self.userType == YCTMineUserTypeBusiness) {
                return true;
            } else {
                return false;
            }
        }
    }
    return false;
}

@end
