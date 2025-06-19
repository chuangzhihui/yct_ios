//
//  YCTBaseVideoListCell.h
//  YCT
//
//  Created by 木木木 on 2021/12/15.
//

#import <UIKit/UIKit.h>
#import "YCTVideoModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface YCTBaseVideoListCell : UICollectionViewCell

@property (strong, nonatomic) YCTVideoModel *model;

- (void)updateWithModel:(YCTVideoModel *)model;

@end

NS_ASSUME_NONNULL_END
