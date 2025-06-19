//
//  YCTSearchView.m
//  YCT
//
//  Created by 木木木 on 2021/12/19.
//

#import "YCTSearchView.h"

@interface YCTSearchView ()

@property (strong, nonatomic, readwrite) UITextField *textField;
@property (strong, nonatomic, readwrite) UIImageView *magnifierView;

@end

@implementation YCTSearchView

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
    self.backgroundColor = UIColor.tableBackgroundColor;
    
    self.layer.cornerRadius = 20;
    self.clipsToBounds = YES;
    
    self.magnifierView = ({
        UIImageView *view = [[UIImageView alloc] init];
        view.image = [UIImage imageNamed:@"search_magnifier"];
        view;
    });
    [self addSubview:self.magnifierView];
    [self.magnifierView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(18);
        make.size.mas_equalTo(CGSizeMake(16, 16));
        make.centerY.mas_equalTo(0);
    }];
    self.magnifierView.userInteractionEnabled = YES;
    @weakify(self);
    [self.magnifierView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
        @strongify(self);
        if ([self.textField.delegate respondsToSelector:@selector(textFieldShouldReturn:)]) {
            [self.textField.delegate textFieldShouldReturn:self.textField];
        }
    }]];
    
    self.textField = ({
        UITextField *view = [[UITextField alloc] init];
        view.backgroundColor = UIColor.clearColor;
        view.clearButtonMode = UITextFieldViewModeAlways;
        view.borderStyle = UITextBorderStyleNone;
        view.attributedPlaceholder = [[NSAttributedString alloc] initWithString:YCTLocalizedString(@"placeholder.search") attributes:@{NSFontAttributeName: [UIFont PingFangSCMedium:14], NSForegroundColorAttributeName: UIColor.placeholderColor}];
        view.textColor = UIColor.mainTextColor;
        view.font = [UIFont PingFangSCMedium:14];
        view;
    });
    [self addSubview:self.textField];
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.magnifierView.mas_right).mas_offset(8);
        make.top.mas_equalTo(8);
        make.bottom.mas_equalTo(-8);
        make.right.mas_equalTo(-8);
    }];
}

@end
