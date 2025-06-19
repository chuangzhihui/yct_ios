//
//  YCTHelpItemCell.m
//  YCT
//
//  Created by 木木木 on 2022/1/19.
//

#import "YCTHelpItemCell.h"

@interface YCTHelpItemCell ()

@property (nonatomic, weak) IBOutlet UILabel *qTitleLabel;
@property (nonatomic, weak) IBOutlet UILabel *aTitleLabel;

@end

@implementation YCTHelpItemCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.qLabel.font = [UIFont PingFangSCBold:16];
    self.qLabel.textColor = UIColor.mainTextColor;
    
    self.aLabel.font = [UIFont PingFangSCMedium:14];
    self.aLabel.textColor = UIColor.mainGrayTextColor;
    
    self.qTitleLabel.font = [UIFont PingFangSCMedium:14];
    self.aTitleLabel.font = [UIFont PingFangSCMedium:14];
    self.qTitleLabel.layer.cornerRadius = 3;
    self.qTitleLabel.layer.masksToBounds = YES;
    self.aTitleLabel.layer.cornerRadius = 3;
    self.aTitleLabel.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
