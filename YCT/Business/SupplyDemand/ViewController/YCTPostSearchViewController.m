//
//  YCTPostSearchViewController.m
//  YCT
//
//  Created by 木木木 on 2022/3/3.
//

#import "YCTPostSearchViewController.h"
#import "YCTSupplyDemandSearchViewModel.h"
#import "YCTSearchViewController.h"
#import "YCTSearchHistoryItemCell.h"
#import "YCTSearchHistoryHeaderView.h"
#import "YCTSearchHistoryFooter.h"
#import "YCTGetLocationViewController.h"
#import "YCTOtherPeopleHomeViewController.h"
#import "YCTPostListCell.h"
#import "YCTPhotoBrowser.h"
#import "YCTPostDetailViewController.h"
#import "EmptyView.h"
@interface YCTPostSearchViewController ()<UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource,  UICollectionViewDelegateFlowLayout, YCTGetLocationViewControllerDelegate>
@property (nonatomic, strong) UITableView *postTableView;
@property (nonatomic, strong) YCTSearchNavView *topView;
@property (nonatomic, strong) UICollectionView *historyCollectionView;
@property (nonatomic, strong) YCTSupplyDemandSearchViewModel *viewModel;
@property int type;//0最新 1供应 2需求
@property(nonatomic,strong)EmptyView *empty;
@end

@implementation YCTPostSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.type=0;
    // Do any additional setup after loading the view.
}

- (BOOL)naviagtionBarHidden {
    return YES;
}

- (void)setupView {
    [self.view addSubview:self.topView];
    [self.view addSubview:self.postTableView];
    [self.view addSubview:self.historyCollectionView];
    
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(kStatusBarHeight);
        make.height.mas_equalTo(44);
        make.left.right.mas_equalTo(0);
    }];
    
    [self.postTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topView.mas_bottom);
        make.left.right.bottom.mas_offset(0);
    }];
    
    [self.historyCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.topView.mas_bottom);
        make.left.right.bottom.mas_offset(0);
    }];
}

