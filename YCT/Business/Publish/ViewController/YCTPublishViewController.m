//
//  YCTPublistViewController.m
//  YCT
//
//  Created by hua-cloud on 2022/1/3.
//

#import "YCTPublishViewController.h"
#import "UITextView+WZB.h"
#import "YCTPublishSettingBottomView.h"
#import "YCTPublishViewModel.h"
#import "YCTUGCWrapper.h"
#import "YCTGetLocationViewController.h"
#import "YCTImagePickerViewController.h"
#import "YCTTopicTagCell.h"
#import "YCTApiGetVideoInfo.h"
#import "YCTPublishResultViewController.h"
#import "YCTGetGoodsTypeListViewController.h"
#import <TXLiteAVSDK_UGC/TXLiteAVSDK.h>
#import "GaojiLineView.h"
#import "YCTCateViewController.h"
#define k_topic_define @"#"
#define k_topic_sign @"#"
#define regex_topic @"#[\\w]+[\\W]"

@interface YCTTopicBindingParser :NSObject <YYTextParser>
@property (nonatomic, strong) NSRegularExpression *regex;
@property (nonatomic, strong) void(^topicEditingHandler)(BOOL isCompletion);
@property (nonatomic, copy) NSString * tags;

@end

@implementation YCTTopicBindingParser

- (instancetype)init {
    self = [super init];
    NSString *pattern = regex_topic;
    self.regex = [[NSRegularExpression alloc] initWithPattern:pattern options:kNilOptions error:nil];
    return self;
}

- (BOOL)parseText:(NSMutableAttributedString *)text selectedRange:(NSRangePointer)range {
    __block NSMutableArray * array = @[].mutableCopy;
    __block BOOL changed = NO;
    [text setYy_color:[UIColor blackColor]];
    [_regex enumerateMatchesInString:text.string options:NSMatchingWithoutAnchoringBounds range:text.yy_rangeOfAll usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
        if (!result) return;
        NSRange range = result.range;
        if (range.location == NSNotFound || range.length < 1) return;
        NSRange bindlingRange = NSMakeRange(range.location, range.length - 1);
        YYTextBinding *binding = [YYTextBinding bindingWithDeleteConfirm:YES];
        [text yy_setTextBinding:binding range:bindlingRange]; /// Text binding
        [text yy_setColor:UIColor.mainThemeColor range:bindlingRange];
        changed = YES;
        NSString * tag = [[text.string substringWithRange:NSMakeRange(range.location, range.length - 1)] stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:@""];
        [array addObject:tag];
    }];
    self.tags = [array componentsJoinedByString:@","];
    return changed;

}


+ (BOOL)isValidTopicWithString:(NSString *)topic{
    NSString *regex = regex_topic;
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [pred evaluateWithObject:topic];
}

@end

@interface YCTPublishViewController ()<UITableViewDelegate, UITableViewDataSource, YYTextViewDelegate,YCTGetLocationViewControllerDelegate,YCTGetGoodsTypeListViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UIView *locationContainer;
@property (weak, nonatomic) IBOutlet UIButton *confirmButton;
@property (weak, nonatomic) IBOutlet UIButton *navButton;
@property (weak, nonatomic) IBOutlet UILabel *navTitle;

@property (weak, nonatomic) IBOutlet YYTextView *contentTextView;
@property (weak, nonatomic) IBOutlet UIButton *topicButton;
@property (weak, nonatomic) IBOutlet UIView *coverContainer;
@property (weak, nonatomic) IBOutlet UIImageView *coverImageView;
@property (weak, nonatomic) IBOutlet UILabel *chooseCoverTitle;

@property (weak, nonatomic) IBOutlet UILabel *locationTitle;
@property (weak, nonatomic) IBOutlet UILabel *visibleTitle;
@property (weak, nonatomic) IBOutlet UILabel *advancedSettingTitle;
@property (weak, nonatomic) IBOutlet UILabel *draftTitle;
@property (weak, nonatomic) IBOutlet UILabel *goodsTypeTitle;

