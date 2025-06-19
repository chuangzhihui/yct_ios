//
//  YCTSearchReCommendItemCell.h
//  YCT
//
//  Created by hua-cloud on 2021/12/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YCTSearchReCommendItemCell : UICollectionViewCell

@property (nonatomic, strong) UILabel * searchText;
@property (nonatomic, strong) UIView * hotTag;

+ (CGSize)sizeWithText:(NSString *)text showTag:(BOOL)showTag;
@end

NS_ASSUME_NONNULL_END
