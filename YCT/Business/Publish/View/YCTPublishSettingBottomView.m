//
//  YCTPublishSettingBottomView.m
//  YCT
//
//  Created by hua-cloud on 2022/1/4.
//

#import "YCTPublishSettingBottomView.h"
@interface YCTSettingView : UIView
@property (nonatomic, strong) UILabel * title;
@property (nonatomic, strong) UILabel * subTitle;
@property (nonatomic, strong) UIImageView * subIcon;

@property (nonatomic, strong) UISwitch * selectionSwitch;
@property (nonatomic, strong) UIButton * selectionButton;

#pragma mark - visiblebottom

-(id)initWithIcon:(BOOL)icon;
#pragma mark - settingBottom


@end

@implementation YCTSettingView

//- (instancetype)initWithFrame:(CGRect)frame
//{
//    self = [super initWithFrame:frame];
//    if (self) {
//        [self setupView];
//    }
//    return self;
//}
- (instancetype)initWithIcon:(BOOL)icon
{
    self = [super init];
    if (self) {
       if(icon)
       {
           [self setupViewWithIcon];
       }else{
           [self setupView];
       }
        
    }
    return self;
}
- (void)setupViewWithIcon{
    NSLog(@"有ICON");
    UIStackView * responderStack = [[UIStackView alloc] initWithArrangedSubviews:@[self.selectionSwitch,self.selectionButton]];
    responderStack.distribution = UIStackViewDistributionFill;
    responderStack.alignment = UIStackViewAlignmentCenter;
    responderStack.axis = UILayoutConstraintAxisHorizontal;
    
    [self addSubview:self.subIcon];
    [self addSubview:self.title];
    [self addSubview:self.subTitle];
    [self addSubview:responderStack];
    
    [self.subIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.size.sizeOffset(CGSizeMake(20, 20));
        make.left.mas_offset(25.f);
    }];
    
    [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
//        make.left.mas_offset(25.f);
        make.left.mas_equalTo(self.subIcon.mas_right).mas_offset(10.f);
    }];
    
    [self.subTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.title.mas_right);
        make.bottom.mas_equalTo(self.title.mas_bottom);
    }];
    
    [responderStack mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_offset(-24);
        make.centerY.equalTo(self);
    }];
    
    [self.selectionSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(60, 24));
    }];
    
    [self.selectionButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(22, 22));
    }];
    
    RAC(self.selectionSwitch, hidden) = [RACObserve(self.selectionButton, hidden) map:^id _Nullable(id  _Nullable value) {
        return @(!self.selectionButton.hidden);
    }];
}

- (void)setupView{
    NSLog(@"无ICON");
    UIStackView * responderStack = [[UIStackView alloc] initWithArrangedSubviews:@[self.selectionSwitch,self.selectionButton]];
    responderStack.distribution = UIStackViewDistributionFill;
    responderStack.alignment = UIStackViewAlignmentCenter;
    responderStack.axis = UILayoutConstraintAxisHorizontal;
    
    [self addSubview:self.title];
    [self addSubview:self.subTitle];
    [self addSubview:responderStack];
    
    [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.mas_offset(25.f);
    }];
    
    [self.subTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.title.mas_right);
        make.bottom.mas_equalTo(self.title.mas_bottom);
    }];
    
    [responderStack mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_offset(-24);
        make.centerY.equalTo(self);
    }];
    
    [self.selectionSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(60, 24));
    }];
    
    [self.selectionButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(22, 22));
    }];
    
    RAC(self.selectionSwitch, hidden) = [RACObserve(self.selectionButton, hidden) map:^id _Nullable(id  _Nullable value) {
        return @(!self.selectionButton.hidden);
    }];
}

#pragma mark - getter


- (UIButton *)selectionButton{
    if (!_selectionButton) {
        _selectionButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_selectionButton setImage:[UIImage imageNamed:@"publish_selected"] forState:UIControlStateSelected];
        [_selectionButton setImage:[UIImage imageNamed:@"publish_unselected"] forState:UIControlStateNormal];
    }
    return _selectionButton;
}

