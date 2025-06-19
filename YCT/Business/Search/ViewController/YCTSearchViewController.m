//
//  YCTSearchViewController.m
//  YCT
//
//  Created by hua-cloud on 2021/12/20.
//

#import "YCTSearchViewController.h"
#import "YCTSearchHistoryItemCell.h"
#import "YCTSearchReCommendItemCell.h"
#import "YCTSearchHistoryHeaderView.h"
#import "YCTSearchHistoryFooter.h"
#import "YCTSearchSubViewController.h"
#import "JXCategoryTitleView+Customization.h"
#import "YCTGetLocationViewController.h"
#import "YCTRootViewController.h"
#import "YCTQRCodeScanViewController.h"
#import "YCTOtherPeopleHomeViewController.h"
#import "YCTChatUtil.h"
#import "YCTSearchCategoryView.h"
#import "YCTCateViewController.h"
#import "YCTVipView.h"
@interface YCTSearchNavView() <UITextFieldDelegate>
@end

@implementation YCTSearchNavView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
    }
    return self;
}

- (void)setupView{
    [self addSubview:self.backButton];
    [self addSubview:self.cornerView];
    [self addSubview:self.searchButton];
    
    [self.cornerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(3, 40, 4, 60));
    }];
    
    [self.backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(40, 40));
        make.left.mas_offset(0);
    }];
    
    [self.searchButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(60, 40));
        make.right.mas_offset(0);
    }];
    
}

- (void)bindView{
    @weakify(self);
//    RAC(self.searchButton, enabled) = [[RACSignal merge:@[self.searchTextField.rac_textSignal,RACObserve(self.searchTextField, text)]] map:^id(id value) {
//        @strongify(self);
//        return @(self.searchTextField.text.length);
//    }];
    
    RAC(self.scanButton, hidden) = [[RACSignal merge:@[self.searchTextField.rac_textSignal,RACObserve(self.searchTextField, text)]] map:^id(id value) {
        @strongify(self);
        return @(self.searchTextField.text.length);
    }];
    
    [[self.searchTextField rac_signalForControlEvents:UIControlEventEditingDidBegin] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        !self.textBeginEditingHandler ? : self.textBeginEditingHandler();
    }];
}

#pragma mark - textFiledDelagate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    !_returnHandler ? : _returnHandler();
    return textField.text.length;
}

#pragma mark - getter
- (UIView *)cornerView{
    if (!_cornerView) {
        _cornerView = [UIView new];
        _cornerView.layer.cornerRadius = 19.5;
        _cornerView.backgroundColor = UIColorFromRGB(0xF8F8F8);
        
        UIImageView * locationIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"home_search_location"]];
        UIStackView * locationStack = [[UIStackView alloc] initWithArrangedSubviews:@[self.locationButton, locationIcon]];
        locationStack.distribution = UIStackViewDistributionFill;
        locationStack.axis = UILayoutConstraintAxisHorizontal;
        locationStack.alignment = UIStackViewAlignmentCenter;
        locationStack.spacing = 4;
        
        UIView * line = [UIView new];
        line.backgroundColor = UIColorFromRGB(0xC1C1C1);
        
        UIStackView * mainStack = [[UIStackView alloc] initWithArrangedSubviews:@[locationStack,line,self.searchTextField,self.scanButton]];
        mainStack.distribution = UIStackViewDistributionFill;
        mainStack.axis = UILayoutConstraintAxisHorizontal;
        mainStack.alignment = UIStackViewAlignmentCenter;
        mainStack.spacing = 8;
        
        [_cornerView addSubview:mainStack];
        
        [locationIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(8, 8));
        }];
        
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(1, 12));
        }];
        
        [mainStack mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_offset(16);
            make.centerY.equalTo(_cornerView);
            make.right.mas_offset(-15);
        }];
        
        [self.scanButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(20, 20));
        }];
        
        [self.locationButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_lessThanOrEqualTo(70);
        }];

        [self.locationButton setContentHuggingPriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
        [self.searchTextField setContentHuggingPriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
    }
    return _cornerView;
}

