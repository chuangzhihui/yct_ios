//
//  YCTConversationCell.m
//  YCT
//
//  Created by 木木木 on 2021/12/21.
//

#import "YCTConversationCell.h"
#import "TUIDefine.h"
#import "TUICommonModel.h"
#import "TUITool.h"
#import "YCTChatUIDefine.h"
#import "YCTConversationCellData.h"

@implementation YCTConversationCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [UIColor whiteColor];

        self.headImageView = [[UIImageView alloc] init];
        [self.contentView addSubview:self.headImageView];
        
        if ([TUIConfig defaultConfig].avatarType == TAvatarTypeRounded) {
            self.headImageView.layer.masksToBounds = YES;
            self.headImageView.layer.cornerRadius = YCTConversationCell_ImageSize / 2;
        } else if ([TUIConfig defaultConfig].avatarType == TAvatarTypeRadiusCorner) {
            self.headImageView.layer.masksToBounds = YES;
            self.headImageView.layer.cornerRadius = [TUIConfig defaultConfig].avatarCornerRadius;
        }

        _timeLabel = [[UILabel alloc] init];
        _timeLabel.font = [UIFont PingFangSCMedium:14];
        _timeLabel.textColor = UIColor.subTextColor;
        _timeLabel.layer.masksToBounds = YES;
        [self.contentView addSubview:_timeLabel];

        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont PingFangSCBold:16];
        _titleLabel.textColor = UIColor.mainTextColor;
        _titleLabel.layer.masksToBounds = YES;
        [self.contentView addSubview:_titleLabel];
        
        _unReadDot = [[UIView alloc] init];
        _unReadDot.backgroundColor = [UIColor redColor];
        _unReadDot.layer.cornerRadius = YCTConversationCell_Margin_Disturb_Dot / 2.0;
        _unReadDot.layer.masksToBounds = YES;
        [self.contentView addSubview:_unReadDot];
        
        _subTitleLabel = [[UILabel alloc] init];
        _subTitleLabel.layer.masksToBounds = YES;
        _subTitleLabel.font = [UIFont PingFangSCMedium:14];
        _subTitleLabel.textColor = UIColor.mainGrayTextColor;
        [self.contentView addSubview:_subTitleLabel];

        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        _selectedIcon = [[UIImageView alloc] init];
        [self.contentView addSubview:_selectedIcon];
    }
    return self;
}

- (void)fillWithYctData:(YCTConversationCellData *)convData {
    [super fillWithData:convData];
    self.convData = convData;
    
    if (convData.isOnTop) {
        self.contentView.backgroundColor = [UIColor d_colorWithColorLight:TCell_OnTop dark:TCell_OnTop_Dark];
    } else {
        self.contentView.backgroundColor = [UIColor d_colorWithColorLight:TCell_Nomal dark:TCell_Nomal_Dark];
    }
    
    self.titleLabel.text = convData.title;
    
    @weakify(self)
    [[[RACObserve(convData, timeString) takeUntil:self.rac_prepareForReuseSignal]
      distinctUntilChanged] subscribeNext:^(NSString *x) {
        @strongify(self);
        self.timeLabel.text = x;
    }];
    
    [[[RACObserve(convData, subTitleString) takeUntil:self.rac_prepareForReuseSignal]
      distinctUntilChanged] subscribeNext:^(NSString *x) {
        @strongify(self);
        self.subTitleLabel.text = x;
    }];
    
    [[[RACObserve(convData, unreadCount) takeUntil:self.rac_prepareForReuseSignal]
      distinctUntilChanged] subscribeNext:^(NSNumber *x) {
        @strongify(self);
        self.unReadDot.hidden = x.intValue == 0;
    }];
    
    self.headImageView.image = [UIImage imageNamed:convData.imageName];
}

- (void)fillWithData:(TUIConversationCellData *)convData {
    [super fillWithData:convData];
    self.convData = convData;
    
    self.timeLabel.text = [TUITool convertDateToStr:convData.time];
    self.subTitleLabel.attributedText = convData.subTitle;
    
    if (0 == convData.unreadCount) {
        self.unReadDot.hidden = YES;
    } else {
        self.unReadDot.hidden = NO;
    }

    if (convData.isOnTop) {
        self.contentView.backgroundColor = [UIColor d_colorWithColorLight:TCell_OnTop dark:TCell_OnTop_Dark];
    } else {
        self.contentView.backgroundColor = [UIColor d_colorWithColorLight:TCell_Nomal dark:TCell_Nomal_Dark];
    }

    @weakify(self);
    [[[RACObserve(convData, title) takeUntil:self.rac_prepareForReuseSignal]
      distinctUntilChanged] subscribeNext:^(NSString *x) {
        @strongify(self);
        self.titleLabel.text = x;
    }];

    [[RACObserve(convData, faceUrl) takeUntil:self.rac_prepareForReuseSignal] subscribeNext:^(NSString *x) {
        @strongify(self);
        [self.headImageView sd_setImageWithURL:[NSURL URLWithString:x]
                              placeholderImage:self.convData.avatarImage];
    }];
    
    NSString *imageName = (convData.showCheckBox && convData.selected) ? TUICoreImagePath(@"icon_select_selected") : TUICoreImagePath(@"icon_select_normal");
    self.selectedIcon.image = [UIImage imageNamed:imageName];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (self.convData.showCheckBox) {
        _selectedIcon.mm_width(20).mm_height(20);
        _selectedIcon.mm_x = 10;
        _selectedIcon.mm_centerY = self.headImageView.mm_centerY;
        _selectedIcon.hidden = NO;
    } else {
        _selectedIcon.mm_width(0).mm_height(0);
        _selectedIcon.mm_x = 0;
        _selectedIcon.mm_y = 0;
        _selectedIcon.hidden = YES;
    }
    
    CGFloat margin = self.convData.showCheckBox ? _selectedIcon.mm_maxX : 0;
    
    self.headImageView.mm_width(YCTConversationCell_ImageSize).mm_height(YCTConversationCell_ImageSize).mm_left(YCTConversationCell_Margin + 3 + margin).mm_top(YCTConversationCell_ImageTop);
    
    self.timeLabel.mm_sizeToFit().mm_top(YCTConversationCell_Margin_Text + 10).mm_right(YCTConversationCell_Margin + 3);
    
    self.titleLabel.mm_sizeToFitThan(200, 30).mm_top(YCTConversationCell_Margin_Text + 5 ).mm_left(self.headImageView.mm_maxX+YCTConversationCell_Margin);
    
    self.unReadDot.mm_width(YCTConversationCell_Margin_Disturb_Dot).mm_height(YCTConversationCell_Margin_Disturb_Dot).mm_right(22).mm_bottom(22);
    
    self.subTitleLabel.mm_sizeToFitThan(0, 25).mm_left(self.titleLabel.mm_x).mm_flexToRight(45).mm_bottom(15);
}

@end
