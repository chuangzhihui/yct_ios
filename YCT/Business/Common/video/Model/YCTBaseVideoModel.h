//
//  YCTBaseVideoModel.h
//  YCT
//
//  Created by 张大爷的 on 2022/7/25.
//

#import "YCTBaseModel.h"
#import "YCTVideoModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface YCTBaseVideoModel : YCTBaseModel
@property (nonatomic, assign) NSInteger totalPage;
@property (nonatomic, assign) NSArray<YCTVideoModel *>* datas;
@end

NS_ASSUME_NONNULL_END
