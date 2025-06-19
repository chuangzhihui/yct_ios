//
//  YCTVideoDetailViewController.m
//  YCT
//
//  Created by hua-cloud on 2022/1/9.
//

#import "YCTVideoDetailViewController.h"
#import "YCTVideoViewController.h"
#import "YCTVideoModel.h"
#import "YCTApiPublishComment.h"
#import "YCTSearchViewController.h"
#import <IQKeyboardManager.h>

@interface YCTVideoDetailMineBottomView : UIView
@property (nonatomic, strong) UILabel * playnum;
@property (nonatomic, strong) UIButton * policyButton;

@end

@implementation YCTVideoDetailMineBottomView
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setupView];
    }
    return self;
}

- (void)setupView{
    
    self.backgroundColor = UIColor.blackColor;
    
    UIStackView * stack = [[UIStackView alloc] init];
    stack.distribution = UIStackViewDistributionFill;
    stack.alignment = UIStackViewAlignmentCenter;
    stack.axis = UILayoutConstraintAxisHorizontal;
    stack.spacing = 7;
    UIImageView * playNumImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"video_playnum"]];
    [stack addArrangedSubview:playNumImage];
    [stack addArrangedSubview:self.playnum];
    
    [self addSubview:stack];
    [self addSubview:self.policyButton];
    self.policyButton.hidden = YES;
    
    [stack mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(15);
        make.centerY.equalTo(self);
    }];
    
    [self.policyButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_offset(-15);
        make.centerY.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(80, 29));
    }];
}

#pragma mark - getter
- (UILabel *)playnum{
    if (!_playnum) {
        _playnum = [UILabel new];
        _playnum.textColor = UIColor.segmentTitleColor;
        _playnum.font = [UIFont systemFontOfSize:15 weight:UIFontWeightMedium];
    }
    return _playnum;
}

- (UIButton *)policyButton{
    if (!_policyButton) {
        _policyButton = [UIButton buttonWithType:UIButtonTypeSystem];
        _policyButton.tintColor = UIColor.whiteColor;
        _policyButton.backgroundColor = UIColor.mainTextColor;
        _policyButton.layer.cornerRadius = 14.5;
        [_policyButton setTitle:YCTLocalizedTableString(@"video.permissionSetting", @"Home") forState:UIControlStateNormal];
    }
    return _policyButton;
}

@end

@interface YCTVideoDetailCommentBottomView : UIView

@property (nonatomic, strong) UITextField * commentTextField;
@property (nonatomic, strong) UIButton * emojiButton;
@end

@implementation YCTVideoDetailCommentBottomView
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setupView];
    }
    return self;
}

- (void)setupView{
    self.backgroundColor = UIColor.blackColor;
    [self addSubview:self.commentTextField];
//    [self addSubview:self.emojiButton];
    
    [self.commentTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(15);
        make.centerY.equalTo(self);
        make.right.mas_offset(-15);
        make.height.mas_equalTo(39);
    }];
    
//    [self.emojiButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.mas_offset(-9);
//        make.centerY.equalTo(self);
//        make.size.mas_equalTo(CGSizeMake(36, 36));
//    }];
}

- (void)setupKeyboardShow{
    self.backgroundColor = UIColor.whiteColor;
    self.commentTextField.backgroundColor = UIColorFromRGB(0xF8F8F8);
    self.commentTextField.textColor = UIColor.mainTextColor;
    NSMutableAttributedString * placeHolder = [[NSMutableAttributedString alloc] initWithString:YCTLocalizedTableString(@"comment.LeaveAComment", @"Home")];
    [placeHolder addAttributes:@{NSFontAttributeName:_commentTextField.font,NSForegroundColorAttributeName : UIColor.subTextColor} range:NSMakeRange(0, placeHolder.string.length)];
    self.commentTextField.attributedPlaceholder = placeHolder.copy;
    self.emojiButton.tintColor = UIColor.mainTextColor;
}

- (void)setupKeyboardHide{
    self.backgroundColor = UIColor.blackColor;
    self.commentTextField.backgroundColor = UIColor.clearColor;
    self.commentTextField.textColor = UIColor.whiteColor;
    NSMutableAttributedString * placeHolder = [[NSMutableAttributedString alloc] initWithString:YCTLocalizedTableString(@"comment.LeaveAComment", @"Home")];
    [placeHolder addAttributes:@{NSFontAttributeName:_commentTextField.font,NSForegroundColorAttributeName : UIColor.subTextColor} range:NSMakeRange(0, placeHolder.string.length)];
    self.commentTextField.attributedPlaceholder = placeHolder.copy;
    self.emojiButton.tintColor = UIColor.placeholderColor;
    
}

