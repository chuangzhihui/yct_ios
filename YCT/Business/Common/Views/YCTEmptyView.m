//
//  YCTEmptyView.m
//  YCT
//
//  Created by 木木木 on 2022/1/1.
//

#import "YCTEmptyView.h"

@interface YCTEmptyView ()
@property (strong, nonatomic, readwrite) UILabel *emptyIofo;
@property (strong, nonatomic, readwrite) UIImageView *emptyImageView;
@property (strong, nonatomic, readwrite) UIButton *emptyButton;
@end

@implementation YCTEmptyView

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self setupViews];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    self.backgroundColor = UIColor.clearColor;
    
    self.emptyImageView = ({
        UIImageView *view = [[UIImageView alloc] init];
        view;
    });
    [self addSubview:self.emptyImageView];
    [self.emptyImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(28);
        make.centerX.mas_equalTo(0);
    }];
    
    self.emptyIofo = ({
        UILabel *view = [[UILabel alloc] init];
        view.textColor = UIColor.mainGrayTextColor;
        view.font = [UIFont PingFangSCMedium:14];
        view.textAlignment = NSTextAlignmentCenter;
        view;
    });
    [self addSubview:self.emptyIofo];
    [self.emptyIofo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.emptyImageView.mas_bottom);
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20).priority(999);
    }];
    
    self.emptyButton = ({
        UIButton *view = [UIButton buttonWithType:(UIButtonTypeSystem)];
        view.titleLabel.font = [UIFont PingFangSCBold:16];
        view.backgroundColor = UIColor.mainThemeColor;
        view.layer.cornerRadius = 22;
        [view setTitleColor:UIColor.whiteColor forState:(UIControlStateNormal)];
        view.hidden = YES;
        view;
    });
    [self addSubview:self.emptyButton];
    [self.emptyButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.emptyIofo.mas_bottom).mas_offset(30);
        make.width.mas_equalTo(150);
        make.height.mas_equalTo(44);
        make.centerX.mas_equalTo(0);
    }];
}

- (void)setEmptyImage:(UIImage *)emptyImage
            emptyInfo:(NSString *)emtyInfo {
    self.emptyImageView.image = emptyImage;
    self.emptyIofo.text = emtyInfo;
}

@end
