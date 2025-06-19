//
//  YCTSystemMessageCell.m
//  YCT
//
//  Created by 木木木 on 2021/12/29.
//

#import "YCTSystemMessageCell.h"
#import "UIImage+Common.h"

static UIImage *bubbleImage = nil;

@interface YCTSystemMessageCell ()

@end

@implementation YCTSystemMessageCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupSubViews];
    }
    return self;
}

- (void)setupSubViews {
    self.contentView.backgroundColor = UIColor.tableBackgroundColor;
    self.bubbleImageView = ({
        UIImageView *view = [[UIImageView alloc] init];
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            bubbleImage = [UIImage imageWithColor:UIColor.whiteColor Size:(CGSize){12, 12} CornerRadius:6];
        });
        view.image = [bubbleImage resizableImageWithCapInsets:(UIEdgeInsets){6, 6, 6, 6} resizingMode:(UIImageResizingModeStretch)];
        view;
    });
    [self.contentView addSubview:self.bubbleImageView];
    
    self.msgTitleLabel = ({
        UILabel *view = [[UILabel alloc] init];
        view.font = [UIFont PingFangSCBold:17];
        view.textColor = UIColor.blackColor;
        view;
    });
    [self.bubbleImageView addSubview:self.msgTitleLabel];
    
    self.timeLabel = ({
        UILabel *view = [[UILabel alloc] init];
        view.font = [UIFont PingFangSCMedium:12];
        view.textColor = UIColor.mainGrayTextColor;
        view;
    });
    [self.bubbleImageView addSubview:self.timeLabel];
    
    self.contentLabel = ({
        UILabel *view = [[UILabel alloc] init];
        view.numberOfLines = 0;
        view;
    });
    [self.bubbleImageView addSubview:self.contentLabel];
}

- (void)setModel:(YCTSystemMsgModel *)model {
    _model = model;
    
    self.bubbleImageView.frame = model.bubbleFrame;
    self.msgTitleLabel.frame = model.titleFrame;
    self.timeLabel.frame = model.timeFrame;
    self.contentLabel.frame = model.contentFrame;
    
    self.msgTitleLabel.text = model.title;
    self.timeLabel.text = model.timeStr;
    self.contentLabel.attributedText = model.contentString;
}

@end
