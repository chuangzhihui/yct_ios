//
//  YCTSearchHistoryHeaderView.h
//  YCT
//
//  Created by hua-cloud on 2021/12/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YCTSearchHistoryHeaderView : UICollectionReusableView
@property (nonatomic, strong) UILabel * headerTitle;
@property (nonatomic, strong) UIButton * actionButton;
+ (CGSize)headerSize;

@end

NS_ASSUME_NONNULL_END
