//
//  YCTMineUserVendorInfoView.m
//  YCT
//
//  Created by 木木木 on 2022/3/2.
//

#import "YCTMineUserVendorInfoView.h"

@implementation YCTMineUserVendorInfoView

- (void)awakeFromNib {
    [super awakeFromNib];
    self.titleLabel.text = YCTLocalizedTableString(@"mine.userInfo.vendorTitle", @"Mine");
    self.titleLabel.textColor = UIColor.mainTextColor;
    
    [@[self.companyNameLabel,
       self.mainProductLabel,
       self.nameLabel,
       self.phoneLabel,
       self.websiteLabel,
       self.emailLabel,
       self.socialcodeLabel,
       self.businessTimeLabel,
       self.siteLabel,
     ] enumerateObjectsUsingBlock:^(UILabel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.textColor = UIColor.mainTextColor;
        obj.font = [UIFont PingFangSCMedium:13];
        obj.text = @"";
    }];
}

@end
