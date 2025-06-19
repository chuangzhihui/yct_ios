//
//  YCTSearchVideoCell.h
//  YCT
//
//  Created by hua-cloud on 2021/12/23.
//

#import <UIKit/UIKit.h>
#import "YCTVideoModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface YCTSearchVideoCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *avatarImage;
@property (weak, nonatomic) IBOutlet UIImageView *coverImage;
@property (weak, nonatomic) IBOutlet UILabel *playCount;
@property (weak, nonatomic) IBOutlet UILabel *timeCount;
@property (assign, nonatomic) BOOL isHot;
+ (CGSize)cellSize;
- (void)prepareForShowHotWithModel:(YCTVideoModel *)model;
- (void)prepareForShowWithModel:(YCTVideoModel *)model;
@end

NS_ASSUME_NONNULL_END
