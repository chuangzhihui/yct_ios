//
//  YCTSearchVideoCell.m
//  YCT
//
//  Created by hua-cloud on 2021/12/23.
//

#import "YCTSearchVideoCell.h"
#import "NSString+Common.h"

@implementation YCTSearchVideoCell

+ (CGSize)cellSize{
    CGFloat width = (Iphone_Width - 38) / 2;
    CGFloat height = width / 169 * 225;
    return CGSizeMake( width, height);
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.avatarImage.layer.cornerRadius = 10.f;
    self.avatarImage.hidden = YES;
}

- (void)prepareForShowHotWithModel:(YCTVideoModel *)model{
    self.avatarImage.hidden = NO;
    self.isHot = YES;
    [self prepareForShowWithModel:model];
}

- (void)prepareForShowWithModel:(YCTVideoModel *)model{
    [self.coverImage sd_setImageWithURL:[NSURL URLWithString:model.thumbUrl]];
    [self.avatarImage sd_setImageWithURL:[NSURL URLWithString:model.avatar]];
    self.playCount.text = self.isHot ? [NSString stringWithFormat:@"%@·%@%@",YCTString(model.nickName, @""),[NSString handledCountNumberIfMoreThanTenThousand:model.playNum.integerValue],YCTLocalizedString(@"video.playCount")] : [NSString stringWithFormat:@"%@%@",[NSString handledCountNumberIfMoreThanTenThousand:model.playNum.integerValue],YCTLocalizedString(@"video.playCount")];
    self.timeCount.text = [self formatDateWithTimeinterval:model.videoTime.intValue];
    self.contentView.layer.cornerRadius = 5;
    self.contentView.layer.masksToBounds = YES;
    self.contentView.backgroundColor = UIColor.placeholderColor;
}

- (NSString *)formatDateWithTimeinterval:(int)timenterval{
    int second = timenterval%60;//秒
    int minutes = timenterval/60;//分钟的。
    NSString *strTime = [NSString stringWithFormat:@"%02d:%02d",minutes,second];
    return strTime;
}
@end
