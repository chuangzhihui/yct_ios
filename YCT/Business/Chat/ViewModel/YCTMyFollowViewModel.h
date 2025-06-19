//
//  YCTMyFollowViewModel.h
//  YCT
//
//  Created by 木木木 on 2022/1/16.
//

#import "YCTBasePagedViewModel.h"
#import "YCTApiMyFollow.h"
#import "YCTCommonUserModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface YCTMyFollowViewModel : YCTBasePagedViewModel<YCTCommonUserModel *, YCTApiMyFollow *>

@end

NS_ASSUME_NONNULL_END