- (void)bindViewModel {
    @weakify(self);
    [self.topView setTextBeginEditingHandler:^{
        @strongify(self);
        self.historyCollectionView.hidden = NO;
    }];
    
    [self.topView setReturnHandler:^{
        @strongify(self);
        [self handleToReturn];
    }];
    
    [[self.topView.backButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
    [[self.topView.searchButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        [self handleToReturn];
    }];
    
    [[self.topView.locationButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        YCTGetLocationViewController *vc = [[YCTGetLocationViewController alloc] initWithDelegate:self];
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
    
    [RACObserve(self.viewModel, historyKeys) subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        [self.historyCollectionView reloadData];
    }];
    
    RAC(self.postTableView.mj_footer, hidden) = [RACObserve(self.viewModel, models) map:^id _Nullable(NSArray * _Nullable value) {
        return @(value.count == 0);
    }];
    
    [self.viewModel.loadingSubject subscribeNext:^(NSNumber * _Nullable x) {
        @strongify(self);
        if (!x.boolValue) {
            if (self.postTableView.mj_header.isRefreshing) {
                [self.postTableView.mj_header endRefreshing];
            }
            [self.view hideHud];
        } else {
            [self.view showLoadingHud];
        }
    }];
    
    [self.viewModel.hasMoreDataSubject subscribeNext:^(NSNumber * _Nullable x) {
        @strongify(self);
        if (x.boolValue) {
            [self.postTableView.mj_footer endRefreshing];
        } else {
            [self.postTableView.mj_footer endRefreshingWithNoMoreData];
        }
    }];
    
    [self.viewModel.netWorkErrorSubject subscribeNext:^(NSString * _Nullable x) {
        @strongify(self);
        [self.view showDetailToastHud:x];
    }];
    
    [self.viewModel.loadAllDataSubject subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        [self.postTableView reloadData];
    }];
}

- (void)handleToReturn {
    self.historyCollectionView.hidden = YES;
    [self.viewModel searchWithKeyword:self.topView.searchTextField.text];
    [self.view endEditing:YES];
    [self.viewModel resetRequestData];
}

#pragma mark - YCTGetLocationViewControllerDelegate

- (void)locationDidSelectWithAll:(NSArray<YCTMintGetLocationModel *> *)locations
                        lastPrev:(YCTMintGetLocationModel *)lastPrev
                            last:(YCTMintGetLocationModel *)last{
    [YCTUserDataManager sharedInstance].locationId = last.cid;
    [YCTUserDataManager sharedInstance].locationCity = last.name;
}

#pragma mark - UITableViewDataSource
-(void)showZuixin{
    self.type=0;
    [self.viewModel searchWithType:self.type];
    [self.viewModel resetRequestData];
}
-(void)showGongying{
    self.type=1;
    [self.viewModel searchWithType:self.type];
    [self.viewModel resetRequestData];
}
-(void)showXuqiu{
    self.type=2;
    [self.viewModel searchWithType:self.type];
    [self.viewModel resetRequestData];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 44.0f;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view=[[UIView alloc] init];
    view.backgroundColor=[UIColor whiteColor];
    UILabel *zuixin=[[UILabel alloc] init];
    zuixin.text= YCTLocalizedTableString(@"post.newest", @"Post");
    zuixin.font=self.type==0?[UIFont boldSystemFontOfSize:18]:[UIFont systemFontOfSize:16];
    zuixin.textColor=self.type==0?[UIColor blackColor]:[UIColor grayColor];
    [view addSubview:zuixin];
    [zuixin mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(view.mas_centerY);
        make.left.equalTo(view.mas_left).offset(15);
    }];
    zuixin.userInteractionEnabled=YES;
    if(self.type!=0){
        [zuixin addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showZuixin)]];
    }
    
    
    UILabel *gongyong=[[UILabel alloc] init];
    gongyong.text=YCTLocalizedTableString(@"post.supply", @"Post");
    gongyong.font=self.type==1?[UIFont boldSystemFontOfSize:18]:[UIFont systemFontOfSize:16];
    gongyong.textColor=self.type==1?[UIColor blackColor]:[UIColor grayColor];
    [view addSubview:gongyong];
    [gongyong mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(view.mas_centerY);
        make.left.equalTo(zuixin.mas_right).offset(10);
    }];
    gongyong.userInteractionEnabled=YES;
    if(self.type!=1){
        [gongyong addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showGongying)]];
    }
    UILabel *xuqiu=[[UILabel alloc] init];
    xuqiu.text=YCTLocalizedTableString(@"post.demand", @"Post");
    xuqiu.font=self.type==2?[UIFont boldSystemFontOfSize:18]:[UIFont systemFontOfSize:16];
    xuqiu.textColor=self.type==2?[UIColor blackColor]:[UIColor grayColor];
    [view addSubview:xuqiu];
    [xuqiu mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(view.mas_centerY);
        make.left.equalTo(gongyong.mas_right).offset(10);
    }];
    xuqiu.userInteractionEnabled=YES;
    if(self.type!=2){
        [xuqiu addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showXuqiu)]];
    }
    return view;
}

