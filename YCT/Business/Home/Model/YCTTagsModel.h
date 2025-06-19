//
//  YCTTagsModel.h
//  YCT
//
//  Created by hua-cloud on 2022/1/14.
//

#import "YCTBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface YCTTagsModel : YCTBaseModel
@property (nonatomic, assign) NSInteger playNum;
@property (nonatomic, copy) NSString * tagText;
@end

NS_ASSUME_NONNULL_END
