//
//  YCTTableViewCell.m
//  YCT
//
//  Created by 木木木 on 2021/12/24.
//

#import "YCTTableViewCell.h"

@implementation YCTTableViewCellData
@end

@interface YCTTableViewCell ()
@property YCTTableViewCellData *textData;
@property UIView *yct_accessoryView;
@end

@implementation YCTTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseIdentifier]) {
        self.textLabel.font = [UIFont PingFangSCMedium:16];
        self.textLabel.textColor = UIColor.mainTextColor;
        
        self.detailTextLabel.font = [UIFont PingFangSCMedium:16];
        self.detailTextLabel.textColor = UIColor.mainTextColor;
        
        self.margin = 15;
        self.imageTitleSpacing = 10;
        
        self.yct_accessoryView = [UIView new];
        self.yct_accessoryView.bounds = CGRectMake(0, 0, 24, 24);
        self.yct_accessoryView.backgroundColor = UIColor.clearColor;
        
        UIImageView *arrowView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arraw_gray_12_12"]];
        arrowView.frame = CGRectMake(0, 6, 12, 12);
        [self.yct_accessoryView addSubview:arrowView];
        
        self.accessoryView = self.yct_accessoryView;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (CGSizeEqualToSize(self.imageView.frame.size, CGSizeZero)) {
        self.textLabel.mj_x = self.margin;
    } else {
        self.imageView.mj_x = self.margin;
        self.textLabel.mj_x = CGRectGetMaxX(self.imageView.frame) + self.imageTitleSpacing;
    }
}

- (void)setMargin:(CGFloat)margin {
    _margin = margin;
    [self.contentView layoutIfNeeded];
}

- (void)setImageTitleSpacing:(CGFloat)imageTitleSpacing {
    _imageTitleSpacing = imageTitleSpacing;
    [self.contentView layoutIfNeeded];
}

- (void)setMargin:(CGFloat)margin
          spacing:(CGFloat)imageTitleSpacing {
    _margin = margin;
    _imageTitleSpacing = imageTitleSpacing;
    [self.contentView layoutIfNeeded];
}

- (void)fillWithData:(YCTTableViewCellData *)textData {
    self.textData = textData;
    RAC(self.textLabel, text) = [RACObserve(textData, key) takeUntil:self.rac_prepareForReuseSignal];
    RAC(self.detailTextLabel, text) = [RACObserve(textData, value) takeUntil:self.rac_prepareForReuseSignal];
    
    if (self.textData.keyColor) {
        self.textLabel.textColor = self.textData.keyColor;
    }
    
    if (self.textData.valueColor) {
        self.detailTextLabel.textColor = self.textData.valueColor;
    }
}

@end
