//
//  YCTBaseVideoListCell.m
//  YCT
//
//  Created by 木木木 on 2021/12/15.
//

#import "YCTBaseVideoListCell.h"
#import "NSString+Common.h"

@interface YCTBaseVideoListCell ()
@property (strong, nonatomic) UILabel *signLabel;
@property (strong, nonatomic) UIImageView *videoImageView;
@property (strong, nonatomic) UIImageView *likeImageView;
@property (strong, nonatomic) UILabel *likeCountLabel;
@property (strong, nonatomic) UILabel *timeLabel;
@end

@implementation YCTBaseVideoListCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    self.videoImageView = ({
        UIImageView *view = [[UIImageView alloc] init];
        view.backgroundColor = UIColor.mainTextColor;
        view.layer.cornerRadius = 5;
        view.contentMode = UIViewContentModeScaleAspectFill;
        view.clipsToBounds = YES;
        view;
    });
    [self.contentView addSubview:self.videoImageView];
    [self.videoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    
    self.signLabel = ({
        UILabel *view = [[UILabel alloc] init];
        view.font = [UIFont PingFangSCMedium:10];
        view.textAlignment = NSTextAlignmentCenter;
        view.textColor = UIColor.whiteColor;
        view.backgroundColor = UIColorFromRGB(0xFE3565);
        view.layer.cornerRadius = 3;
        view.clipsToBounds = YES;
        view.frame = CGRectMake(6, 6, 28, 14);
        view;
    });
    [self.contentView addSubview:self.signLabel];
    
    self.likeImageView = ({
        UIImageView *view = [[UIImageView alloc] init];
        view.image = [UIImage imageNamed:@"mine_video_like"];
        view;
    });
    [self.contentView addSubview:self.likeImageView];
    [self.likeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(12);
        make.bottom.mas_equalTo(-7);
        make.left.mas_equalTo(7);
    }];
    
    self.likeCountLabel = ({
        UILabel *view = [[UILabel alloc] init];
        view.font = [UIFont PingFangSCMedium:12];
        view.textColor = UIColor.whiteColor;
        view;
    });
    [self.contentView addSubview:self.likeCountLabel];
    [self.likeCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-10);
        make.centerY.mas_equalTo(self.likeImageView.mas_centerY);
        make.left.mas_equalTo(self.likeImageView.mas_right).mas_offset(4);
    }];
    
    self.timeLabel = ({
        UILabel *view = [[UILabel alloc] init];
        view.font = [UIFont PingFangSCMedium:12];
        view.textColor = UIColor.whiteColor;
        view;
    });
    [self.contentView addSubview:self.timeLabel];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-7);
        make.left.mas_equalTo(7);
        make.right.mas_equalTo(-7);
    }];
}

- (void)updateWithModel:(YCTVideoModel *)model {
    self.model = model;
    
    if (model.isTop) {
        self.signLabel.hidden = NO;
        self.signLabel.text = YCTLocalizedTableString(@"mine.mine.top", @"Mine");
    } else {
        self.signLabel.hidden = YES;
    }
    
    [self.videoImageView loadImageGraduallyWithURL:[NSURL URLWithString:model.thumbUrl]];
    self.likeCountLabel.text = [NSString handledCountNumberIfMoreThanTenThousand:model.zanNum];
    
}

@end
