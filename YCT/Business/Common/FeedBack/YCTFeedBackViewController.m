//
//  YCTFeedBackViewController.m
//  YCT
//
//  Created by hua-cloud on 2022/1/19.
//

#import "YCTFeedBackViewController.h"
#import "YCTTagsView.h"
#import "YCTPostSelectImageView.h"
#import "UITextView+WZB.h"
#import "YCTApiGetFeedbackTags.h"
#import "YCTImagePickerViewController.h"
#import "YCTImageModelUtil.h"
#import "NSString+Common.h"
#import "YCTApiFeedBack.h"
#import "YCTPostAddSuccessViewController.h"
#import "UITextView+YCT_RAC.h"

@interface YCTFeedBackViewController ()<YCTTagsViewDelegate,YCTImagePickerViewControllerDelegate,UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *tagSectionTitle;
@property (weak, nonatomic) IBOutlet UIView *tagContainer;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tagsHeight;
@property (weak, nonatomic) IBOutlet UILabel *textContentSectionTitle;
@property (weak, nonatomic) IBOutlet UILabel *inputNum;
@property (weak, nonatomic) IBOutlet UITextView *textContentView;
@property (weak, nonatomic) IBOutlet UILabel *contentInputNum;
@property (weak, nonatomic) IBOutlet UIView *photoContainer;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *photoContainerHeight;
@property (weak, nonatomic) IBOutlet UIButton *commitButton;

@property (assign, nonatomic) YCTFeedbackType type;
@property (assign, nonatomic) YCTReportType reportType;

@property (strong, nonatomic) YCTTagsView * tagsView;

@property (strong, nonatomic) YCTPostSelectImageView * photoSeletedView;
@property (nonatomic, strong) YCTImageModelUtil *imageModelUtil;
@property (nonatomic, copy) NSArray * imagUrls;
@property (nonatomic, assign) NSInteger tagId;
@property (nonatomic, assign) NSString * reportId;
@property (nonatomic, copy) NSString * selectedTags;
@property (copy, nonatomic) NSArray<YCTFeedBackTagsModel *> * tags;
@end

@implementation YCTFeedBackViewController

- (instancetype)initWithReportType:(YCTReportType)type reportId:(NSString *)reportId{
    if (self = [super init]) {
        self.type = YCTFeedbackTypeInform;
        self.reportType = type;
        self.reportId = reportId;
        [self requestForTags];
    }
    return self;
}