- (UIButton *)backButton{
    if (!_backButton) {
        _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backButton setImage:[UIImage imageNamed:@"navi_back"] forState:UIControlStateNormal];
    }
    return _backButton;
}

- (UIButton *)searchButton{
    if (!_searchButton) {
        _searchButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [_searchButton setTintColor:UIColorFromRGB(0x333333)];
        [_searchButton setTitle:YCTLocalizedTableString(@"search.search", @"Home") forState:UIControlStateNormal];
        _searchButton.titleLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightBold];
    }
    return _searchButton;
}

- (UIButton *)scanButton{
    if (!_scanButton) {
        _scanButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_scanButton setImage:[UIImage imageNamed:@"home_search_scan"] forState:UIControlStateNormal];
    }
    return _scanButton;
}

- (UIButton *)locationButton{
    if (!_locationButton) {
        _locationButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_locationButton setTitleColor:UIColor.mainTextColor forState:(UIControlStateNormal)];
        [_locationButton setTitle:YCTLocalizedTableString(@"search.selectedArea", @"Home") forState:UIControlStateNormal];
        _locationButton.titleLabel.font = [UIFont systemFontOfSize:14.f weight:UIFontWeightMedium];
    }
    return _locationButton;
}

- (UITextField *)searchTextField{
    if (!_searchTextField) {
        _searchTextField = [[UITextField alloc] init];
        _searchTextField.borderStyle = UITextBorderStyleNone;
        _searchTextField.textColor = UIColor.mainTextColor;
        _searchTextField.delegate = self;
        _searchTextField.returnKeyType = UIReturnKeySearch;
        _searchTextField.clearButtonMode = UITextFieldViewModeUnlessEditing;
//        _searchTextField.enablesReturnKeyAutomatically = YES;
        _searchTextField.font = [UIFont systemFontOfSize:14.f weight:UIFontWeightMedium];
        _searchTextField.placeholder = YCTLocalizedTableString(@"search.placeHolder", @"Home");
    }
    return _searchTextField;
}

@end

@interface YCTSearchViewController ()<JXCategoryListContainerViewDelegate,JXCategoryViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,YCTGetLocationViewControllerDelegate>
@property (strong, nonatomic) JXCategoryTitleView * segmentView;
@property (strong, nonatomic) JXCategoryListContainerView *subListView;

@property (nonatomic, strong) YCTSearchNavView * topView;
@property (nonatomic, strong) UICollectionView * historyCollectionView;
@property (nonatomic, strong) YCTSearchViewModel * viewModel;
@property (nonatomic, copy) NSString * defaultKeywords;
@property (nonatomic, assign) YCTSearchResultType defaultSearchType;
@property(nonatomic,strong)YCTSearchCategoryView *cateView;//分类
@property(nonatomic,strong)YCTVipView *vipView;//vip信息
@end

@implementation YCTSearchViewController


- (instancetype)initWithKeyWord:(NSString *)keyword defaultSearchType:(YCTSearchResultType)defaultSearchType{
    if (self = [super init]) {
        self.defaultKeywords = keyword;
        self.defaultSearchType = defaultSearchType;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.isCallApi) {
        self.topView.searchTextField.text = self.name;
        [self handleToReturn];
    }
    
}

- (BOOL)naviagtionBarHidden{
    return YES;
}

