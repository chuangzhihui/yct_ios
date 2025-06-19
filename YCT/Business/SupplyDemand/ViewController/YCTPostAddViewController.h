//
//  YCTPostAddViewController.h
//  YCT
//
//  Created by 木木木 on 2021/12/10.
//

#import "YCTBaseViewController.h"
#import "YCTGXTag.h"
#import "YCTMyGXListModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface YCTPostAddViewController : YCTBaseViewController

- (instancetype)initWithType:(YCTPostType)type;

- (instancetype)initWithModel:(YCTMyGXListModel *)model;

@property (nonatomic, copy) void (^submitSuccessBlock)(void);

@end

NS_ASSUME_NONNULL_END