- (UISwitch *)selectionSwitch{
    if (!_selectionSwitch) {
        _selectionSwitch = [[UISwitch alloc] init];
        _selectionSwitch.onTintColor = UIColor.mainThemeColor; //开关状态为开的时候左侧颜色
        _selectionSwitch.tintColor = UIColor.grayButtonBgColor;  //开关状态为关的时候右侧边框颜色
        _selectionSwitch.thumbTintColor = UIColor.mainGrayTextColor;
    }
    return _selectionSwitch;
}

- (UILabel *)title{
    if (!_title) {
        _title = [UILabel new];
        _title.textColor = UIColor.mainTextColor;
        _title.font = [UIFont systemFontOfSize:15 weight:UIFontWeightBold];
    }
    return _title;
}
- (UIImageView *)subIcon{
    if (!_subIcon) {
        _subIcon = [UIImageView new];
    }
    return _subIcon;
}
- (UILabel *)subTitle{
    if (!_subTitle) {
        _subTitle = [UILabel new];
        _subTitle.textColor = UIColor.mainGrayTextColor;
        _subTitle.font = [UIFont systemFontOfSize:12.f weight:UIFontWeightMedium];
    }
    return _subTitle;
}
@end




#import "YCTPublishSettingBottomView.h"
@interface YCTPublishSettingBottomView ()
@property (nonatomic, strong) UILabel * title;
@property (nonatomic, strong) UIView * bottomBg;
@property (nonatomic, strong) UIButton * cancelButton;

#pragma mark - visiblebottom
@property (nonatomic, assign) NSInteger defaultSelectedIndex;
@property (nonatomic, copy) publishVisibleSettingSelected visibleSettingHandler;

#pragma mark - settingBottom
@property (nonatomic, assign) BOOL saveSelected;
@property (nonatomic, assign) BOOL shareSelected;
@property (nonatomic, assign) BOOL landscapeSelected;
@property (nonatomic, copy) publishAdvanceSettingSelected advanceSettinghandler;
@property NSInteger selectedIndex;
@end

@implementation YCTPublishSettingBottomView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
    }
    return self;
}

- (void)setupView{
    self.backgroundColor = UIColor.whiteColor;
    UIView * titleLine = [UIView new];
    titleLine.backgroundColor = UIColor.separatorColor;
    
    UIView * bottomLine = [UIView new];
    bottomLine.backgroundColor = UIColorFromRGB(0xF8F8F8);
    
    [self addSubview:self.bottomBg];
    [self.bottomBg addSubview:self.title];
    [self.bottomBg addSubview:titleLine];
    [self.bottomBg addSubview:bottomLine];
    [self addSubview:self.cancelButton];
    
    [titleLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(52);
        make.left.right.mas_offset(0);
        make.height.mas_equalTo(0.5);
    }];
    
    [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(5);
        make.left.right.mas_offset(0);
        make.bottom.mas_offset(-57.5);
    }];
    
    [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(18);
        make.centerX.equalTo(self.bottomBg);
    }];
    
    [self.cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_offset(0);
        make.left.right.mas_offset(0);
        make.height.mas_equalTo(57.5);
    }];
    
    [self.bottomBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_offset(0);
        make.top.left.right.mas_offset(0);
    }];
    @weakify(self);
    [[self.cancelButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
//        [self yct_closeWithCompletion:nil];
        if(self.selectedIndex>0){
            NSInteger idx=self.selectedIndex-1;
            [self performSelector:@selector(closeAndHandleWithIdx:) withObject:@(idx) afterDelay:0.1];
        }else{
            [self yct_closeWithCompletion:nil];
        }
    }];
}

#pragma mark - Privacy Setting