@property (weak, nonatomic) IBOutlet UIButton *publishButton;
@property (weak, nonatomic) IBOutlet UIView *draftContainer;

@property (strong, nonatomic) UIView * keyboardView;
@property (strong, nonatomic) UITableView * topicTableView;
@property (strong, nonatomic) NSRegularExpression * contentRegex;

@property(nonatomic,strong)GaojiLineView *saveView;
@property(nonatomic,strong)GaojiLineView *shareView;
@property(nonatomic,strong)GaojiLineView *hengView;
@property(nonatomic,strong)UILabel *tipText;




@property (strong, nonatomic) YCTPublishViewModel * viewModel;
@property BOOL caogao;
@end

@implementation YCTPublishViewController

+ (void)publishDraftWithVideoId:(NSInteger)videoId{
    [[YCTHud sharedInstance] showLoadingHud];
    YCTApiGetVideoInfo * api = [[YCTApiGetVideoInfo alloc] initWithVideoId:videoId];
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        [[YCTHud sharedInstance] hideHud];
        YCTPublishVideoModel * draftModel = api.responseDataModel;
        YCTPublishViewController * vc = [[YCTPublishViewController alloc] initWithDraftModel:draftModel];
        UINavigationController * nav = [[UINavigationController alloc] initWithRootViewController:vc];
        nav.modalPresentationStyle = UIModalPresentationFullScreen;
        [[UIViewController currentViewController] presentViewController:nav animated:YES completion:nil];
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        [[YCTHud sharedInstance] showFailedHud:[api getError]];
    }];
}

- (instancetype)initWithUGCKitResult:(UGCKitResult *)UGCKitResult
{
    self = [super init];
    if (self) {
        self.viewModel.ugcResult = UGCKitResult;
    }
    return self;
}

- (instancetype)initWithDraftModel:(YCTPublishVideoModel *)videoModel{
    self = [super init];
    if (self) {
        self.viewModel.draftVideModel = videoModel;
    }
    return self;
}


- (BOOL)naviagtionBarHidden{
    return YES;
}
-(UILabel *)tipText{
    if(!_tipText){
        _tipText=[[UILabel alloc] init];
        _tipText.text=@"0/200";
    }
    return _tipText;
}
- (void)viewDidLoad {
    [super viewDidLoad];
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

- (void)setupView{
    self.topicButton.layer.cornerRadius = 14.5;
    self.coverContainer.layer.cornerRadius = 6.f;
    self.coverContainer.layer.masksToBounds = YES;
    self.publishButton.layer.cornerRadius = 25.f;
    self.confirmButton.layer.cornerRadius = 15.f;
    
    [self.confirmButton setTitle:YCTLocalizedTableString(@"publish.confirm", @"Publish") forState:UIControlStateNormal];
    [self.publishButton setTitle:YCTLocalizedTableString(@"publish.publish", @"Publish") forState:UIControlStateNormal];
    [self.topicButton setTitle:YCTLocalizedTableString(@"publish.topic", @"Publish") forState:UIControlStateNormal];
    
    self.chooseCoverTitle.text = YCTLocalizedTableString(@"publish.SelectTheCover", @"Publish");
    self.goodsTypeTitle.text = YCTLocalizedTableString(@"publish.goodsType", @"Publish");
    self.navTitle.text = YCTLocalizedTableString(@"publish.publish", @"Publish");
    self.locationTitle.text = YCTLocalizedTableString(@"publish.whereAreYou", @"Publish");
    self.visibleTitle.text = YCTLocalizedTableString(@"publish.allVisible", @"Publish");
    self.advancedSettingTitle.text = YCTLocalizedTableString(@"publish.advancedSetting", @"Publish");
    self.draftTitle.text = YCTLocalizedTableString(@"publish.draft", @"Publish");
    
    self.contentTextView.placeholderFont = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
    self.contentTextView.font = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
    self.contentTextView.textColor = UIColor.darkTextColor;
    self.contentTextView.textParser = [YCTTopicBindingParser new];
    self.contentTextView.delegate = self;
    self.contentTextView.placeholderText = YCTLocalizedTableString(@"publish.publishContentPlaceHolder", @"Publish");
    
    TXVideoInfo * info = [TXVideoInfoReader getVideoInfoWithAsset:self.viewModel.ugcResult.media.videoAsset];
    self.coverImageView.image = info.coverImage;
    
    [self.view addSubview:self.keyboardView];
    
    [self.keyboardView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(244 + kStatusBarHeight);
        make.left.right.bottom.mas_offset(0);
    }];
    
    [self.view addSubview:self.topicTableView];
    [self.topicTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(244 + kStatusBarHeight);
        make.left.right.bottom.mas_offset(0);
    }];
    
    self.keyboardView.hidden = YES;
    self.topicTableView.hidden = YES;
    self.confirmButton.hidden = YES;
    
    
    if (self.viewModel.draftVideModel) {
        NSMutableAttributedString * attString = [[NSMutableAttributedString alloc] initWithString:self.viewModel.draftVideModel.title];
        [attString setYy_font:[UIFont systemFontOfSize:14 weight:UIFontWeightMedium]];
        [attString setYy_color:UIColor.darkTextColor];
        self.contentTextView.attributedText = attString.copy;
        self.contentTextView.selectedRange = NSMakeRange(attString.length, 0);
        
        [self.coverImageView sd_setImageWithURL:[NSURL URLWithString:self.viewModel.draftVideModel.thumbUrl]];
        self.draftContainer.hidden = YES;
    }
