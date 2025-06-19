//
//  YCTTagCell.m
//  YCT
//
//  Created by 木木木 on 2021/12/15.
//

#import "YCTTagCell.h"

@interface YCTTagCell () {
    BOOL _canOperate;
    CGFloat _margin;
}

@property (strong, nonatomic) UIButton *operationButton;

@end

@implementation YCTTagCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _canOperate = NO;
        _titleLabel = [[UILabel alloc] initWithFrame:self.bounds];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_titleLabel];
        
        _operationButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_operationButton addTarget:self action:@selector(click:) forControlEvents:(UIControlEventTouchUpInside)];
        [_operationButton setImage:[UIImage imageNamed:@"post_detail_deleteTag"] forState:(UIControlStateNormal)];
        [self.contentView addSubview:_operationButton];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    /*
     margin - xxx - margin
     margin - xxx - 14 - 20 - (margin-8)
     
     14 + 20 + margin - 8 + margin = 2 * margin + 26
     
     button.frame:
     x: width - margin + 8 - 20
     */
    
    self.operationButton.hidden = !_canOperate;
    if (_canOperate) {
        self.titleLabel.frame = CGRectMake(0, 0, self.bounds.size.width - 26, self.bounds.size.height);
        self.operationButton.frame = CGRectMake(self.bounds.size.width - _margin - 16, (self.bounds.size.height - 20) / 2.0, 20, 20);
    } else {
        self.titleLabel.frame = self.bounds;
    }
}

- (void)prepareForReuse {
    [super prepareForReuse];
    
    self.titleLabel.text = @"";
}

- (void)setTagText:(NSString *)tagText canOperate:(BOOL)canOperate margin:(CGFloat)margin {
    self.titleLabel.text = tagText;
    _canOperate = canOperate;
    _margin = margin;
    [self setNeedsLayout];
}

- (void)click:(UIButton *)sender {
    if (self.clickBlock) {
        self.clickBlock();
    }
}

@end
