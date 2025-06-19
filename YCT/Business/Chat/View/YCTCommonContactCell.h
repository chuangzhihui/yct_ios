//
//  YCTCommonContactCell.h
//  YCT
//
//  Created by 木木木 on 2021/12/22.
//

#import <UIKit/UIKit.h>
#import "YCTChatFriendModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface YCTCommonContactCell : UITableViewCell

@property UIImageView *avatarView;
@property UILabel *titleLabel;
@property UILabel *subLabel;
@property UIButton *messageButton;

@property void (^clickMessageBlock)(YCTChatFriendModel *model);
@property void (^clickAvatarBlock)(YCTChatFriendModel *model);

@property (readonly) YCTChatFriendModel *contactData;

- (void)fillWithData:(YCTChatFriendModel *)contactData;

@end

NS_ASSUME_NONNULL_END