//    self.advancedSettingTitle.hidden=YES;
//    self.saveView=[[UIView alloc] init];
//    self.saveView.backgroundColor=[UIColor redColor];
//    [self.view addSubview:self.saveView];
    [self.saveView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.sizeOffset(CGSizeMake(WIDTH, 50));
        make.top.equalTo(self.draftContainer.mas_bottom);
        make.left.equalTo(self.view.mas_left);
    }];
    [self.shareView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.sizeOffset(CGSizeMake(WIDTH, 50));
        make.top.equalTo(self.saveView.mas_bottom);
        make.left.equalTo(self.view.mas_left);
    }];
    [self.hengView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.sizeOffset(CGSizeMake(WIDTH, 50));
        make.top.equalTo(self.shareView.mas_bottom);
        make.left.equalTo(self.view.mas_left);
    }];
    
    [self.view addSubview:self.tipText];
    [self.tipText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentTextView.mas_bottom).offset(-10);
        make.right.equalTo(self.contentTextView.mas_right).offset(-10);
    }];
}
-(GaojiLineView *)saveView{
    if(!_saveView){
        _saveView=[[GaojiLineView alloc] init];
        [self.view addSubview:_saveView];
        _saveView.kg.on=YES;
        _saveView.title.text=YCTLocalizedTableString(@"publish.saveLocal",@"Publish");
    }
    return _saveView;
}
-(GaojiLineView *)shareView{
    if(!_shareView){
        _shareView=[[GaojiLineView alloc] init];
        [self.view addSubview:_shareView];
        _shareView.kg.on=YES;
        _shareView.title.text=YCTLocalizedTableString(@"publish.canShare",@"Publish");
    }
    return _shareView;
}
-(GaojiLineView *)hengView{
    if(!_hengView){
        _hengView=[[GaojiLineView alloc] init];
        [self.view addSubview:_hengView];
        _hengView.title.text=YCTLocalizedTableString(@"publish.isLandscape",@"Publish");
    }
    return _hengView;
}
- (void)bindViewModel{
    @weakify(self);
    YCTTopicBindingParser * parser = self.contentTextView.textParser;
    if ([YCTUserDataManager sharedInstance].userInfoModel.userType == YCTMineUserTypeBusiness) {
        self.viewModel.locationName = [YCTUserDataManager sharedInstance].userInfoModel.address;
        self.viewModel.locationId = [YCTUserDataManager sharedInstance].userInfoModel.locationid;
    }
    RAC(self.locationTitle, text) = [RACObserve(self.viewModel, locationName) map:^id _Nullable(NSString *  _Nullable value) {
        return value && value.length ? value : YCTLocalizedTableString(@"publish.whereAreYou", @"Publish");
    }];
    
    RAC(self.goodsTypeTitle, text) = [RACObserve(self.viewModel, goodsType) map:^id _Nullable(NSString *  _Nullable value) {
        return value && value.length ? value : YCTLocalizedTableString(@"publish.goodsType", @"Publish");
    }];
    
    RAC(self.visibleTitle, text) = RACObserve(self.viewModel, visibleTitle);
    
    RAC(self.viewModel,videoCoverImage) = RACObserve(self.coverImageView, image);
    
    RAC(self.viewModel,submitTopicTags) = RACObserve(parser, tags);
    
    [RACObserve(self.viewModel, topicTags) subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        [self.topicTableView reloadData];
    }];
    
    [[self.confirmButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        [self endEditing];
    }];
    
    [[self.navButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        if (self.viewModel.draftVideModel) {
            [self dismissViewControllerAnimated:YES completion:^{
                [[YCTUGCWrapper sharedInstance] setEdtingBgmId:nil];
            }];
        }else{
            UIAlertController * aler = [UIAlertController alertControllerWithTitle:@"" message:YCTLocalizedTableString(@"publish.quit", @"Publish") preferredStyle:UIAlertControllerStyleAlert];
           
            UIAlertAction * cancel = [UIAlertAction actionWithTitle:YCTLocalizedTableString(@"publish.saveDraft", @"Publish") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                if (self.contentTextView.text.length) {
                    [self.viewModel publishWithType:YCTPublishTypeSaveDraft];
                    [self.viewModel publishWithType:YCTPublishTypeSaveDraft];
                }else{
                    [[YCTHud sharedInstance] showToastHud:YCTLocalizedTableString(@"publish.pleaseInputContent",@"Publish")];
                }
            }];
            [aler addAction:cancel];
            UIAlertAction * confirm = [UIAlertAction actionWithTitle:YCTLocalizedString(@"action.confirm") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self dismissViewControllerAnimated:YES completion:^{
                    [[YCTUGCWrapper sharedInstance] setEdtingBgmId:nil];
                }];
            }];
            [aler addAction:confirm];
            [self presentViewController:aler animated:YES completion:nil];
        }
    }];
    
    [[self.topicButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        [self checkAndSetTopic:@""];
        NSMutableAttributedString * attString = self.contentTextView.attributedText.mutableCopy;
        [attString replaceCharactersInRange:NSMakeRange(attString.length, 0) withString:@"#"];
        [attString setYy_font:[UIFont systemFontOfSize:14 weight:UIFontWeightMedium]];
        [attString setYy_color:UIColor.darkTextColor];
        self.contentTextView.attributedText = attString.copy;
        self.contentTextView.selectedRange = NSMakeRange(attString.length, 0);
        if (!self.contentTextView.isFirstResponder) {
            [self.contentTextView becomeFirstResponder];
        }
    }];
    
    [self.viewModel.publishCompletion subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        [self publishsuccess];
    }];
    
    [self.viewModel.saveDraftCompletion subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        [self publishsuccess];
    }];
    
}

