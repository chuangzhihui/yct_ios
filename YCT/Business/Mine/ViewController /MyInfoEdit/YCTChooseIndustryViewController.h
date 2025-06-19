//
//  YCTChooseIndustryViewController.h
//  YCT
//
//  Created by 张大爷的 on 2022/7/11.
//

#import "YCTBaseViewController.h"
#import "YCTGetGoodsTypeListViewModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface YCTChooseIndustryViewController : YCTBaseViewController
@property (nonatomic,copy) void (^onChoosed)(YCTMintGetLocationModel *data);
-(instancetype)initWithPid:(NSString *)pid onChoosed:(nullable void (^)(YCTMintGetLocationModel * data))onChoosed;
@end

NS_ASSUME_NONNULL_END
