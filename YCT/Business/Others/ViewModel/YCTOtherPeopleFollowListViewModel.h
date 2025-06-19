//
//  YCTOtherPeopleFollowListViewModel.h
//  YCT
//
//  Created by 木木木 on 2022/1/12.
//

#import "YCTBasePagedViewModel.h"
#import "YCTApiOtherPeopleInfo.h"

NS_ASSUME_NONNULL_BEGIN

@interface YCTOtherPeopleFollowListViewModel : YCTBasePagedViewModel<YCTCommonUserModel *, YCTApiOtherPeopleFollowList *>

- (instancetype)initWithUserId:(NSString *)userId;

@end

NS_ASSUME_NONNULL_END
