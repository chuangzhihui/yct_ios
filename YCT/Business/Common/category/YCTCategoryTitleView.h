//
//  YCTCategoryTitleView.h
//  YCT
//
//  Created by hua-cloud on 2021/12/11.
//

#import <JXCategoryView/JXCategoryView.h>


NS_ASSUME_NONNULL_BEGIN
@protocol YCTCategoryViewDelegate <NSObject>

@optional
- (UIColor *_Nonnull)selectedTitleColorWhenRefreshToIndex:(NSInteger)index;
@end

@interface YCTCategoryTitleView : JXCategoryTitleView

@property (weak, nonatomic) id<YCTCategoryViewDelegate> UIDelegate;
@end

NS_ASSUME_NONNULL_END
