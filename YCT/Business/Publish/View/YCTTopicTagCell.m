//
//  YCTTopicTagCell.m
//  YCT
//
//  Created by hua-cloud on 2022/1/7.
//

#import "YCTTopicTagCell.h"

@implementation YCTTopicTagCell


- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
