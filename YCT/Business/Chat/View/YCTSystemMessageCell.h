//
//  YCTSystemMessageCell.h
//  YCT
//
//  Created by 木木木 on 2021/12/29.
//

#import <UIKit/UIKit.h>
#import "YCTSystemMsgModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface YCTSystemMessageCell : UITableViewCell

@property UIImageView *bubbleImageView;
@property UILabel *msgTitleLabel;
@property UILabel *timeLabel;
@property UILabel *contentLabel;

@property (strong, nonatomic) YCTSystemMsgModel *model;

@end

NS_ASSUME_NONNULL_END