#pragma mark - getter
- (UITextField *)commentTextField{
    if (!_commentTextField) {
        _commentTextField = [[UITextField alloc] init];
        CGRect frame = CGRectMake(0, 0, 15, 1);//f表示你的textField的frame
        UIView *leftview = [[UIView alloc] initWithFrame:frame];
        _commentTextField.leftViewMode = UITextFieldViewModeAlways;//设置左边距显示的时机，这个表示一直显示
        _commentTextField.leftView = leftview;
        _commentTextField.textColor = UIColorFromRGB(0x2C2C2C);
        _commentTextField.borderStyle = UITextBorderStyleNone;
        _commentTextField.backgroundColor = UIColor.clearColor;
        _commentTextField.font = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
        NSMutableAttributedString * placeHolder = [[NSMutableAttributedString alloc] initWithString:YCTLocalizedTableString(@"comment.LeaveAComment", @"Home")];
        [placeHolder addAttributes:@{NSFontAttributeName:_commentTextField.font,NSForegroundColorAttributeName : UIColor.subTextColor} range:NSMakeRange(0, placeHolder.string.length)];
        _commentTextField.attributedPlaceholder = placeHolder.copy;
        _commentTextField.layer.cornerRadius = 19.5;
        _commentTextField.enablesReturnKeyAutomatically = YES;
    }
    return _commentTextField;
}

- (UIButton *)emojiButton{
    if (!_emojiButton) {
        _emojiButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [_emojiButton setImage:[UIImage imageNamed:@"comment_emoji"] forState:UIControlStateNormal];
        _emojiButton.tintColor = UIColor.placeholderColor;
    }
    return _emojiButton;
}

@end


@interface YCTVideoDetailSearchBar : UIView
@property (nonatomic, strong) UIButton * actionButton;
@property (nonatomic, strong) UIButton * backButton;
@end

@implementation YCTVideoDetailSearchBar
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setupView];
    }
    return self;
}

- (void)setupView{
    UIView * searchBG = [UIView new];
    searchBG.layer.cornerRadius = 19.5;
    searchBG.backgroundColor = [UIColor.whiteColor colorWithAlphaComponent:0.4];
    
    UIImageView * searchIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"search_white"]];
    UILabel * searchText = [UILabel new];
    searchText.font = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
    searchText.textColor = UIColor.whiteColor;
    searchText.text = YCTLocalizedString(@"placeholder.search");
    
    [self addSubview:searchBG];
    [searchBG addSubview:searchIcon];
    [searchBG addSubview:searchText];
    [searchBG addSubview:self.actionButton];
    [self addSubview:self.backButton];
    
    [searchBG mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(44);
        make.right.mas_offset(-15);
        make.height.mas_equalTo(39);
    }];
    
    [searchIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(18);
        make.centerY.mas_equalTo(searchBG);
        make.size.mas_equalTo(CGSizeMake(16, 16));
    }];
    
    [searchText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(searchIcon.mas_right).mas_offset(10);
        make.centerY.mas_equalTo(searchIcon);
    }];
    
    [self.backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(0);
        make.centerY.mas_equalTo(self);
        make.size.mas_equalTo(CGSizeMake(44, 44));
    }];
    
    [self.actionButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    
}

#pragma mark - getter
- (UIButton *)actionButton{
    if (!_actionButton) {
        _actionButton = [UIButton buttonWithType:UIButtonTypeCustom];
    }
    return _actionButton;
}

- (UIButton *)backButton{
    if (!_backButton) {
        _backButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [_backButton setTintColor:UIColor.whiteColor];
        [_backButton setImage:[UIImage imageNamed:@"navi_back"] forState:UIControlStateNormal];
    }
    return _backButton;
}

@end
@interface YCTVideoDetailViewController ()<UITextFieldDelegate>
@property (nonatomic, strong) YCTVideoViewController * videoController;
@property (nonatomic, assign) YCTVideoType type;

@property (nonatomic, strong) YCTVideoDetailMineBottomView * mineBottomView;
@property (nonatomic, strong) YCTVideoDetailCommentBottomView * commentBottomView;

@property (nonatomic, copy) NSArray * videoModels;
@property (nonatomic, strong) YCTVideoModel * currentVideoModel;
@property (nonatomic, strong) YCTVideoDetailSearchBar * searchBar;
@property (nonatomic, assign) UIStatusBarStyle statusBarStyle;

@end

@implementation YCTVideoDetailViewController

- (instancetype)initWithVideos:(NSArray<YCTVideoModel *> *)videos
                         index:(NSInteger)index
                          type:(YCTVideoType)type{
    self = [super init];
    if (self) {
        self.statusBarStyle = UIStatusBarStyleLightContent;
        self.type = type;
        self.videoModels = videos;
        self.videoController = [[YCTVideoViewController alloc] initWithVideoModels:videos index:index type:type];
    }
    return self;
}


