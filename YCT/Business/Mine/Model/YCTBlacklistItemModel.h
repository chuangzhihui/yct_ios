//
//  YCTBlacklistItemModel.h
//  YCT
//
//  Created by 木木木 on 2022/1/9.
//

#import "YCTBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface YCTBlacklistItemModel : YCTBaseModel
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *userTag;
@property (nonatomic, copy) NSString *avatar;
@property (nonatomic, copy) NSString *nickName;
@property (nonatomic, assign) BOOL isBlack;
@end

NS_ASSUME_NONNULL_END
