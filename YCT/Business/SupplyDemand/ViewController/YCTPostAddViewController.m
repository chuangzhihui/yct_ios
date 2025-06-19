//
//  YCTPostAddViewController.m
//  YCT
//
//  Created by 木木木 on 2021/12/10.
//

#import "YCTPostAddViewController.h"
#import "YCTPostAddViewModel.h"
#import "YCTPostSelectImageView.h"
#import "YCTPostAddTagsView.h"
#import "YCTTextView.h"
#import "YCTGetLocationViewController.h"
#import "YCTGetGoodsTypeListViewController.h"
#import "YCTPostAddSuccessViewController.h"
#import "UIImage+Common.h"
#import "YCTImagePickerViewController.h"
#import "YCTLocationManager.h"
#import "YCTMultiLineTextField.h"
#import "TOCropViewController.h"
#import "YCTCateViewController.h"
#define kTagsLimitCount 6

@interface YCTPostAddViewController ()<UITextFieldDelegate, YCTPostAddTagsViewDelegate, YCTGetLocationViewControllerDelegate, YCTGetGoodsTypeListViewControllerDelegate, YCTImagePickerViewControllerDelegate, TOCropViewControllerDelegate>

@property (nonatomic, assign) YCTPostType type;
@property (nonatomic, strong) YCTMyGXListModel *model;
@property (nonatomic, strong) YCTPostAddViewModel *viewModel;

@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;
@property (nonatomic, weak) IBOutlet UIView *contentView;
@property (nonatomic, weak) IBOutlet UIStackView *stackView;

@property (nonatomic, weak) IBOutlet YCTTextView *textView;

@property (nonatomic, weak) IBOutlet YCTPostSelectImageView *selectImageView;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *selectImageHeight;

@property (nonatomic, weak) IBOutlet UILabel *addTagTitleLabel;
@property (nonatomic, weak) IBOutlet UILabel *tagCountLabel;
@property (nonatomic, weak) IBOutlet YCTPostAddTagsView *addTagsView;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *addTagsViewHeight;

@property (nonatomic, weak) IBOutlet UILabel *phoneTitleLabel;
@property (nonatomic, weak) IBOutlet UITextField *phoneTextField;

@property (nonatomic, weak) IBOutlet UILabel *productTypeTitleLabel;
@property (nonatomic, weak) IBOutlet UITextField *productTypeTextField;

@property (nonatomic, weak) IBOutlet UILabel *districtTitleLabel;
@property (nonatomic, weak) IBOutlet UITextField *districtTextField;

@property (nonatomic, weak) IBOutlet UILabel *siteTitleLabel;
@property (nonatomic, weak) IBOutlet YCTMultiLineTextField *siteTextField;
@property (nonatomic, weak) IBOutlet UIButton *siteButton;

@property (nonatomic, weak) IBOutlet UIButton *postButton;

@end

@implementation YCTPostAddViewController

- (instancetype)initWithType:(YCTPostType)type {
    self = [super init];
    if (self) {
        _type = type;
        _viewModel = [[YCTPostAddViewModel alloc] initWithType:_type];
    }
    return self;
}