- (BOOL)naviagtionBarHidden{
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.type == YCTVideoDetailTypeOther) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                     selector:@selector(keyboardWillShow:)
                                                         name:UIKeyboardWillShowNotification
                                                       object:nil];
        
            //增加监听，当键退出时收出消息
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                     selector:@selector(keyboardWillHide:)
                                                         name:UIKeyboardWillHideNotification
                                                       object:nil];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[IQKeyboardManager sharedManager] setEnable:NO];
    [self.videoController onWillAppear];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[IQKeyboardManager sharedManager] setEnable:YES];
    [self.videoController onWillDisappear];
    self.statusBarStyle = UIStatusBarStyleDefault;
    [self setNeedsStatusBarAppearanceUpdate];
}

- (void)setupView{
    self.view.backgroundColor = UIColor.blackColor;
    [self addChildVC:self.videoController];
    [self.videoController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, (57 + YCTSafeBottom), 0));
    }];
    
    UIView * bottomView = self.type == YCTVideoDetailTypeMine ? self.mineBottomView : self.type == YCTVideoDetailTypeOther ? self.commentBottomView : nil;
    
    [self.view addSubview:self.searchBar];
    [self.view addSubview:bottomView];
    
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_offset(0);
        make.bottom.mas_offset(- YCTSafeBottom);
        make.height.mas_equalTo(57);
    }];
    
    [self.searchBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(44);
        make.top.mas_offset(kStatusBarHeight);
        make.left.right.mas_offset(0);
    }];
}

- (void)bindViewModel{
    @weakify(self);
    [self.videoController handlerWhenIndexChange:^(NSInteger index) {
        @strongify(self);
        NSInteger currentIndex = MAX(0, index);
        self.currentVideoModel = [self.videoModels objectAtIndex:currentIndex];
    }];
    
    [[self.searchBar.actionButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        YCTSearchViewController * vc = [[YCTSearchViewController alloc] init];
        UINavigationController * nav = [[UINavigationController alloc] initWithRootViewController:vc];
        nav.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:nav animated:NO completion:nil];
    }];
    
    [[self.searchBar.backButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
    if (self.type == YCTVideoDetailTypeMine) {
//        self.mineBottomView.
    }else{
       
    }
}



#pragma mark - request
- (void)requestForPublishCommentWithContent:(NSString *)content{
    YCTApiPublishComment * api = [[YCTApiPublishComment alloc] initWithVideoId:self.currentVideoModel.id pid:@"0" content:content];
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        self.currentVideoModel.commentNum += 1;
        [[YCTHud sharedInstance] showToastHud:YCTLocalizedTableString(@"comment.success", @"Home")];
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        [[YCTHud sharedInstance] showFailedHud:[api getError]];
    }];
}

#pragma mark - keyboard
- (void)keyboardWillShow:(NSNotification *)aNotification {
    //获取键盘的高度
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    int height = keyboardRect.size.height;   //height 就是键盘的高度
    if (self.commentBottomView.commentTextField.isFirstResponder) {
        [self.commentBottomView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_offset(- height);
        }];
        [UIView animateWithDuration:0.25 animations:^{
            [self.view layoutIfNeeded];
        }];
        [self.commentBottomView setupKeyboardShow];
    }
    
}
 
//当键退出时调用
- (void)keyboardWillHide:(NSNotification *)aNotification {
    [self.commentBottomView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_offset(- [UIApplication sharedApplication].delegate.window.safeBottom);
    }];
    [UIView animateWithDuration:0.25 animations:^{
        [self.view layoutIfNeeded];
    }];
    [self.commentBottomView setupKeyboardHide];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self requestForPublishCommentWithContent:textField.text];
    [self.commentBottomView endEditing:YES];
    self.commentBottomView.commentTextField.text = @"";
    return YES;
}

#pragma mark - getter

- (YCTVideoDetailMineBottomView *)mineBottomView{
    if (!_mineBottomView) {
        _mineBottomView = [[YCTVideoDetailMineBottomView alloc]init];
    }
    return _mineBottomView;
}

- (YCTVideoDetailCommentBottomView *)commentBottomView{
    if (!_commentBottomView) {
        _commentBottomView = [[YCTVideoDetailCommentBottomView alloc] init];
        _commentBottomView.commentTextField.delegate = self;
    }
    return _commentBottomView;
}

- (YCTVideoDetailSearchBar *)searchBar{
    if (!_searchBar) {
        _searchBar = [[YCTVideoDetailSearchBar alloc] init];
    }
    return _searchBar;
}

- (void)dealloc{
   
}

#pragma mark - Override
- (UIStatusBarStyle)preferredStatusBarStyle {
    return self.statusBarStyle;
}
@end
