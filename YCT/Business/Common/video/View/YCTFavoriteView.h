//
//  YCTFavoriteView.h
//  YCT
//
//  Created by hua-cloud on 2021/12/15.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YCTFavoriteView : UIView
@property (nonatomic, strong) UIImageView      *favoriteBefore;
@property (nonatomic, strong) UIImageView      *favoriteAfter;
@property (nonatomic, copy) dispatch_block_t tapCallBack;
@property (nonatomic, assign) bool selected;

- (void)resetView;
-(void)startLikeAnim:(BOOL)isLike;

@end

NS_ASSUME_NONNULL_END