- (instancetype)initFeedBack{
    if (self = [super init]) {
        self.type = YCTFeedbackTypeFeedBack;
        [self requestForTags];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.title = YCTLocalizedTableString(@"mine.feedback.feedback", @"Mine");
}

- (void)configBackButton{
    UIButton *barButton = [UIButton buttonWithType:UIButtonTypeSystem];
    barButton.imageEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 0);
    [barButton setImage:[UIImage imageNamed:@"navi_back"] forState:UIControlStateNormal];
    [barButton setFrame:CGRectMake(0, 0, 40, 40)];
    [barButton addTarget:self action:@selector(onBack:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backitem = [[UIBarButtonItem alloc] initWithCustomView:barButton];
    self.navigationItem.leftBarButtonItems = @[backitem];
}

- (void)setupView{
    self.commitButton.layer.cornerRadius = 25.f;
    [self.commitButton setTitle:YCTLocalizedString(@"feedBack.commit") forState:UIControlStateNormal];
    self.textContentView.wzb_placeholder = YCTLocalizedString(@"feedBack.informPlaceHolder");
    self.tagSectionTitle.text = YCTLocalizedString(@"feedBack.informTypeTitle");
    self.textContentSectionTitle.text = YCTLocalizedString(@"feedBack.informDes");
    self.textContentView.delegate = self;
    [self.tagContainer addSubview:self.tagsView];
    [self.photoContainer addSubview:self.photoSeletedView];
    
    [self.tagsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    
    [self.photoSeletedView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    
    RAC(self.photoSeletedView, imageModels) = RACObserve(self.imageModelUtil, imageModels);
    
    self.photoContainerHeight.constant = [YCTPostSelectImageView standardHeight];
}

- (void)bindViewModel{
    @weakify(self);
    self.photoSeletedView.selectImageBlock = ^{
        @strongify(self);
        YCTImagePickerViewController *vc = [[YCTImagePickerViewController alloc] initWithMaxImagesCount:4 - self.imageModelUtil.count delegate:self];
        [self presentViewController:vc animated:YES completion:NULL];
    };
    
    self.photoSeletedView.deleteImageBlock = ^(NSUInteger index) {
        @strongify(self);
        [self.imageModelUtil removeAtIndex:index];
    };
    
    [[self.commitButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        [self requestForUploadPhoto];
    }];
    
    RAC(self.commitButton,enabled) = [[RACSignal merge:@[self.textContentView.rac_textSignal,RACObserve(self.textContentView, text),RACObserve(self, selectedTags),RACObserve(self.photoSeletedView, imageModels)]] map:^id _Nullable(id  _Nullable value) {
        return @(self.textContentView.text.length && self.selectedTags.length && self.photoSeletedView.imageModels.count);
    }];
    
    [RACObserve(self.commitButton, enabled) subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        [self.commitButton setBackgroundColor:[x boolValue] ? UIColor.mainThemeColor : UIColorFromRGB(0xD9D9D9)];
    }];
    
    [self.textContentView.rac_inputTextSignal subscribeNext:^(NSString * _Nullable x) {
        @strongify(self);
        self.inputNum.text = [NSString stringWithFormat:@"%lu/200", (unsigned long)x.length];
        self.textContentView.text = [NSString handledText:x limitCharLength:200];
    }];
    
    [RACObserve(self, tags) subscribeNext:^(NSArray<YCTFeedBackTagsModel *>  * _Nullable x) {
        @strongify(self);
        NSMutableArray * tagTmp = @[].mutableCopy;
        [x enumerateObjectsUsingBlock:^(YCTFeedBackTagsModel *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [tagTmp addObject:YCTString(obj.tagText, @"")];
        }];
        self.tagsView.tags = tagTmp.copy;
        [self.tagsView reloadData];
        self.tagsHeight.constant = [YCTTagsView getHeightWithTags:self.tagsView.tags tagAttribute:self.tagsView.tagAttributeConfiguration width:Iphone_Width - 30];
        NSMutableArray * temp = @[].mutableCopy;
        [self.tagsView.selectedTags enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSInteger index = [self.tagsView.tags indexOfObject:obj];
            YCTFeedBackTagsModel * model = self.tags[index];
            [temp addObject:model.id];
        }];
        self.selectedTags = [temp componentsJoinedByString:@","];
      
    }];
}

- (void)onBack:(UIButton *)sender{
    if (self.presentingViewController) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

#pragma mark - request
- (void)requestForReport{
    YCTApiReport * api = [[YCTApiReport alloc] initWithType:self.reportType typeIds:YCTString(self.selectedTags, @"") title:self.textContentView.text imgs:YCTString([self.imagUrls componentsJoinedByString:@","], @"") told:self.reportId];
    @weakify(self);
    [self.view showLoadingHud];
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        @strongify(self);
        [self.view hideHud];
        YCTPostAddSuccessViewController * vc = [[YCTPostAddSuccessViewController alloc] init];
        vc.desc = YCTLocalizedString(@"feedBack.reusltDesc");
        NSMutableArray * viewControllers = self.navigationController.viewControllers.mutableCopy;
        [viewControllers removeObject:self];
        [viewControllers addObject:vc];
        [self.navigationController setViewControllers:viewControllers.copy animated:YES];
    } failure:^(__kindof YCTBaseRequest * _Nonnull request) {
        [self.view showFailedHud:[api getError]];
    }];
}

- (void)requestForFeedBack{
    YCTApiFeedBack * api = [[YCTApiFeedBack alloc] initWithTypeIds:YCTString(self.selectedTags, @"") content:self.textContentView.text imgs:YCTString([self.imagUrls componentsJoinedByString:@","], @"")];
    [self.view showLoadingHud];
    @weakify(self);
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        @strongify(self);
        [self.view hideHud];
        YCTPostAddSuccessViewController * vc = [[YCTPostAddSuccessViewController alloc] init];
        vc.desc = YCTLocalizedString(@"feedBack.reusltDesc");
        NSMutableArray * viewControllers = self.navigationController.viewControllers.mutableCopy;
        [viewControllers removeObject:self];
        [viewControllers addObject:vc];
        [self.navigationController setViewControllers:viewControllers.copy animated:YES];
    } failure:^(__kindof YCTBaseRequest * _Nonnull request) {
        [self.view showFailedHud:[api getError]];
    }];
}

