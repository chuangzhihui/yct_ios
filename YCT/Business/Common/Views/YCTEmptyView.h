//
//  YCTEmptyView.h
//  YCT
//
//  Created by 木木木 on 2022/1/1.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YCTEmptyView : UIView

@property (strong, nonatomic, readonly) UILabel *emptyIofo;
@property (strong, nonatomic, readonly) UIImageView *emptyImageView;
@property (strong, nonatomic, readonly) UIButton *emptyButton;

- (void)setEmptyImage:(UIImage *)emptyImage
            emptyInfo:(NSString *)emtyInfo;

@end

NS_ASSUME_NONNULL_END
