//
//  YCTConversationCell.h
//  YCT
//
//  Created by 木木木 on 2021/12/21.
//

#import "TUICore.h"
#import "TUICommonModel.h"
#import "TUIConversationCellData.h"
#import "YCTConversationCellData.h"

NS_ASSUME_NONNULL_BEGIN

@interface YCTConversationCell : TUICommonTableViewCell

@property (nonatomic, strong) UIImageView *headImageView;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UILabel *subTitleLabel;

@property (nonatomic, strong) UILabel *timeLabel;

@property (nonatomic, strong) UIView *unReadDot;

@property (atomic, strong) TUIConversationCellData *convData;

@property (nonatomic, strong) UIImageView *selectedIcon;

- (void)fillWithData:(TUIConversationCellData * _Nullable)convData;

- (void)fillWithYctData:(YCTConversationCellData * _Nullable)convData;

@end

NS_ASSUME_NONNULL_END