- (void)setupView{
    
    [self.view addSubview:self.topView];
    [self.view addSubview:self.segmentView];
    [self.view addSubview:self.subListView];
    [self.view addSubview:self.cateView];
    [self.view addSubview:self.historyCollectionView];
    [self.view addSubview:self.vipView];
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(kStatusBarHeight);
        make.height.mas_equalTo(44);
        make.left.right.mas_equalTo(0);
    }];
    
    [self.segmentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topView.mas_bottom);
        make.left.right.mas_offset(0);
        make.height.mas_equalTo(44);
    }];
    [self.cateView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topView.mas_bottom);
        make.left.right.mas_offset(0);
        make.height.mas_equalTo(44);
    }];
    [self.historyCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.cateView.mas_bottom);
        make.left.right.mas_offset(0.f);
        make.bottom.mas_equalTo(self.vipView.mas_top).offset(-10);
    }];
    [self.vipView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_offset(0.f);
        make.bottom.mas_offset(-20);
        make.top.equalTo(self.historyCollectionView.mas_bottom).offset(10);
    }];
    [self.subListView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    @weakify(self);
    self.cateView.onSelected = ^(YCTCatesModel * _Nonnull model) {
        @strongify(self);
        [self.view endEditing:YES];
        YCTCateViewController* cateVC=[[YCTCateViewController alloc] init];
        cateVC.typeId=model.cateId;
        cateVC.selectModel=model;
        @weakify(self);
        cateVC.onSelected = ^(YCTCatesModel * _Nonnull model) {
            @strongify(self);
            self.topView.searchTextField.text = model.name;
            [self handleToReturn];
        };
        [self.navigationController pushViewController:cateVC animated:YES];
//        self.topView.searchTextField.text = key;
//        [self handleToReturn];
    };
}

- (void)bindViewModel{
    if (YCT_IS_VALID_STRING(self.defaultKeywords)) {
        self.topView.searchTextField.text = self.defaultKeywords;
        [self handleToReturn];
    }
    @weakify(self);
    [self.topView setTextBeginEditingHandler:^{
        @strongify(self);
        self.historyCollectionView.hidden = NO;
        self.cateView.hidden=NO;
        self.vipView.hidden=NO;
    }];
    
    [self.topView setReturnHandler:^{
        @strongify(self);
        [self handleToReturn];
    }];
    
    [[self.topView.backButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        if (self.isCallApi) {
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            [self dismissViewControllerAnimated:NO completion:nil];
        }
    }];
    
    [[self.topView.searchButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        [self handleToReturn];
    }];
    
    [[self.topView.locationButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        YCTGetLocationViewController * vc = [[YCTGetLocationViewController alloc] initWithDelegate:self];
        [self.navigationController pushViewController:vc animated:YES];
    }];
    
    [RACObserve(self.viewModel, locationName) subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        [self.topView.locationButton setTitle:x forState:UIControlStateNormal];
    }];
    
    [RACObserve(self.viewModel, isHistoryFold) subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        [self.historyCollectionView reloadSections:[NSIndexSet indexSetWithIndex:0]];
    }];

    [[RACSignal merge:@[RACObserve(self.viewModel, historyKeys),RACObserve(self.viewModel, wantSearchKeys)]] subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        [self.historyCollectionView reloadData];
    }];
    [[RACSignal merge:@[RACObserve(self.viewModel, hotSearchKeys),RACObserve(self.viewModel, hotSearchKeys)]] subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        [self.historyCollectionView reloadData];
    }];
    [[RACSignal merge:@[RACObserve(self.viewModel, cateKeys),RACObserve(self.viewModel, cateKeys)]] subscribeNext:^(id  _Nullable x) {
        @strongify(self);
//        NSLog(@"cateKeys变化:%@",self.viewModel.cateKeys);
//        [self.historyCollectionView reloadData];
        [self.cateView setCollectData:self.viewModel.cateKeys];
//        self.cateView.datas=self.viewModel.cateKeys.copy;
    }];
    //"https://video.honghukeji.net/index.html#/index?id=" + personid + "&lan=" + lan
    
    [[self.topView.scanButton rac_signalForControlEvents:(UIControlEventTouchUpInside)] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        YCTQRCodeScanViewController *vc = [[YCTQRCodeScanViewController alloc] init];
        vc.scanResultBlock = ^(NSString *result) {
            NSString *idStr = [YCTChatUtil unwrappedUserIdFromUrl:result];
            if (!idStr) return;
            
            NSMutableArray *vcs = self.navigationController.viewControllers.mutableCopy;
            [self.navigationController.viewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([obj isKindOfClass:YCTQRCodeScanViewController.class]) {
                    [vcs removeObject:obj];
                    *stop = YES;
                }
            }];
            [vcs addObject:[YCTOtherPeopleHomeViewController otherPeopleHomeWithUserId:idStr]];
            [self.navigationController setViewControllers:vcs.copy animated:YES];
        };
        [self.navigationController pushViewController:vc animated:YES];
    }];

}