- (void)endEditing{
    [self.contentTextView endEditing:YES];
    self.topicTableView.hidden = YES;
    [self checkAndSetTopic:@""];
}

- (void)keyboardWillShow:(NSNotification *)aNotification {
    //获取键盘的高度
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    int height = keyboardRect.size.height;   //height 就是键盘的高度
    self.topicTableView.contentInset = UIEdgeInsetsMake(0, 0, height, 0);
}

//当键退出时调用
- (void)keyboardWillHide:(NSNotification *)aNotification {
//    [self.bottomView mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.bottom.mas_offset(- [UIApplication sharedApplication].delegate.window.safeBottom);
//    }];
//    [UIView animateWithDuration:0.25 animations:^{
//        [self.view layoutIfNeeded];
//    }];

}
- (IBAction)goodsCategoryPressed:(UIButton *)sender {
//    YCTGetGoodsTypeListViewController *vc = [[YCTGetGoodsTypeListViewController alloc] initWithDelegate:self];
//    [self.navigationController pushViewController:vc animated:YES];
    YCTCateViewController* cateVC=[[YCTCateViewController alloc] init];
    @weakify(self);
    cateVC.onSelected = ^(YCTCatesModel * _Nonnull model) {
        @strongify(self);
        self.viewModel.goodsType = model.name;
    };
    [self.navigationController pushViewController:cateVC animated:YES];
}

