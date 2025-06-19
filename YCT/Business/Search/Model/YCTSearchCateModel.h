//
//  YCTSearchCateModel.h
//  YCT
//
//  Created by 张大爷的 on 2022/10/10.
//

#import "YCTBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface YCTSearchCateModel : YCTBaseModel
@property (nonatomic, copy) NSString *cateId;
@property (nonatomic, copy) NSString *pid;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSArray<YCTSearchCateModel *>* child;
@end

NS_ASSUME_NONNULL_END
