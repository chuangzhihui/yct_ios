//
//  YCTApiPrivacy.m
//  YCT
//
//  Created by 木木木 on 2022/1/10.
//

#import "YCTApiPrivacy.h"

@implementation YCTPrivacyModel

- (NSString *)myZanListStatus {
    switch (self.myZanList) {
        case YCTPrivacyStatusAll:
            return YCTLocalizedTableString(@"mine.privacy.myZanList.all", @"Mine");
            break;
        case YCTPrivacyStatusCorrelation:
            return YCTLocalizedTableString(@"mine.privacy.myZanList.mutual", @"Mine");
            break;
        case YCTPrivacyStatusNone:
            return YCTLocalizedTableString(@"mine.privacy.myZanList.none", @"Mine");
            break;
        default:
            return @"";
            break;
    }
}

- (NSString *)chatTypeStatus {
    switch (self.chatType) {
        case YCTPrivacyStatusAll:
            return YCTLocalizedTableString(@"mine.privacy.chatType.all", @"Mine");
            break;
        case YCTPrivacyStatusCorrelation:
            return YCTLocalizedTableString(@"mine.privacy.chatType.mutual", @"Mine");
            break;
        case YCTPrivacyStatusNone:
            return YCTLocalizedTableString(@"mine.privacy.chatType.none", @"Mine");
            break;
        default:
            return @"";
            break;
    }
}

- (NSString *)myFansListStatus {
    switch (self.myFansList) {
        case YCTPrivacyStatusAll:
            return YCTLocalizedTableString(@"mine.privacy.myFansList.all", @"Mine");
            break;
        case YCTPrivacyStatusCorrelation:
            return YCTLocalizedTableString(@"mine.privacy.myFansList.mutual", @"Mine");
            break;
        case YCTPrivacyStatusNone:
            return YCTLocalizedTableString(@"mine.privacy.myFansList.none", @"Mine");
            break;
        default:
            return @"";
            break;
    }
}

- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic {
    if (self.myFansList == 0) {
        self.myFansList = YCTPrivacyStatusAll;
    }
    if (self.chatType == 0) {
        self.chatType = YCTPrivacyStatusAll;
    }
    if (self.myZanList == 0) {
        self.myZanList = YCTPrivacyStatusAll;
    }
    return YES;
}

@end

@implementation YCTApiPrivacy {
    BOOL _isFetch;
    YCTPrivacyOperation _operation;
    YCTPrivacyStatus _status;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _isFetch = YES;
    }
    return self;
}

- (instancetype)initWithOperation:(YCTPrivacyOperation)operation status:(YCTPrivacyStatus)status {
    self = [super init];
    if (self) {
        _isFetch = NO;
        _operation = operation;
        _status = status;
    }
    return self;
}

- (NSString *)requestUrl {
    if (_isFetch) {
        return @"/index/user/getPrivacy";
    } else {
        switch (_operation) {
            case YCTPrivacyOperationHomepageLikes:
                return @"/index/user/setZanlist";
                break;
            case YCTPrivacyOperationPrivateMsg:
                return @"/index/user/setChatType";
                break;
            case YCTPrivacyOperationFollowFans:
                return @"/index/user/setFanlist";
                break;
        }
    }
}

- (Class)dataModelClass {
    if (_isFetch) {
        return YCTPrivacyModel.class;
    } else {
        return nil;
    }
}

- (NSDictionary *)yct_requestArgument {
    if (_isFetch) {
        return nil;
    } else {
        switch (_operation) {
            case YCTPrivacyOperationHomepageLikes:
                return @{@"myZanList": @(_status)};
                break;
            case YCTPrivacyOperationPrivateMsg:
                return @{@"chatType": @(_status)};
                break;
            case YCTPrivacyOperationFollowFans:
                return @{@"myFansList": @(_status)};
                break;
        }
    }
}

@end
