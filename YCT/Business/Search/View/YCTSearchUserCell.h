//
//  YCTSearchUserCell.h
//  YCT
//
//  Created by hua-cloud on 2021/12/23.
//

#import <UIKit/UIKit.h>
#import "YCTSearchUserModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface YCTSearchUserCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *avatar;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *fans;
@property (weak, nonatomic) IBOutlet UIButton *focusButton;

+ (CGSize)cellSize;

- (void)prepareForShowWithModel:(YCTSearchUserModel *)model;
@end

NS_ASSUME_NONNULL_END