+ (id)settingViewWithDefaultIndex:(NSInteger)index
                            title:(NSString *)title
                           titles:(NSArray *)titles
                        subtitles:(NSArray *)subtitles
                  selectedHandler:(publishVisibleSettingSelected)handler {
    YCTPublishSettingBottomView *view = [YCTPublishSettingBottomView new];
    view.defaultSelectedIndex = index;
    view.visibleSettingHandler = handler;
    [view setupSettingViewWithTitles:titles subtitles:subtitles];
    view.title.text = title;
    return view;
}
+ (id)settingViewIconWithDefaultIndex:(NSInteger)index
                            title:(NSString *)title
                           titles:(NSArray *)titles
                            icons:(NSArray *)icons
                        subtitles:(NSArray *)subtitles
                  selectedHandler:(publishVisibleSettingSelected)handler {
    YCTPublishSettingBottomView *view = [YCTPublishSettingBottomView new];
    view.defaultSelectedIndex = index;
    view.visibleSettingHandler = handler;
    [view setupSettingViewWithTitles:titles subtitles:subtitles subIcons:icons];
    view.title.text = title;
    return view;
}

- (void)setupSettingViewWithTitles:(NSArray *)titles
                         subtitles:(NSArray *)subtitles {
    UIStackView *stack = [[UIStackView alloc] init];
    stack.distribution = UIStackViewDistributionFill;
    stack.alignment = UIStackViewAlignmentFill;
    stack.axis = UILayoutConstraintAxisVertical;
    
    [titles enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        YCTSettingView *view = [self settingSelectionViewWithTitle:obj subTitle:subtitles[idx]];
        view.selectionButton.selected = self.defaultSelectedIndex == idx;
        view.selectionButton.userInteractionEnabled = NO;
        @weakify(self);
        [view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
            @strongify(self);
            [stack.arrangedSubviews enumerateObjectsUsingBlock:^(__kindof YCTSettingView * _Nonnull obj1, NSUInteger idx, BOOL * _Nonnull stop) {
                obj1.selectionButton.selected = NO;
            }];
            view.selectionButton.selected = YES;
            [NSObject cancelPreviousPerformRequestsWithTarget:self];
            self.selectedIndex=idx+1;
//            [self performSelector:@selector(closeAndHandleWithIdx:) withObject:@(idx) afterDelay:0.5];
        }]];
        [stack addArrangedSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(55);
        }];
    }];
    
    [self.bottomBg addSubview:stack];
    
    [stack mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_offset(-66);
        make.left.right.mas_offset(0);
    }];
    
    self.bounds = (CGRect){0, 0, Iphone_Width, 66 + titles.count * 55 + 54};
}
- (void)setupSettingViewWithTitles:(NSArray *)titles
                         subtitles:(NSArray *)subtitles
                          subIcons:(NSArray *)subIcons{
    UIStackView *stack = [[UIStackView alloc] init];
    stack.distribution = UIStackViewDistributionFill;
    stack.alignment = UIStackViewAlignmentFill;
    stack.axis = UILayoutConstraintAxisVertical;
    
    [titles enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
       
        YCTSettingView *view = [self settingSelectionViewWithTitle:obj subTitle:subtitles[idx] subIcon:subIcons[idx]];
        view.selectionButton.selected = self.defaultSelectedIndex == idx;
        view.selectionButton.userInteractionEnabled = NO;
        @weakify(self);
        [view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
            @strongify(self);
            [stack.arrangedSubviews enumerateObjectsUsingBlock:^(__kindof YCTSettingView * _Nonnull obj1, NSUInteger idx, BOOL * _Nonnull stop) {
                obj1.selectionButton.selected = NO;
            }];
            view.selectionButton.selected = YES;
            [NSObject cancelPreviousPerformRequestsWithTarget:self];
            self.selectedIndex=idx+1;
//            [self performSelector:@selector(closeAndHandleWithIdx:) withObject:@(idx) afterDelay:0.5];
        }]];
        [stack addArrangedSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(55);
        }];
    }];
    
    [self.bottomBg addSubview:stack];
    
    [stack mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_offset(-66);
        make.left.right.mas_offset(0);
    }];
    
    self.bounds = (CGRect){0, 0, Iphone_Width, 66 + titles.count * 55 + 54};
}
- (void)closeAndHandleWithIdx:(NSNumber *)idx {
    [self yct_closeWithCompletion:^{
        !self.visibleSettingHandler ? : self.visibleSettingHandler(nil, idx.integerValue);
    }];
}

