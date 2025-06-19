//
//  YCTSearchCateCell.m
//  YCT
//
//  Created by 张大爷的 on 2022/10/10.
//

#import "YCTSearchCateCell.h"

@implementation YCTSearchCateCell
-(instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if(self){
        [self.contentView addSubview:self.title];
        [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).offset(10);
            make.centerY.equalTo(self.contentView.mas_centerY);
        }];
    }
    return self;
}
-(UILabel *)title{
    if(!_title){
        _title=[[UILabel alloc] init];
        _title.textColor=[UIColor grayColor];
        _title.font=fontSize(14);
    }
    return _title;
}
#pragma mark — 实现自适应文字宽度的关键步骤:item的layoutAttributes
- (UICollectionViewLayoutAttributes *)preferredLayoutAttributesFittingAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes{
    UICollectionViewLayoutAttributes *attributes = [super preferredLayoutAttributesFittingAttributes:layoutAttributes];
    [self.title sizeToFit];
    CGRect rect = [self.title.text boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 30) options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesFontLeading |NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: self.title.font} context:nil];
    rect.size.width +=20;
    
    rect.size.height+=20;
    attributes.frame = rect;
    return attributes;
}
@end