#pragma mark - YCTGetGoodsTypeListViewControllerDelegate

- (void)goodsTypeDidSelectWithAll:(NSArray<YCTMintGetLocationModel *> *)locations
                     lastPrev:(YCTMintGetLocationModel *)lastPrev
                         last:(YCTMintGetLocationModel *)last {
    self.viewModel.goodsType = last.name;
}

- (IBAction)locationPressed:(UIButton *)sender {
    if([YCTUserDataManager sharedInstance].userInfoModel.userType != YCTMineUserTypeBusiness){
        YCTGetLocationViewController * vc = [[YCTGetLocationViewController alloc] initWithDelegate:self];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (IBAction)chooseCoverPressed:(UIButton *)sender {
    @weakify(self);
    YCTImagePickerViewController *vc = [[YCTImagePickerViewController alloc] initWithMaxImagesCount:1 didFinishPickingPhotos:^(NSArray<UIImage *> * _Nonnull photos) {
        @strongify(self);
        self.coverImageView.image = [photos firstObject];
    }];
    [vc configCropSize:(CGSize){Iphone_Width, Iphone_Width}];
    [self presentViewController:vc animated:YES completion:NULL];
}

- (IBAction)visibleButtonPressed:(UIButton *)sender {
    @weakify(self);
    YCTPublishSettingBottomView * visibleView = [YCTPublishSettingBottomView visibleSettingViewWithDefaultIndex:self.viewModel.visibleType selectedHandler:^(NSString * _Nonnull title, NSInteger index) {
        @strongify(self);
        self.viewModel.visibleType = index;
    }];
    [visibleView yct_show];
}

- (IBAction)settingButtonPressed:(UIButton *)sender {
    @weakify(self);
    YCTPublishSettingBottomView * advance = [YCTPublishSettingBottomView advanceSettingViewWithSave:self.viewModel.allowSave canshare:self.viewModel.allowShare landscape:self.viewModel.landscape selectedHandler:^(bool save, bool canShare, bool landscape) {
        @strongify(self);
        self.viewModel.allowSave = save;
        self.viewModel.allowShare = canShare;
        self.viewModel.landscape = landscape;
    }];
    [advance yct_show];
}

- (IBAction)publishPressed:(UIButton *)sender {
    self.viewModel.allowSave=self.saveView.kg.on;
    self.viewModel.allowShare=self.shareView.kg.on;
    self.viewModel.landscape=self.hengView.kg.on;
    if([self.viewModel.goodsType isEqualToString:@""] || self.viewModel.goodsType==NULL){
        [[YCTHud sharedInstance] showToastHud:YCTLocalizedTableString(@"publish.goodsTypeP",@"Publish")];
        return;
    }
    NSLog(@"分享:%d-保存：%d--横屏:%d",self.viewModel.allowShare?1:0,self.viewModel.allowSave?1:0,self.viewModel.draftVideModel?1:0);
//    return;
    self.caogao=NO;
    if (self.contentTextView.text.length) {
        [self.viewModel publishWithType:self.viewModel.draftVideModel ? YCTPublishTypePublishDraft : YCTPublishTypePublish];
    }else{
        [[YCTHud sharedInstance] showToastHud:YCTLocalizedTableString(@"publish.pleaseInputContent",@"Publish")];
    }
}

- (IBAction)draftButtonPressed:(UIButton *)sender {
    self.viewModel.allowSave=self.saveView.kg.on;
    self.viewModel.allowShare=self.shareView.kg.on;
    self.viewModel.landscape=self.hengView.kg.on;
    if([self.viewModel.goodsType isEqualToString:@""] || self.viewModel.goodsType==NULL){
        [[YCTHud sharedInstance] showToastHud:YCTLocalizedTableString(@"publish.goodsTypeP",@"Publish")];
        return;
    }
    self.caogao=YES;
    if (self.contentTextView.text.length) {
        [self.viewModel publishWithType:YCTPublishTypeSaveDraft];
    }else{
        [[YCTHud sharedInstance] showToastHud:YCTLocalizedTableString(@"publish.pleaseInputContent",@"Publish")];
    }
    
}

- (void)setupIsTopicEditing:(BOOL)isEditing{
    self.navTitle.hidden = isEditing;
    self.confirmButton.hidden = !isEditing;
    
}

- (void)publishsuccess{
    [[YCTUGCWrapper sharedInstance] setEdtingBgmId:nil];
    YCTPublishResultViewController * vc = [YCTPublishResultViewController new];
    vc.caogao=self.caogao;
    NSMutableArray * viewControllers = self.navigationController.viewControllers.mutableCopy;
    [viewControllers removeAllObjects];
    [viewControllers addObject:vc];
    [self.navigationController setViewControllers:viewControllers.copy animated:YES];
}

- (void)saveDraftSuccess{
    [self dismissViewControllerAnimated:YES completion:^{
        [[YCTHud sharedInstance] showSuccessHud:YCTLocalizedString(@"share.saveSuccess")];
    }];
}


#pragma mark - textViewDelegate
- (void)textViewDidChange:(YYTextView *)textView {
    self.viewModel.content = textView.attributedText.string;
}

- (void)textViewDidChangeSelection:(YYTextView *)textView{
    NSLog(@"文字改变:%@",textView.text);
    NSString *string = textView.text;
   NSInteger maxLength = 200;
    //获取高亮部分
   YYTextRange *selectedRange = [textView valueForKey:@"_markedTextRange"];
   NSRange range = [selectedRange asRange];
   NSString *realString = [string substringWithRange:NSMakeRange(0, string.length - range.length)];
   if (realString.length >= maxLength){
       textView.text = [realString substringWithRange:NSMakeRange(0, maxLength)];
       self.tipText.text=[NSString stringWithFormat:@"%ld/200",textView.text.length];
       return;
   }
    self.tipText.text=[NSString stringWithFormat:@"%ld/200",textView.text.length];
    @weakify(self);
    [self checkEditingTopicWithCompletion:^(NSRange range, NSString *editingString,bool isEditingTopic) {
        @strongify(self);
        if (isEditingTopic) {
            [self.viewModel requestForTopicTagWithText:editingString];
            [self.view bringSubviewToFront:self.topicTableView];
        }
        
        self.topicTableView.hidden = !isEditingTopic;
    }];
}


- (BOOL)textViewShouldBeginEditing:(YYTextView *)textView{
    self.keyboardView.hidden = NO;
    self.confirmButton.hidden = NO;
    self.navTitle.hidden = YES;
    self.navButton.hidden= YES;
    return YES;
}

- (BOOL)textViewShouldEndEditing:(YYTextView *)textView{
    self.keyboardView.hidden = YES;
    self.confirmButton.hidden = YES;
    self.navTitle.hidden = NO;
    self.navButton.hidden = NO;
    [self checkAndSetTopic:@""];
    return YES;
}

- (void)checkEditingTopicWithCompletion:(void(^)(NSRange range,NSString * editingString,bool isEditingTopic))completion{
    __block bool isEditingTopic = NO;
    __block NSRange resultRange = NSMakeRange(0, 0);
    __block NSString * editingString = @"";
    [self.contentRegex enumerateMatchesInString:self.contentTextView.text options:NSMatchingWithoutAnchoringBounds range:NSMakeRange(0, self.contentTextView.text.length) usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
        if (!result) return;
        NSRange range = result.range;
        if (range.location == NSNotFound || range.length < 1) return;
        
        if (range.location < self.contentTextView.selectedRange.location
            && self.contentTextView.selectedRange.location <= (range.location + range.length)) {
            isEditingTopic = YES;
            resultRange = range;
            editingString = [self.contentTextView.text substringWithRange:range];
        }
    }];
    !completion ? : completion(resultRange,editingString, isEditingTopic);
}

- (void)checkAndSetTopic:(NSString *)topic{
    NSLog(@"tag:%@",topic);
    if(topic.length<1){
        return;
    }
    @weakify(self);
    [self checkEditingTopicWithCompletion:^(NSRange range, NSString *editingString,bool isEditingTopic) {
        @strongify(self);
        if (isEditingTopic) {
            if ([[editingString substringWithRange:NSMakeRange(0, 1)] isEqualToString:k_topic_sign]) {
                NSMutableAttributedString * attString = self.contentTextView.attributedText.mutableCopy;
                NSString * replaceString = [NSString stringWithFormat:@"%@%@",topic.length ? [topic substringFromIndex:1] : editingString,@" "];
                NSString *afterString=[NSString stringWithFormat:@"%@%@",self.contentTextView.text,replaceString];
                NSLog(@"替换字符串:%@--原来:%@",replaceString,self.contentTextView.text);
                self.contentTextView.text=afterString;
//                [attString replaceCharactersInRange:range withString:replaceString];
//                if ([YCTTopicBindingParser isValidTopicWithString:replaceString]) {
//                    self.contentTextView.attributedText = attString.copy;
//                    self.contentTextView.selectedRange = NSMakeRange(range.location + replaceString.length, 0);
//                }
            }
        }
    }];
}

#pragma mark -
- (void)locationDidSelectWithAll:(NSArray<YCTMintGetLocationModel *> *)locations
                        lastPrev:(YCTMintGetLocationModel *)lastPrev
                            last:(YCTMintGetLocationModel *)last{
    self.viewModel.locationName = [NSString stringWithFormat:@"%@",last.name];
    self.viewModel.locationId = last.cid;
}

#pragma mark - UITableviewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.viewModel.topicTags.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YCTTopicTagCell * cell = [tableView dequeueReusableCellWithIdentifier:YCTTopicTagCell.cellReuseIdentifier];
    NSString * tag = self.viewModel.topicTags[indexPath.row];
    cell.tagLabel.text = tag;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString * tagString = self.viewModel.topicTags[indexPath.row];
    NSLog(@"这里");
    [self checkAndSetTopic:tagString];
}