#pragma mark - visiblebottom
+ (id)visibleSettingViewWithDefaultIndex:(NSInteger)index selectedHandler:(publishVisibleSettingSelected)handler{
    YCTPublishSettingBottomView * view = [YCTPublishSettingBottomView new];
    [view setupVisibleBottomView];
    [view setVisibleSettingHandler:handler];
    view.title.text = YCTLocalizedTableString(@"publish.visibleTitle", @"Publish");
    return view;
}

- (void)setupVisibleBottomView{
    
    NSArray * titles = @[
        YCTLocalizedTableString(@"publish.allVisible", @"Publish"),
        YCTLocalizedTableString(@"publish.friendVisible", @"Publish"),
        YCTLocalizedTableString(@"publish.privacy", @"Publish")];
    
    NSArray * subtitles = @[
        @"",
        YCTLocalizedTableString(@"publish.sub.friendVisible", @"Publish"),
        YCTLocalizedTableString(@"publish.sub.privacy", @"Publish")];
    
    UIStackView * stack = [[UIStackView alloc] init];
    stack.distribution = UIStackViewDistributionFill;
    stack.alignment = UIStackViewAlignmentFill;
    stack.axis = UILayoutConstraintAxisVertical;
    
    [titles enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        YCTSettingView * view = [self settingSelectionViewWithTitle:obj subTitle:subtitles[idx]];
        view.selectionButton.selected = self.defaultSelectedIndex == idx;
        view.selectionButton.userInteractionEnabled = NO;
        @weakify(self);
        [view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
            @strongify(self);
            [stack.arrangedSubviews enumerateObjectsUsingBlock:^(__kindof YCTSettingView * _Nonnull obj1, NSUInteger idx, BOOL * _Nonnull stop) {
                obj1.selectionButton.selected = NO;
            }];
            view.selectionButton.selected = YES;
            [self handleToIndex:idx title:obj];
        }]];
        [stack addArrangedSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(55);
        }];
    }];
    
    [self.bottomBg addSubview:stack];
    
    [stack mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_offset(-66);
        make.left.right.mas_offset(0);
    }];
    
    self.bounds = (CGRect){0, 0, Iphone_Width, 285};
}

- (void)handleToIndex:(NSInteger)index title:(NSString *)title{
    !self.visibleSettingHandler ? : self.visibleSettingHandler(title,index);
}

#pragma mark - settingBottom
+ (id)advanceSettingViewWithSave:(BOOL)save canshare:(BOOL)canshare landscape:(BOOL)landscape selectedHandler:(publishAdvanceSettingSelected)handler{
    YCTPublishSettingBottomView * view = [YCTPublishSettingBottomView new];
    view.saveSelected = save;
    view.shareSelected = canshare;
    view.landscapeSelected = landscape;
    [view setupAdvanceBottomView];
    [view setAdvanceSettinghandler:handler];
    view.title.text = YCTLocalizedTableString(@"publish.advancedSetting", @"Publish");
    return view;
}

