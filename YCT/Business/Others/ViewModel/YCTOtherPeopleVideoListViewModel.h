//
//  YCTOtherPeopleVideoListViewModel.h
//  YCT
//
//  Created by 木木木 on 2022/1/5.
//

#import "YCTBasePagedViewModel.h"
#import "YCTApiOthersVideoList.h"

NS_ASSUME_NONNULL_BEGIN

@interface YCTOtherPeopleVideoListViewModel : YCTBasePagedViewModel<YCTVideoModel *, YCTApiOthersVideoList *>

- (instancetype)initWithType:(YCTOthersVideoListType)type userId:(NSString *)userId;

@end

NS_ASSUME_NONNULL_END