- (void)handleToReturn{
    self.historyCollectionView.hidden = YES;
    self.cateView.hidden=YES;
    self.vipView.hidden=YES;
    if (!self.subListView) {
        self.subListView = [[JXCategoryListContainerView alloc] initWithType:JXCategoryListContainerType_ScrollView delegate:self];
        self.segmentView.listContainer = self.subListView;
        [self.view addSubview:self.subListView];
        [self.view insertSubview:self.subListView belowSubview:self.historyCollectionView];
        [self.subListView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsMake(88 + kStatusBarHeight, 0, 0, 0));
        }];
    }
    [self.viewModel searchWithKeyword:self.topView.searchTextField.text];
    [self.view endEditing:YES];
    [self.segmentView selectItemAtIndex:0];
    [self.segmentView reloadData];
}

#pragma mark -
- (void)locationDidSelectWithAll:(NSArray<YCTMintGetLocationModel *> *)locations
                        lastPrev:(YCTMintGetLocationModel *)lastPrev
                            last:(YCTMintGetLocationModel *)last{
    [YCTUserDataManager sharedInstance].locationId = last.cid;
    [YCTUserDataManager sharedInstance].locationCity = last.name;
}

#pragma mark - JXCategoryListContainerViewDelegate

- (NSInteger)numberOfListsInlistContainerView:(JXCategoryListContainerView *)listContainerView {
    return self.segmentView.titles.count;
}

- (id<JXCategoryListContentViewDelegate>)listContainerView:(JXCategoryListContainerView *)listContainerView initListForIndex:(NSInteger)index {
    YCTSearchSubViewController * list = [[YCTSearchSubViewController alloc] initWithType:index+1 keyword:self.topView.searchTextField.text locationId:self.viewModel.locationId];
    return list;
}