#pragma mark -- getter

- (UIView *)keyboardView{
    if (!_keyboardView) {
        _keyboardView = [UIView new];
        _keyboardView.backgroundColor = [UIColor.blackColor colorWithAlphaComponent:0.6];
//        UITapGestureRecognizer *
    }
    return _keyboardView;
}

- (UITableView *)topicTableView{
    if (!_topicTableView) {
        _topicTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _topicTableView.delegate = self;
        _topicTableView.dataSource = self;
        _topicTableView.tableFooterView = [UIView new];
        _topicTableView.estimatedRowHeight = 52;
        _topicTableView.rowHeight = 52;
        _topicTableView.sectionHeaderHeight = CGFLOAT_MIN;
        _topicTableView.sectionFooterHeight = CGFLOAT_MIN;
        _topicTableView.estimatedSectionHeaderHeight = CGFLOAT_MIN;
        _topicTableView.estimatedSectionFooterHeight = CGFLOAT_MIN;
        _topicTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _topicTableView.backgroundColor = [UIColor whiteColor];
        [_topicTableView registerNib:YCTTopicTagCell.nib forCellReuseIdentifier:YCTTopicTagCell.cellReuseIdentifier];
    }
    return _topicTableView;
}

- (NSRegularExpression *)contentRegex{
    if (!_contentRegex) {
        _contentRegex = [[NSRegularExpression alloc] initWithPattern:@"#[\\w]*" options:kNilOptions error:nil];
    }
    return _contentRegex;
}

- (YCTPublishViewModel *)viewModel{
    if (!_viewModel) {
        _viewModel = [[YCTPublishViewModel alloc] init];
    }
    return _viewModel;
}
@end
