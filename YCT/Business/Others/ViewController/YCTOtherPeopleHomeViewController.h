//
//  YCTOtherPeopleHomeViewController.h
//  YCT
//
//  Created by 木木木 on 2022/1/5.
//

#import "YCTBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface YCTOtherPeopleHomeViewController : YCTBaseViewController

+ (YCTOtherPeopleHomeViewController *)otherPeopleHomeWithUserId:(NSString *)userId;

+ (YCTOtherPeopleHomeViewController *)otherPeopleHomeWithUserId:(NSString *)userId
                                         needGoMinePageIfNeeded:(BOOL)needGoMinePageIfNeeded;

+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
