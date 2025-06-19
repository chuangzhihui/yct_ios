//
//  YCTAddCarouselCell.h
//  YCT
//
//  Created by 木木木 on 2021/12/25.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YCTAddCarouselCell : UITableViewCell

@property (strong, nonatomic) UIImageView *carouselImageView;
@property (strong, nonatomic) UIButton *stickTopButton;
@property (strong, nonatomic) UIButton *deleteButton;

- (void)setFirst:(BOOL)isFirst;

@end

NS_ASSUME_NONNULL_END