- (void)requestForTags{
    YCTApiGetFeedbackTags * api =[ [YCTApiGetFeedbackTags alloc] initWithType:self.type == YCTFeedbackTypeInform ? YCTApiGetFeedbackTagsTypeInform : YCTApiGetFeedbackTagsTypeFeedBack];
    [self.view showLoadingHud];
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        [self.view hideHud];
        NSArray * tags = YCTArray(api.responseDataModel, @[]);
        self.tags = tags;
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        [self.view hideHud];
    }];
}

- (void)requestForUploadPhoto{
    if (self.imageModelUtil.count > 0) {
        @weakify(self);
        [self.view showLoadingHud];
        [self.imageModelUtil fetchImageUrlWithCompletion:^(NSArray * _Nullable imageUrls) {
            @strongify(self);
            [self.view hideHud];
            self.imagUrls = imageUrls.copy;
            if (self.type == YCTFeedbackTypeInform) {
                [self requestForReport];
            } else {
                [self requestForFeedBack];
            }
        }];
    }else{
        if (self.type == YCTFeedbackTypeInform) {
            [self requestForReport];
        } else {
            [self requestForFeedBack];
        }
    }
}

#pragma mark -
- (void)tagsView:(YCTTagsView *)tagsView didSelectTags:(NSArray *)tags{
    NSMutableArray * temp = @[].mutableCopy;
    [self.tagsView.selectedTags enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSInteger index = [self.tagsView.tags indexOfObject:obj];
        YCTFeedBackTagsModel * model = self.tags[index];
        [temp addObject:model.id];
    }];
    self.selectedTags = [temp componentsJoinedByString:@","];
}

#pragma mark - YCTImagePickerViewControllerDelegate

- (void)imagePickerController:(YCTImagePickerViewController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets {
    [self.imageModelUtil addImages:photos];
}

#pragma mark - getter
- (YCTTagsView *)tagsView{
    if (!_tagsView) {
        _tagsView = [[YCTTagsView alloc] init];
        _tagsView.isMultiSelect = YES;
        _tagsView.delegate = self;
        YCTTagAttributeConfiguration *configuration = _tagsView.tagAttributeConfiguration;
        configuration.scrollDirection = UICollectionViewScrollDirectionVertical;
        configuration.displayType = YCTTagDisplayTypeNormal;
        configuration.sectionInset = UIEdgeInsetsMake(0, 15, 0, 15);
        configuration.normalBackgroundColor = UIColor.tableBackgroundColor;
        configuration.selectedBackgroundColor = UIColor.mainThemeColor;
    }
    return _tagsView;
}

- (YCTPostSelectImageView *)photoSeletedView{
    if (!_photoSeletedView) {
        _photoSeletedView = [YCTPostSelectImageView new];
    }
    return _photoSeletedView;
}

- (YCTImageModelUtil *)imageModelUtil{
    if (!_imageModelUtil) {
        _imageModelUtil = [YCTImageModelUtil new];
    }
    return _imageModelUtil;
}

- (NSString *)title{
    return self.type == YCTFeedbackTypeInform ?
    YCTLocalizedString(@"feedBack.informTitle") :
    YCTLocalizedTableString(@"mine.feedback.feedback", @"Mine");
}
@end
