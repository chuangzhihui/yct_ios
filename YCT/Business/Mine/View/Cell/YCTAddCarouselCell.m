//
//  YCTAddCarouselCell.m
//  YCT
//
//  Created by 木木木 on 2021/12/25.
//

#import "YCTAddCarouselCell.h"

@implementation YCTAddCarouselCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.carouselImageView = ({
        UIImageView *view = [[UIImageView alloc] init];
        view.backgroundColor = UIColor.grayButtonBgColor;
        view.layer.cornerRadius = 5;
        view.contentMode = UIViewContentModeScaleAspectFill;
        view.clipsToBounds = YES;
        view;
    });
    [self.contentView addSubview:self.carouselImageView];
    
    self.deleteButton = ({
        UIButton *view = [UIButton buttonWithType:(UIButtonTypeSystem)];
        view.backgroundColor = [UIColor.blackColor colorWithAlphaComponent:0.3];
        view.layer.cornerRadius = 3;
        view.titleLabel.font = [UIFont PingFangSCMedium:12];
        [view setTitle:YCTLocalizedTableString(@"mine.modify.delete", @"Mine") forState:(UIControlStateNormal)];
        [view setTitleColor:UIColor.whiteColor forState:(UIControlStateNormal)];
        view;
    });
    [self.contentView addSubview:self.deleteButton];
    
    self.stickTopButton = ({
        UIButton *view = [UIButton buttonWithType:(UIButtonTypeSystem)];
        view.backgroundColor = [UIColor.blackColor colorWithAlphaComponent:0.3];
        view.layer.cornerRadius = 3;
        view.titleLabel.font = [UIFont PingFangSCMedium:12];
        [view setTitle:YCTLocalizedTableString(@"mine.modify.stick", @"Mine") forState:(UIControlStateNormal)];
        [view setTitleColor:UIColor.whiteColor forState:(UIControlStateNormal)];
        view;
    });
    [self.contentView addSubview:self.stickTopButton];
}

- (void)setFirst:(BOOL)isFirst {
    self.deleteButton.hidden = NO;
    self.stickTopButton.hidden = isFirst;
    [self.contentView layoutIfNeeded];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.carouselImageView.frame = CGRectInset(self.contentView.bounds, 15, 0);
    
    self.stickTopButton.frame = (CGRect){
        self.stickTopButton.hidden ? CGRectGetMaxX(self.carouselImageView.frame) : CGRectGetMaxX(self.carouselImageView.frame) - 10 - 50,
        CGRectGetMinY(self.carouselImageView.frame) + 10,
        50,
        24
    };
    
    self.deleteButton.frame = CGRectOffset(self.stickTopButton.frame, -60, 0);
}

@end
