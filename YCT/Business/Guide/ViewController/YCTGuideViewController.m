//
//  YCTGuideViewController.m
//  YCT
//
//  Created by hua-cloud on 2021/12/10.
//

#import "YCTGuideViewController.h"
#import "AppDelegate.h"
#import "YCTLanguageManager.h"

#define k_guide_show_storage @"k_guide_show_storage"

@interface YCTGuideRadioButton : UIControl
@property (nonatomic, strong) UILabel * titleLabel;
@property (nonatomic, strong) UILabel * subTitleLabel;
@property (nonatomic, strong) UIImageView * radioIcon;
@end


@implementation YCTGuideRadioButton

- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        
        [self setupView];
        [self bindState];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self setupView];
        [self bindState];
    }
    return self;
}

- (void)setupView{
    self.layer.borderWidth = 3.f;
    self.layer.cornerRadius = 6.f;
    
    [self addSubview:self.titleLabel];
    [self addSubview:self.subTitleLabel];
    [self addSubview:self.radioIcon];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(25.f);
        make.centerY.mas_equalTo(self);
    }];
    
    [self.subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel.mas_right).offset(0.0);
        make.bottom.equalTo(self.titleLabel.mas_bottom);
    }];
    
    [self.radioIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_offset(-24);
        make.centerY.mas_equalTo(self);
        make.height.width.mas_equalTo(28);
    }];
}

- (void)bindState{
    @weakify(self);
    [RACObserve(self, selected) subscribeNext:^(id x) {
        @strongify(self);
        self.layer.borderColor = ([x boolValue] ? [UIColor mainThemeColor] : [UIColor separatorColor]).CGColor;
        self.radioIcon.image = [x boolValue] ? [UIImage imageNamed:@"guide_radio_selected"] : [UIImage imageNamed:@"guide_radio_unselected"];
    }];
}

#pragma mark - getter
- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.font = [UIFont systemFontOfSize:30.f];
        _titleLabel.textColor = [UIColor mainTextColor];
    }
    return _titleLabel;
}

- (UILabel *)subTitleLabel{
    if (!_subTitleLabel) {
        _subTitleLabel = [UILabel new];
        _subTitleLabel.font = [UIFont systemFontOfSize:18.f];
        _subTitleLabel.textColor = [UIColor mainGrayTextColor];
    }
    return _subTitleLabel;
}

- (UIImageView *)radioIcon{
    if (!_radioIcon) {
        _radioIcon = [UIImageView new];
    }
    return _radioIcon;
}

@end

@interface YCTGuideViewController ()
@property (weak, nonatomic) IBOutlet UIButton *skipButton;
@property (weak, nonatomic) IBOutlet UILabel *topTitle;
@property (weak, nonatomic) IBOutlet UILabel *subtitle;
@property (weak, nonatomic) IBOutlet YCTGuideRadioButton *cnRadio;
@property (weak, nonatomic) IBOutlet YCTGuideRadioButton *engRadio;
@property (weak, nonatomic) IBOutlet UIButton *enteButton;
@property (strong, nonatomic) UIWindow * window;
@end

@implementation YCTGuideViewController
+ (BOOL)checkNeedShow{
    NSNumber * number = [[YCTKeyValueStorage defaultStorage] objectForKey:k_guide_show_storage ofClass:[NSNumber class]];
    bool needShow = number ? [number boolValue] : YES;
    return needShow;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)setupView{

    self.cnRadio.selected = [[YCTSanboxTool getCurrentLanguage] isEqualToString:ZH];
    self.engRadio.selected = [[YCTSanboxTool getCurrentLanguage] isEqualToString:EN];
    
    self.cnRadio.titleLabel.text = @"中文";
    self.cnRadio.subTitleLabel.text = @"(Chinese)";
    
    self.engRadio.titleLabel.text = @"English";
    self.engRadio.subTitleLabel.text = @"(United States)";
    
    [self.skipButton setTitle:YCTLocalizedString(@"guide.skip") forState:UIControlStateNormal];
    [self.topTitle setText:YCTLocalizedString(@"guide.toptitle")];
    [self.subtitle setText:YCTLocalizedString(@"guide.subtitle")];
    
    self.enteButton.layer.cornerRadius = 25.f;
    [self.enteButton setTitle:@"" forState:UIControlStateNormal];
    
    if (self.delegate) {
        self.enteButton.hidden = YES;
        self.skipButton.hidden = YES;
    }
}

- (void)bindViewModel{
    
    @weakify(self);
    [[self.cnRadio rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        self.cnRadio.selected = YES;
        self.engRadio.selected = NO;
        if (self.delegate) {
            if ([self.delegate respondsToSelector:@selector(guideDidSelectLanguage:)]) {
                [self.delegate guideDidSelectLanguage:ZH];
            }
        } else {
            [YCTLanguageManager setLanguage:ZH];
        }
    }];
    
    [[self.engRadio rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        self.engRadio.selected = YES;
        self.cnRadio.selected = NO;
        if (self.delegate) {
            if ([self.delegate respondsToSelector:@selector(guideDidSelectLanguage:)]) {
                [self.delegate guideDidSelectLanguage:EN];
            }
        } else {
            [YCTLanguageManager setLanguage:EN];
        }
    }];
    
    [[self.skipButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        [self clickComletion];
    }];
    
    [[self.enteButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        [self clickComletion];
    }];
}

- (void)clickComletion{
    [[YCTKeyValueStorage defaultStorage] setObject:@(NO) forKey:k_guide_show_storage];
    AppDelegate * delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [delegate initRootVC];
    self.window = nil;
    
}

@end
