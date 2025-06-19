//
//  YCTCateViewController.h
//  YCT
//
//  Created by 张大爷的 on 2022/10/10.
//

#import "YCTBaseViewController.h"
#import "YCTCatesModel.h"
#import "YCTSearchCateModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface YCTCateViewController : YCTBaseViewController
@property NSInteger typeId;
@property (nonatomic,copy) void (^onSelected)(YCTCatesModel *model);
@property(nonatomic,strong)YCTCatesModel *selectModel;
@property (nonatomic, assign) BOOL isFromHomeSearch;
@end

NS_ASSUME_NONNULL_END
