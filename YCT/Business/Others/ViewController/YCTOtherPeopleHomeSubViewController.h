//
//  YCTOtherPeopleHomeSubViewController.h
//  YCT
//
//  Created by 木木木 on 2022/1/5.
//

#import "YCTBaseViewController.h"
#import <JXPagingView/JXPagerView.h>
#import "YCTApiOthersVideoList.h"

NS_ASSUME_NONNULL_BEGIN

@interface YCTOtherPeopleHomeSubViewController : YCTBaseViewController<JXPagerViewListViewDelegate>

- (instancetype)initWithType:(YCTOthersVideoListType)type
                      userId:(NSString *)userId
                     isBlock:(BOOL)isBlock;

@end

NS_ASSUME_NONNULL_END
