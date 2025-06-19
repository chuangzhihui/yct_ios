//
//  YCTSearchResultHeaderView.h
//  YCT
//
//  Created by hua-cloud on 2021/12/23.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YCTSearchResultHeaderView : UICollectionReusableView
@property (nonatomic, strong) UILabel * headerTitle;
@property (nonatomic, strong) UIImageView * hotImage;
@property (nonatomic, assign) BOOL isHot;
@end

NS_ASSUME_NONNULL_END
