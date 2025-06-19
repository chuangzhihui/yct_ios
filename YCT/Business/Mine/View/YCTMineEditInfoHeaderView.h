//
//  YCTMineEditInfoHeaderView.h
//  YCT
//
//  Created by 木木木 on 2021/12/24.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YCTMineEditInfoHeaderView : UIView

@property (strong, nonatomic) UIButton *changeAvatarButton;
@property (strong, nonatomic) UIImageView *avatarImageView;
@property (strong, nonatomic) UIButton *maleButton;
@property (strong, nonatomic) UIButton *femaleButton;

- (void)setSex:(int)sex;

@end

NS_ASSUME_NONNULL_END
