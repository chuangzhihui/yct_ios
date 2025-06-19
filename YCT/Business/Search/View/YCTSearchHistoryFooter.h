//
//  YCTSearchHistoryFooter.h
//  YCT
//
//  Created by hua-cloud on 2021/12/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YCTSearchHistoryFooter : UICollectionReusableView
@property (nonatomic, strong) UIButton * deleteHistoryButton;
+ (CGSize)footerSize;
@end

NS_ASSUME_NONNULL_END
