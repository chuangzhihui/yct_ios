//
//  YCTMyFansViewModel.h
//  YCT
//
//  Created by 木木木 on 2022/1/2.
//

#import "YCTBasePagedViewModel.h"
#import "YCTApiMyFans.h"
#import "YCTCommonUserModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface YCTMyFansViewModel : YCTBasePagedViewModel<YCTCommonUserModel *, YCTApiMyFans *>

@end

NS_ASSUME_NONNULL_END