//初始化空视图
-(void)initEmpty{
    if(!self.empty){
        self.empty=[[EmptyView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
        [self.postTableView addSubview:self.empty];
        [self.empty mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.postTableView.mas_centerX);
            make.top.equalTo(self.postTableView.mas_top).offset(50);
        }];
    }else{
        self.empty.alpha=1;
    }
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(self.viewModel.models.count>0 && self.empty){
        self.empty.alpha=0;
    }
    if(self.viewModel.models.count==0){
        [self initEmpty];
    }
    return self.viewModel.models.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YCTSupplyDemandItemModel *model = self.viewModel.models[indexPath.row];
    YCTPostListCell *cell = [tableView dequeueReusableCellWithIdentifier:YCTPostListCell.cellReuseIdentifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell updateWithModel:model];
    @weakify(self);
    cell.imageClickBlock = ^(YCTPostListCell *cell, NSInteger index) {
        @strongify(self);
        [YCTPhotoBrowser showPhotoBrowerInVC:self photoCount:cell.model.imgs.count currentIndex:index photoConfig:^(NSUInteger idx, NSURL *__autoreleasing *photoUrl, UIImageView *__autoreleasing *sourceImageView) {
            *photoUrl = [NSURL URLWithString:cell.model.imgs[idx]];
            *sourceImageView = [cell.imagesView imageViewAtIndex:idx];
        }];
    };
    cell.avatarClickBlock = ^(YCTSupplyDemandItemModel *model) {
        @strongify(self);
        YCTOtherPeopleHomeViewController *vc = [YCTOtherPeopleHomeViewController otherPeopleHomeWithUserId:model.userId needGoMinePageIfNeeded:YES];
        if (vc) {
            [self.navigationController pushViewController:vc animated:YES];
        }
    };
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    YCTPostDetailViewController *vc = [[YCTPostDetailViewController alloc] init];
    vc.model = self.viewModel.models[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - UICollectionViewDelegate & dataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.viewModel.isHistoryFold ? MIN(10, self.viewModel.historyKeys.count) : self.viewModel.historyKeys.count;
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
        YCTSearchHistoryHeaderView *header = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"history" forIndexPath:indexPath];
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
    } else {
        YCTSearchHistoryFooter *footer = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:YCTSearchHistoryFooter.cellReuseIdentifier forIndexPath:indexPath];
        @weakify(self);
        [[footer.deleteHistoryButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self);
            [UIView showAlertSheetWith:YCTLocalizedTableString(@"search.confirmHistoryClear", @"Home") clickAction:^{
                @strongify(self);
                [self.viewModel clearHistoryKeys];
            }];
        }];
        return footer;
    }
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    YCTSearchHistoryItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:YCTSearchHistoryItemCell.cellReuseIdentifier forIndexPath:indexPath];
    cell.searchText.text = self.viewModel.historyKeys[indexPath.row];
    return cell;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    if (!YCT_IS_VALID_ARRAY(self.viewModel.historyKeys)) {
        return UIEdgeInsetsZero;
    }
    return UIEdgeInsetsMake(20, 15, 20, 15);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 10.f;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 10.f;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    self.topView.searchTextField.text = self.viewModel.historyKeys[indexPath.row];
    [self handleToReturn];
}

#pragma mark - Getter

- (YCTSupplyDemandSearchViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [YCTSupplyDemandSearchViewModel new];
    }
    return _viewModel;
}

- (YCTSearchNavView *)topView{
    if (!_topView) {
        _topView = [YCTSearchNavView new];
        _topView.scanButton.hidden = YES;
    }
    return _topView;
}

- (UICollectionView *)historyCollectionView{
    if (!_historyCollectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        _historyCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _historyCollectionView.backgroundColor = UIColor.whiteColor;
        _historyCollectionView.delegate = self;
        _historyCollectionView.dataSource = self;
        [_historyCollectionView registerClass:YCTSearchHistoryItemCell.class
                   forCellWithReuseIdentifier:YCTSearchHistoryItemCell.cellReuseIdentifier];
        [_historyCollectionView registerClass:YCTSearchHistoryHeaderView.class
                   forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                          withReuseIdentifier:@"history"];
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

- (UITableView *)postTableView {
    if (!_postTableView) {
        _postTableView = [[UITableView alloc] initWithFrame:CGRectZero style:(UITableViewStylePlain)];
        _postTableView.delegate = self;
        _postTableView.dataSource = self;
        _postTableView.tableFooterView = [UIView new];
        _postTableView.backgroundColor = UIColor.tableBackgroundColor;
        _postTableView.rowHeight = UITableViewAutomaticDimension;
        _postTableView.estimatedRowHeight = 44;
        _postTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_postTableView registerNib:YCTPostListCell.nib forCellReuseIdentifier:YCTPostListCell.cellReuseIdentifier];
        @weakify(self);
        _postTableView.mj_footer = [YCTRefreshFooter footerWithRefreshingBlock:^{
            @strongify(self);
            [self.viewModel requestData];
        }];
    }
    return _postTableView;
}

@end
