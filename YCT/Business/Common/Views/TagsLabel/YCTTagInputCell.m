//
//  YCTTagInputCell.m
//  HXTagsView
//
//  Created by 木木木 on 2021/12/15.
//  Copyright © 2021 IT小子. All rights reserved.
//

#import "YCTTagInputCell.h"

@interface YCTTagInputCell () {
    CGFloat _margin;
}

@property (strong, nonatomic) UIButton *operationButton;

@end

@implementation YCTTagInputCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _inputView = [[UITextField alloc] initWithFrame:self.bounds];
        _inputView.placeholder = YCTLocalizedTableString(@"post.addLabelPlaceholder", @"Post");
        _inputView.borderStyle = UITextBorderStyleNone;
        [self.contentView addSubview:_inputView];
        
        _operationButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_operationButton addTarget:self action:@selector(click:) forControlEvents:(UIControlEventTouchUpInside)];
        [_operationButton setImage:[UIImage imageNamed:@"post_detail_addTag"] forState:(UIControlStateNormal)];
        [self.contentView addSubview:_operationButton];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.inputView.frame = CGRectMake(_margin, 0, self.bounds.size.width - _margin - 16 - _margin, self.bounds.size.height);
    self.operationButton.frame = CGRectMake(self.bounds.size.width - _margin - 16, (self.bounds.size.height - 20) / 2.0, 20, 20);
}

- (void)prepareForReuse {
    [super prepareForReuse];
}

- (void)setMargin:(CGFloat)margin {
    _margin = margin;
    [self setNeedsLayout];
}

- (void)click:(UIButton *)sender {
    if (self.inputView.text.length == 0) {
        return;
    }
    [self.inputView resignFirstResponder];
    if (self.clickBlock) {
        self.clickBlock(self.inputView.text);
    }
}

@end
