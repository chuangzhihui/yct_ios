//
//  YCTPostListTagsView.m
//  YCT
//
//  Created by 木木木 on 2021/12/10.
//

#import "YCTPostListTagsView.h"

@interface YCTPostListTagsView()
@property (strong, nonatomic) YYLabel *tagsLabel;
@end

@implementation YCTPostListTagsView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubView];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    if (self = [super initWithCoder:coder]) {
        [self setupSubView];
    }
    return self;
}

- (void)setupSubView {
    self.tagsLabel = ({
        YYLabel *view = [[YYLabel alloc] init];
        view;
    });
    [self addSubview:self.tagsLabel];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.tagsLabel.frame = CGRectInset(self.bounds, 15, 0);
}

- (void)setTagTextLayout:(YYTextLayout *)tagTextLayout {
    self.tagsLabel.textLayout = tagTextLayout;
}

@end