- (instancetype)initWithModel:(YCTMyGXListModel *)model {
    self = [super init];
    if (self) {
        _model = model;
        _viewModel = [[YCTPostAddViewModel alloc] initWithModel:model];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (_type == YCTPostTypeDemand) {
        self.title = YCTLocalizedTableString(@"post.title.addDemand", @"Post");
    }
    else {
        self.title = YCTLocalizedTableString(@"post.title.addSupply", @"Post");
    }
    
    self.scrollView.hidden = YES;
    [self.viewModel requestTags];
    
    if (self.model) {
        [self.viewModel.imageModelUtil addImageUrls:self.model.imgs];
        self.phoneTextField.text = self.model.mobile;
        self.textView.textView.text = self.model.title;
        self.siteTextField.text = self.model.address;
        self.districtTextField.text = self.model.area;
        self.viewModel.locationId = self.model.locationId;
        self.productTypeTextField.text = self.model.goodstype;
    }
    else if ([YCTUserDataManager sharedInstance].userInfoModel.userType == YCTMineUserTypeBusiness) {
        self.viewModel.locationId = [YCTUserDataManager sharedInstance].userInfoModel.locationid;
        self.siteTextField.text = [YCTUserDataManager sharedInstance].userInfoModel.address;
        self.districtTextField.text = [YCTUserDataManager sharedInstance].userInfoModel.locationStr;
    }
    
    BOOL isBusinessUser = [YCTUserDataManager sharedInstance].userInfoModel.userType == YCTMineUserTypeBusiness;
    self.districtTextField.userInteractionEnabled = !isBusinessUser;
    self.siteTextField.userInteractionEnabled = !isBusinessUser;
    self.siteButton.hidden = isBusinessUser;
    
    [self autoLocating];
}

- (void)bindViewModel {
    @weakify(self);
    [self.viewModel.loadTagsSubject subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        self.scrollView.hidden = NO;
        if (self.model) {
            [self.addTagsView setSystemTags:[self.viewModel.tags valueForKey:@"tagText"] selectedTags:self.model.tagTexts];
        } else {
            [self.addTagsView setSystemTags:[self.viewModel.tags valueForKey:@"tagText"] selectedTags:nil];
        }
    }];
    
    [self.viewModel.loadingSubject subscribeNext:^(NSNumber * _Nullable x) {
        if (x.boolValue) {
            [[YCTHud sharedInstance] showLoadingHud];
        } else {
            [[YCTHud sharedInstance] hideHud];
        }
    }];
    
    [self.viewModel.loadAllDataSubject subscribeNext:^(NSNumber * _Nullable x) {
        @strongify(self);
        !self.submitSuccessBlock ?: self.submitSuccessBlock();
        YCTPostAddSuccessViewController *vc = [[YCTPostAddSuccessViewController alloc] init];
        NSMutableArray *viewControllers = self.navigationController.viewControllers.mutableCopy;
        [viewControllers removeObject:self];
        [viewControllers addObject:vc];
        [self.navigationController setViewControllers:viewControllers.copy animated:YES];
    }];
    
    [self.viewModel.netWorkErrorSubject subscribeNext:^(NSString * _Nullable x) {
        if (YCT_IS_STRING(x)) {
            [[YCTHud sharedInstance] showDetailToastHud:x];
        } else {
            [[YCTHud sharedInstance] hideHud];
        }
    }];
    
    RAC(self.viewModel, mobile) = RACObserve(self.phoneTextField, text);
    
    RAC(self.viewModel, title) = RACObserve(self.textView.textView, text);
    
    RAC(self.viewModel, address) = RACObserve(self.siteTextField, text);
    
    RAC(self.viewModel, goodstype) = RACObserve(self.productTypeTextField, text);
    
    RAC(self.selectImageView, imageModels) = RACObserve(self.viewModel.imageModelUtil, imageModels);
    
    [[self.siteButton rac_signalForControlEvents:(UIControlEventTouchUpInside)] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        [self autoLocating];
    }];
}

