//
//  YCTChatSettingUserCell.h
//  YCT
//
//  Created by 木木木 on 2022/1/3.
//

#import "YCTTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface YCTCharSettingUserCellData : YCTTableViewCellData
@property (nonatomic, strong) NSURL *avatarUrl;
@property (nonatomic, strong) NSString *name;
@property SEL clickSelector;
@property id clickTarget;
@end

@interface YCTChatSettingUserCell : YCTTableViewCell

@property UIImageView *avatarView;
@property UILabel *titleLabel;
@property UIButton *followButton;

- (void)fillWithData:(YCTCharSettingUserCellData *)data;

@end

NS_ASSUME_NONNULL_END
