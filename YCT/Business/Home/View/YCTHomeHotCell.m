//
//  YCTHomeHotCell.m
//  YCT
//
//  Created by hua-cloud on 2021/12/12.
//

#import "YCTHomeHotCell.h"

@implementation YCTHomeHotCell

+ (UINib *)nib {
    return [UINib nibWithNibName:[[self class] cellReuseIdentifier] bundle:[NSBundle mainBundle]];
}

+ (NSString *)cellReuseIdentifier {
    return NSStringFromClass([self class]);
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = UIColor.clearColor;
    self.backgroundView.backgroundColor = UIColor.clearColor;
    self.avatarIcon.layer.cornerRadius = 15;
    self.avatarIcon.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)prepareDisplayWith:(YCTHomeHotListItemViewModel *)viewModel {
    self.leftIcon.hidden = viewModel.rankImage ? NO : YES;
    self.rankNum.hidden = !self.leftIcon.hidden;
    self.titleIcon.hidden = viewModel.titleIconImage ? NO : YES;
    self.avatarIcon.hidden = !viewModel.isCo;
    self.hotImage.hidden = self.avatarIcon.hidden;
    [self.avatarIcon sd_setImageWithURL:[NSURL URLWithString:YCTString(viewModel.avatar, @"")] placeholderImage:[UIImage imageNamed:kDefaultAvatarImageName]];
    self.leftIcon.image = viewModel.rankImage;
    self.rankNum.text = viewModel.rankNum;
    self.title.text = viewModel.title;
    self.rightTitle.text = viewModel.hotNum;
    self.titleIcon.image = viewModel.titleIconImage;
    
}

@end
