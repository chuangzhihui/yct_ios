//
//  YCTSearchHistoryItemCell.h
//  YCT
//
//  Created by hua-cloud on 2021/12/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YCTSearchHistoryItemCell : UICollectionViewCell

@property (nonatomic, strong) UILabel * searchText;

+ (CGSize)sizeWithText:(NSString *)text;
@end

NS_ASSUME_NONNULL_END
