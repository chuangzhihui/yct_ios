//
//  YCTAddFriendsViewModel.h
//  YCT
//
//  Created by 木木木 on 2022/1/2.
//

#import "YCTBasePagedViewModel.h"
#import "YCTApiSuggestFollowUserList.h"
#import "YCTApiSearchUser.h"

NS_ASSUME_NONNULL_BEGIN

@interface YCTAddFriendsViewModel : YCTBasePagedViewModel<YCTCommonUserModel *, YCTApiSearchUser *>

@property (nonatomic, copy) NSString *keywords;

@end

@interface YCTSuggestFollowViewModel : YCTBasePagedViewModel<YCTSearchUserModel *, YCTApiSuggestFollowUserList *>

@end

NS_ASSUME_NONNULL_END
