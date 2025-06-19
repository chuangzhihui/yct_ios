//
//  YCTSearchHotCell.h
//  YCT
//
//  Created by hua-cloud on 2022/1/11.
//

#import <UIKit/UIKit.h>
#import "YCTVideoModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface YCTSearchHotCell : UICollectionViewCell
@property (nonatomic, copy) dispatch_block_t didSelectedItem;
- (void)prepareForShowWithModels:(NSArray<YCTVideoModel *> *)models;
@end

NS_ASSUME_NONNULL_END