- (void)setupView {
    @weakify(self);
    self.selectImageView.selectImageBlock = ^{
        @strongify(self);
        YCTImagePickerViewController *vc = [[YCTImagePickerViewController alloc] initWithMaxImagesCount:(self.viewModel.imageModelUtil.count == 4 ? 0 : 1) delegate:self];
        [self presentViewController:vc animated:YES completion:NULL];
    };
    self.selectImageView.deleteImageBlock = ^(NSUInteger index) {
        @strongify(self);
        [self.viewModel.imageModelUtil removeAtIndex:index];
    };
    self.selectImageHeight.constant = [YCTPostSelectImageView standardHeight];
    
    self.textView.textView.placeholder = YCTLocalizedTableString(@"post.releasePlaceHolder", @"Post");
    self.addTagTitleLabel.text = YCTLocalizedTableString(@"post.addTag", @"Post");
    self.phoneTitleLabel.text = YCTLocalizedTableString(@"post.phone", @"Post");
    self.phoneTextField.placeholder = YCTLocalizedTableString(@"post.phonePlaceHolder", @"Post");
    self.productTypeTitleLabel.text = YCTLocalizedTableString(@"post.productType", @"Post");
    self.productTypeTextField.placeholder = YCTLocalizedTableString(@"post.productTypePlaceHolder", @"Post");
    self.districtTitleLabel.text = YCTLocalizedTableString(@"post.district", @"Post");
    self.districtTextField.placeholder = YCTLocalizedTableString(@"post.districtPlaceHolder", @"Post");
    self.siteTitleLabel.text = YCTLocalizedTableString(@"post.site", @"Post");
    self.siteTextField.placeholder = YCTLocalizedTableString(@"post.sitePlaceHolder", @"Post");
    self.tagCountLabel.textColor = UIColor.mainGrayTextColor;
    self.tagCountLabel.font = [UIFont PingFangSCMedium:12];
    
    self.textView.backgroundColor = UIColor.whiteColor;
    self.textView.textView.backgroundColor = UIColor.whiteColor;
    self.textView.limitLength = 200;
    self.addTagsView.limitCount = kTagsLimitCount;
    
    self.phoneTextField.textColor = UIColor.mainTextColor;
    self.phoneTextField.font = [UIFont PingFangSCMedium:16];
    self.productTypeTextField.textColor = UIColor.mainTextColor;
    self.productTypeTextField.font = [UIFont PingFangSCMedium:16];
    self.districtTextField.textColor = UIColor.mainTextColor;
    self.districtTextField.font = [UIFont PingFangSCMedium:16];
    self.siteTextField.textColor = UIColor.mainTextColor;
    self.siteTextField.font = [UIFont PingFangSCMedium:16];
    
    self.productTypeTextField.delegate = self;
    self.districtTextField.delegate = self;
    self.addTagsView.delegate = self;
    
    self.addTagTitleLabel.textColor = UIColor.mainTextColor;
    self.addTagTitleLabel.font = [UIFont PingFangSCBold:15];
    self.phoneTitleLabel.textColor = UIColor.mainTextColor;
    self.phoneTitleLabel.font = [UIFont PingFangSCBold:15];
    self.productTypeTitleLabel.textColor = UIColor.mainTextColor;
    self.productTypeTitleLabel.font = [UIFont PingFangSCBold:15];
    self.districtTitleLabel.textColor = UIColor.mainTextColor;
    self.districtTitleLabel.font = [UIFont PingFangSCBold:15];
    self.siteTitleLabel.textColor = UIColor.mainTextColor;
    self.siteTitleLabel.font = [UIFont PingFangSCBold:15];
    
    [self.postButton setMainThemeStyleWithTitle:YCTLocalizedTableString(@"post.release", @"Post")
                                       fontSize:16
                                   cornerRadius:25
                                      imageName:nil];
                       
    self.scrollView.backgroundColor = self.view.backgroundColor;
    self.contentView.backgroundColor = self.view.backgroundColor;
    self.stackView.backgroundColor = self.view.backgroundColor;
}

- (IBAction)submitPostClick:(id)sender {
    if (self.viewModel.title.length == 0) {
        [[YCTHud sharedInstance] showDetailToastHud:YCTLocalizedTableString(@"post.alert.title", @"Post")];
        return;
    }
    
//    if (self.viewModel.mobile.length == 0) {
//        [[YCTHud sharedInstance] showDetailToastHud:YCTLocalizedTableString(@"post.alert.phone", @"Post")];
//        return;
//    }
    
    if (self.viewModel.locationId.length == 0) {
        [[YCTHud sharedInstance] showDetailToastHud:YCTLocalizedTableString(@"post.alert.site", @"Post")];
        return;
    }
    
    if (self.viewModel.goodstype.length == 0) {
        [[YCTHud sharedInstance] showDetailToastHud:YCTLocalizedTableString(@"post.alert.goodstype", @"Post")];
        return;
    }
    
//    if (self.viewModel.goodsTypeId.length == 0) {
//        [[YCTHud sharedInstance] showDetailToastHud:YCTLocalizedTableString(@"post.alert.site", @"Post")];
//        return;
//    }
    
    if (self.viewModel.address.length == 0) {
        [[YCTHud sharedInstance] showDetailToastHud:YCTLocalizedTableString(@"post.alert.address", @"Post")];
        return;
    }
    
    [self.viewModel submitPost];
}

