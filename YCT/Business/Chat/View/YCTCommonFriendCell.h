//
//  YCTCommonFriendCell.h
//  YCT
//
//  Created by 木木木 on 2021/12/22.
//

#import <UIKit/UIKit.h>
#import "YCTSearchUserModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface YCTCommonFriendCell : UITableViewCell

@property UIImageView *avatarView;
@property UILabel *titleLabel;
@property UIImageView *vipImageView;
@property UILabel *subLabel;
@property UIButton *followButton;

@property (nonatomic, copy) void (^avatarClickBlock)(void);

- (void)setFollowHiddenState:(NSString *)userId;

@end

NS_ASSUME_NONNULL_END
