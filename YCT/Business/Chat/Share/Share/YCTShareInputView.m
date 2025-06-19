//
//  YCTShareInputView.m
//  YCT
//
//  Created by 木木木 on 2022/1/7.
//

#import "YCTShareInputView.h"

@interface YCTShareInputView ()
@property (nonatomic, strong, readwrite) YCTTextView *textView;
@property (nonatomic, strong, readwrite) UIButton *sendButton;
@end

@implementation YCTShareInputView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    self.textView = ({
        YCTTextView *view = [[YCTTextView alloc] init];
        view.backgroundColor = UIColor.whiteColor;
        view.textView.placeholder = YCTLocalizedString(@"share.placeholder.input");
        view;
    });
    [self addSubview:self.textView];
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(0);
    }];
    
    self.sendButton = ({
        UIButton *view = [UIButton buttonWithType:(UIButtonTypeSystem)];
        [view setMainThemeStyleWithTitle:YCTLocalizedString(@"share.send") fontSize:16 cornerRadius:22 imageName:nil];
        view;
    });
    [self addSubview:self.sendButton];
    [self.sendButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.height.mas_equalTo(44);
        make.top.mas_equalTo(self.textView.mas_bottom).mas_offset(10);
        make.bottom.mas_equalTo(-20);
    }];
}

- (NSString *)text {
    return self.textView.textView.text;
}

@end
