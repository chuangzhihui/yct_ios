//
//  YCTAttentionCell.h
//  YCT
//
//  Created by 木木木 on 2021/12/21.
//

#import "TUIMessageCell.h"
#import "YCTAttentionCellData.h"

NS_ASSUME_NONNULL_BEGIN

static NSString * const k_even_followCell_click = @"k_even_followCell_click";

@interface YCTAttentionCell : TUIMessageCell

@property (strong, nonatomic) UILabel *attentionNameLabel;
@property (strong, nonatomic) UIImageView *avatarImageView;
@property (strong, nonatomic) UIButton *attentionButton;

@property YCTAttentionCellData *customData;

- (void)fillWithData:(YCTAttentionCellData *)data;

@end

NS_ASSUME_NONNULL_END
