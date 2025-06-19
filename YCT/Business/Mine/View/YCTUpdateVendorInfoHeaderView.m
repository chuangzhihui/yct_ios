//
//  YCTUpdateVendorInfoHeaderView.m
//  YCT
//
//  Created by 木木木 on 2022/5/8.
//

#import "YCTUpdateVendorInfoHeaderView.h"

@interface YCTUpdateVendorInfoHeaderView ()
@end

@implementation YCTUpdateVendorInfoHeaderView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.bgImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.bgImageView.clipsToBounds = YES;
    self.bgImageView.image = [UIImage imageNamed:@"mine_mine_bg"];
    
    CGRect topContentViewBounce = (CGRect){0, 0, Iphone_Width, 70};
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:topContentViewBounce byRoundingCorners:UIRectCornerTopLeft|UIRectCornerTopRight cornerRadii:CGSizeMake(20, 20)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = topContentViewBounce;
    maskLayer.path = maskPath.CGPath;
    self.topContentView.layer.mask = maskLayer;
    self.topContentView.layer.masksToBounds = YES;
    
    self.companyNameLabel.font = [UIFont PingFangSCBold:18];
    self.companyNameLabel.textColor = UIColor.mainTextColor;

    self.followButton.layer.cornerRadius = 15;
    self.followButton.layer.masksToBounds = YES;
    self.followButton.titleLabel.font = [UIFont PingFangSCMedium:14];
    self.followButton.backgroundColor = UIColor.mainThemeColor;
    [self.followButton addTarget:self action:@selector(followClick:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.followButton setTitle:YCTLocalizedTableString(@"chat.cell.follow", @"Chat") forState:(UIControlStateNormal)];
    [self.followButton setTitleColor:UIColor.whiteColor forState:(UIControlStateNormal)];
    [self.followButton setTitle:YCTLocalizedTableString(@"chat.cell.followed", @"Chat") forState:(UIControlStateSelected)];
    [self.followButton setTitleColor:UIColor.whiteColor forState:(UIControlStateSelected)];
    
    self.infoContentView.layer.cornerRadius = 10;
    self.infoContentView.layer.masksToBounds = YES;
    
    self.productTitleLabel.font = [UIFont PingFangSCBold:16];
    self.productTitleLabel.textColor = UIColor.mainTextColor;
    self.productTitleLabel.text = YCTLocalizedTableString(@"mine.updateVendorInfo.productIntro", @"Mine");
}

- (void)followClick:(UIButton *)sender {
    
}

- (void)updateContentHeight {
    CGFloat contentViewWidth = Iphone_Width;
    NSLayoutConstraint *widthFenceConstraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:contentViewWidth];
    [self addConstraint:widthFenceConstraint];
    CGSize fittingSize = [self systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    [self removeConstraint:widthFenceConstraint];
    self.contentHeight = fittingSize.height;
}

@end
