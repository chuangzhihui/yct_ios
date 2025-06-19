//
//  YCTApiOtherPeopleInfo.h
//  YCT
//
//  Created by 木木木 on 2022/1/5.
//

#import "YCTBaseRequest.h"
#import "YCTPagedRequest.h"
#import "YCTOtherPeopleInfoModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface YCTApiOtherPeopleInfo : YCTBaseRequest

- (instancetype)initWithUserId:(NSString *)userId;

@end

@interface YCTApiOtherPeopleFollowList : YCTPagedRequest

- (instancetype)initWithUserId:(NSString *)userId;

@end

@interface YCTApiOtherPeopleFansList : YCTPagedRequest

- (instancetype)initWithUserId:(NSString *)userId;

@end

NS_ASSUME_NONNULL_END