- (void)autoLocating {
    [[YCTLocationManager sharedInstance] requestLocationWithCompletion:^(YCTLocationResultModel * _Nullable model, NSError * _Nullable error) {
        if (model) {
            self.siteTextField.text = model.formattedAddress;
        } else {
            [[YCTHud sharedInstance] showDetailToastHud:error.localizedDescription];
        }
    }];
}

#pragma mark - YCTImagePickerViewControllerDelegate

- (void)imagePickerController:(YCTImagePickerViewController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets {
//    [self.viewModel.imageModelUtil addImages:photos];
    
    TOCropViewController *vc = [[TOCropViewController alloc] initWithCroppingStyle:TOCropViewCroppingStyleDefault image:photos.firstObject];
    vc.delegate = self;
    vc.aspectRatioPickerButtonHidden = YES;
    [self presentViewController:vc animated:NO completion:NULL];
}

#pragma mark - TOCropViewControllerDelegate

- (void)cropViewController:(TOCropViewController *)cropViewController didCropToImage:(UIImage *)image withRect:(CGRect)cropRect angle:(NSInteger)angle {
    if (image) {
        [self.viewModel.imageModelUtil addImages:@[image]];
    }
    [cropViewController dismissViewControllerAnimated:NO completion:NULL];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (textField == self.districtTextField) {
        YCTGetLocationViewController *vc = [[YCTGetLocationViewController alloc] initWithDelegate:self];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if (textField == self.productTypeTextField) {
//        YCTGetGoodsTypeListViewController *vc = [[YCTGetGoodsTypeListViewController alloc] initWithDelegate:self];
//        [self.navigationController pushViewController:vc animated:YES];
        YCTCateViewController *vc=[[YCTCateViewController alloc] init];
        @weakify(self);
        vc.onSelected = ^(YCTCatesModel * _Nonnull model) {
            @strongify(self);
            self.productTypeTextField.text = [NSString stringWithFormat:@"%@", model.name];
        };
        [self.navigationController pushViewController:vc animated:YES];
    }
    return NO;
}

#pragma mark - YCTGetGoodsTypeListViewControllerDelegate

- (void)goodsTypeDidSelectWithAll:(NSArray<YCTMintGetLocationModel *> *)locations
                         lastPrev:(YCTMintGetLocationModel *)lastPrev
                             last:(YCTMintGetLocationModel *)last {
    NSLog(@"选择回调:%@",last.name);
    self.productTypeTextField.text = [NSString stringWithFormat:@"%@", last.name];
}

#pragma mark - YCTGetLocationViewControllerDelegate

- (void)locationDidSelectWithAll:(NSArray<YCTMintGetLocationModel *> *)locations
                        lastPrev:(YCTMintGetLocationModel *)lastPrev
                            last:(YCTMintGetLocationModel *)last {
    if (lastPrev) {
        self.districtTextField.text = [NSString stringWithFormat:@"%@·%@", lastPrev.name, last.name];
    } else {
        self.districtTextField.text = [NSString stringWithFormat:@"%@", last.name];
    }
    self.viewModel.locationId = last.cid;
}

#pragma mark - YCTPostAddTagsViewDelegate

- (void)didSelectTags:(NSArray *)tags {
    self.tagCountLabel.text = [NSString stringWithFormat:@"%@/%@", @(tags.count), @(kTagsLimitCount)];
    self.viewModel.tagTexts = tags;
}

- (void)didTagViewUpdateHeight:(CGFloat)newHeight {
    self.addTagsViewHeight.constant = newHeight;
    [self.addTagsView setNeedsLayout];
}

@end