#pragma mark - UICollectionViewDelegate & dataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 3;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (section == 0) {
        return self.viewModel.isHistoryFold ? MIN(10, self.viewModel.historyKeys.count) : self.viewModel.historyKeys.count;
    }else if(section==1){
      
        return self.viewModel.hotSearchKeys.count;
    }else{
       
        return self.viewModel.wantSearchKeys.count;
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return [YCTSearchHistoryItemCell sizeWithText:self.viewModel.historyKeys[indexPath.row]];
    }else{
        return CGSizeMake((Iphone_Width - 51)/2, 20);
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    if (section == 0 && !YCT_IS_VALID_ARRAY(self.viewModel.historyKeys)) {
        return CGSizeZero;
    }
    return YCTSearchHistoryHeaderView.headerSize;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    if (section == 0 && YCT_IS_VALID_ARRAY(self.viewModel.historyKeys)) {
        return YCTSearchHistoryFooter.footerSize;
    }else{
        return CGSizeZero;
    }
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        
        if (indexPath.section == 0) {
            YCTSearchHistoryHeaderView * header = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"history" forIndexPath:indexPath];
            header.headerTitle.text = YCTLocalizedTableString(@"search.SearchHistory", @"Home");
            [header.actionButton setTitle:YCTLocalizedTableString(@"search.open", @"Home") forState:UIControlStateNormal];
            [header.actionButton setTitle:YCTLocalizedTableString(@"search.packUp", @"Home") forState:UIControlStateSelected];
            [header.actionButton setImage:nil forState:UIControlStateNormal];
            header.actionButton.hidden = self.viewModel.historyKeys.count <= 10;
            @weakify(self);
            RAC(header.actionButton, selected) = [[RACObserve(self.viewModel, isHistoryFold) takeUntil:header.rac_prepareForReuseSignal] map:^id _Nullable(id  _Nullable value) {
                @strongify(self);
                return @(!self.viewModel.isHistoryFold);
            }];
            
            [[[header.actionButton rac_signalForControlEvents:UIControlEventTouchUpInside] takeUntil:header.rac_prepareForReuseSignal] subscribeNext:^(__kindof UIControl * _Nullable x) {
                @strongify(self);
                self.viewModel.isHistoryFold = !self.viewModel.isHistoryFold;
            }];
            return header;
        }else{
            YCTSearchHistoryHeaderView * header = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"guess" forIndexPath:indexPath];
            header.headerTitle.text =indexPath.section==1? YCTLocalizedTableString(@"search.HotSearch", @"Home"):YCTLocalizedTableString(@"search.Guess", @"Home");
            if(indexPath.section==2){
                header.actionButton.hidden=NO;
                [header.actionButton setTitle:YCTLocalizedTableString(@"search.ChangeIt", @"Home") forState:UIControlStateNormal];
                [header.actionButton setImage:[UIImage imageNamed:@"home_search_refresh"] forState:UIControlStateNormal];
                @weakify(self);
                [[[header.actionButton rac_signalForControlEvents:UIControlEventTouchUpInside] takeUntil:header.rac_prepareForReuseSignal] subscribeNext:^(__kindof UIControl * _Nullable x) {
                    @strongify(self);
                    [self.viewModel requestForWantSearch];
                }];
            }else{
                header.actionButton.hidden=YES;
            }
            
            return header;
        }
    }else{
        YCTSearchHistoryFooter * footer = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:YCTSearchHistoryFooter.cellReuseIdentifier forIndexPath:indexPath];
        @weakify(self);
        [[footer.deleteHistoryButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self);
            @weakify(self);
            [UIView showAlertSheetWith:YCTLocalizedTableString(@"search.confirmHistoryClear", @"Home") clickAction:^{
                @strongify(self);
                [self.viewModel clearHistoryKeys];
            }];
            
        }];
        return footer;
    }
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        YCTSearchHistoryItemCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:YCTSearchHistoryItemCell.cellReuseIdentifier forIndexPath:indexPath];
        cell.searchText.text = self.viewModel.historyKeys[indexPath.row];
        return cell;
    }else if(indexPath.section==1){
        YCTSearchReCommendItemCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:YCTSearchReCommendItemCell.cellReuseIdentifier forIndexPath:indexPath];
        cell.searchText.text = self.viewModel.hotSearchKeys[indexPath.row];
        cell.hotTag.hidden = YES;
        return cell;
    }else{
        YCTSearchReCommendItemCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:YCTSearchReCommendItemCell.cellReuseIdentifier forIndexPath:indexPath];
        cell.searchText.text = self.viewModel.wantSearchKeys[indexPath.row];
        cell.hotTag.hidden = YES;
        return cell;
    }
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    if (section == 0 && !YCT_IS_VALID_ARRAY(self.viewModel.historyKeys)) {
        return UIEdgeInsetsZero;
    }
    return UIEdgeInsetsMake(20, 15, 20, 15);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    if (section == 0) {
        return 10.f;
    }else{
        return 20.f;
    }
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    if (section == 0) {
        return 10.f;
    }else{
        return 15.f;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        
        self.topView.searchTextField.text = self.viewModel.historyKeys[indexPath.row];
        
        [self handleToReturn];
    }else if (indexPath.section == 1) {
        self.topView.searchTextField.text = self.viewModel.hotSearchKeys[indexPath.row];
        [self handleToReturn];
    }else{
        self.topView.searchTextField.text = self.viewModel.wantSearchKeys[indexPath.row];
        [self handleToReturn];
    }
   
   
}


