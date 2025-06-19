//
//  YCTInteractiveMsgCell.h
//  YCT
//
//  Created by 木木木 on 2022/1/3.
//

#import <UIKit/UIKit.h>
#import "YCTInteractionMsgModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface YCTInteractiveMsgCell : UITableViewCell

@property UIImageView *avatarImageView;
@property UIImageView *thumbImageView;
@property UILabel *nameLabel;
@property UIImageView *vipImageView;
@property UILabel *identityLabel;
@property UILabel *contentLabel;
@property UILabel *timeLabel;

@property (strong, nonatomic) YCTInteractionMsgModel *model;

@end

NS_ASSUME_NONNULL_END