- (void)setupAdvanceBottomView{
    
    UIStackView * stack = [[UIStackView alloc] init];
    stack.distribution = UIStackViewDistributionFill;
    stack.alignment = UIStackViewAlignmentFill;
    stack.axis = UILayoutConstraintAxisVertical;
    
    @weakify(self);
    
    YCTSettingView * save = [self settingSwitchViewWithTitle:YCTLocalizedTableString(@"publish.saveLocal", @"Publish")];
    save.selectionSwitch.on = self.shareSelected;
    [[save.selectionSwitch rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
//        save.selectionSwitch.on = !save.selectionSwitch.on;
        self.saveSelected = save.selectionSwitch.on;
        [self handleSwitch];
    }];
    
    YCTSettingView * share = [self settingSwitchViewWithTitle:YCTLocalizedTableString(@"publish.canShare", @"Publish")];
    share.selectionSwitch.on = self.shareSelected;
    [[share.selectionSwitch rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
//        share.selectionSwitch.on = !share.selectionSwitch.on;
        self.shareSelected = share.selectionSwitch.on;
        [self handleSwitch];
    }];
    
    YCTSettingView * landscape = [self settingSwitchViewWithTitle:YCTLocalizedTableString(@"publish.isLandscape", @"Publish")];
    landscape.selectionSwitch.on = self.landscapeSelected;
    [[landscape.selectionSwitch rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
//        share.selectionSwitch.on = !share.selectionSwitch.on;
        self.landscapeSelected = landscape.selectionSwitch.on;
        [self handleSwitch];
    }];
    
    
    [stack addArrangedSubview:save];
    [stack addArrangedSubview:share];
    [stack addArrangedSubview:landscape];
    
    [save mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(55);
    }];
    
    [share mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(55);
    }];
    
    [landscape mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(55);
    }];
    
    [self.bottomBg addSubview:stack];
    [stack mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_offset(-66);
        make.left.right.mas_offset(0);
    }];
    
    self.bounds = (CGRect){0, 0, Iphone_Width, 289};
}

- (void)handleSwitch{
    !self.advanceSettinghandler ? : self.advanceSettinghandler(self.saveSelected,self.shareSelected,self.landscapeSelected);
}

#pragma mark - getter

- (YCTSettingView *)settingSwitchViewWithTitle:(NSString *)title{
    YCTSettingView * view = [self settingSelectionViewWithTitle:title subTitle:@""];
    view.selectionButton.hidden = YES;
    return view;
}

- (YCTSettingView *)settingSelectionViewWithTitle:(NSString *)title subTitle:(NSString *)subTitle{
    YCTSettingView * view = [[YCTSettingView alloc] initWithIcon:NO];
    view.title.text = title;
    view.subTitle.text = subTitle;
    return view;
}
- (YCTSettingView *)settingSelectionViewWithTitle:(NSString *)title subTitle:(NSString *)subTitle subIcon:(NSString *)subIcon{
    YCTSettingView * view = [[YCTSettingView alloc] initWithIcon:YES];
    view.title.text = title;
    view.subTitle.text = subTitle;
    view.subIcon.image=[UIImage imageNamed:subIcon];
    return view;
}
- (UIView *)bottomBg{
    if (!_bottomBg) {
        _bottomBg = [UIView new];
        _bottomBg.backgroundColor = UIColor.whiteColor;
        _bottomBg.layer.cornerRadius = 20;
    }
    return _bottomBg;
}

- (UIButton *)cancelButton{
    if (!_cancelButton) {
        _cancelButton = [UIButton buttonWithType:UIButtonTypeSystem];
        _cancelButton.titleLabel.font = [UIFont systemFontOfSize:15 weight:UIFontWeightMedium];
//        _cancelButton.tintColor = UIColor.mainGrayTextColor;
//        [_cancelButton setTitleColor:UIColor.mainGrayTextColor forState:UIControlStateNormal];
        _cancelButton.tintColor = rgba(51, 51, 51, 1);
        [_cancelButton setTitleColor:rgba(51, 51, 51, 1) forState:UIControlStateNormal];
        [_cancelButton setTitle:YCTLocalizedTableString(@"publish.queren", @"Publish") forState:UIControlStateNormal];
        [_cancelButton setBackgroundColor:UIColor.whiteColor];
    }
    return _cancelButton;
}

- (UILabel *)title{
    if (!_title) {
        _title = [UILabel new];
        _title.textColor = UIColor.mainTextColor;
        _title.font = [UIFont systemFontOfSize:15 weight:UIFontWeightBold];
    }
    return _title;
}
@end