#pragma mark - getter
- (YCTSearchNavView *)topView{
    if (!_topView) {
        _topView = [YCTSearchNavView new];
    }
    return _topView;
}
- (YCTSearchCategoryView *)cateView{
    if (!_cateView) {
        _cateView = [[YCTSearchCategoryView alloc] init];
        [_cateView.btn addTarget:self action:@selector(showCate) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _cateView;
}
-(YCTVipView *)vipView
{
    if(!_vipView)
    {
        _vipView=[[YCTVipView alloc] init];
    }
    return _vipView;
}
-(void)showCate{
    [self.view endEditing:YES];
    YCTCateViewController* cateVC=[[YCTCateViewController alloc] init];
    cateVC.isFromHomeSearch = self.isFromHomeSearch;
    @weakify(self);
    cateVC.onSelected = ^(YCTCatesModel * _Nonnull model) {
        @strongify(self);
        self.topView.searchTextField.text = model.name;
        [self handleToReturn];
    };
    [self.navigationController pushViewController:cateVC animated:YES];
}
- (UICollectionView *)historyCollectionView{
    if (!_historyCollectionView) {
        UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
        _historyCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _historyCollectionView.backgroundColor = UIColor.whiteColor;
        _historyCollectionView.delegate = self;
        _historyCollectionView.dataSource = self;
        [_historyCollectionView registerClass:YCTSearchHistoryItemCell.class
                   forCellWithReuseIdentifier:YCTSearchHistoryItemCell.cellReuseIdentifier];
        [_historyCollectionView registerClass:YCTSearchReCommendItemCell.class
                   forCellWithReuseIdentifier:YCTSearchReCommendItemCell.cellReuseIdentifier];
        [_historyCollectionView registerClass:YCTSearchHistoryHeaderView.class
                   forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                          withReuseIdentifier:@"history"];
        [_historyCollectionView registerClass:YCTSearchHistoryHeaderView.class
                   forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                          withReuseIdentifier:@"guess"];
        [_historyCollectionView registerClass:YCTSearchHistoryFooter.class
                   forSupplementaryViewOfKind:UICollectionElementKindSectionFooter
                          withReuseIdentifier:YCTSearchHistoryFooter.cellReuseIdentifier];
        
        SEL sel = NSSelectorFromString(@"_setRowAlignmentsOptions:");
        if ([_historyCollectionView.collectionViewLayout respondsToSelector:sel]) {
            ((void(*)(id,SEL,NSDictionary*))objc_msgSend)(_historyCollectionView.collectionViewLayout,sel,
                                                          @{@"UIFlowLayoutCommonRowHorizontalAlignmentKey":@(NSTextAlignmentLeft),
                                                            @"UIFlowLayoutLastRowHorizontalAlignmentKey" : @(NSTextAlignmentLeft),
                                                            @"UIFlowLayoutRowVerticalAlignmentKey" : @(NSTextAlignmentCenter)});
            
        }
    }
    return _historyCollectionView;
}

- (JXCategoryTitleView *)segmentView{
    if (!_segmentView) {
        _segmentView = [JXCategoryTitleView normalCategoryTitleView];
        _segmentView.defaultSelectedIndex = self.defaultSearchType;
        _segmentView.titles = @[
//            YCTLocalizedTableString(@"search.tabAll", @"Home"),
            YCTLocalizedTableString(@"search.tabVideo", @"Home"),
            YCTLocalizedTableString(@"search.tabUser", @"Home")];
    }
    return _segmentView;
}

- (YCTSearchViewModel *)viewModel{
    if (!_viewModel) {
        _viewModel = [[YCTSearchViewModel alloc] init];
    }
    return _viewModel;
}

@end
