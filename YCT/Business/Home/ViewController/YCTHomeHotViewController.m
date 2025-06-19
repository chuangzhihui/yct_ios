//
//  YCTHomeHotSubViewController.m
//  YCT
//
//  Created by hua-cloud on 2021/12/12.
//

#import "YCTHomeHotViewController.h"
#import "JXCategoryTitleView+Customization.h"
#import "YCTHomeHotCell.h"
#import "YCTApiGetHotList.h"
#import "YCTOtherPeopleHomeViewController.h"
#import "YCTSearchViewController.h"

#pragma mark - HotSub
@interface YCTHomeHotSubViewController : YCTBaseViewController<UITableViewDelegate, UITableViewDataSource,JXCategoryListContentViewDelegate>
@property (strong, nonatomic) YCTHomeHotSubViewModel *viewModel;
@property (strong, nonatomic) UITableView *tableView;
@property (assign, nonatomic) YCTHotTagType type;

@end

@implementation YCTHomeHotSubViewController

- (instancetype)initWithType:(YCTHotTagType)type{
    if (self = [super init]) {
        self.type = type;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.clearColor;
}

- (void)setupView {
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
}

- (void)bindViewModel{
    @weakify(self);
    [RACObserve(self.viewModel, cellViewModels) subscribeNext:^(id x) {
        @strongify(self);
        [self.tableView reloadData];
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.viewModel.cellViewModels.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YCTHomeHotCell *cell = [tableView dequeueReusableCellWithIdentifier:YCTHomeHotCell.cellReuseIdentifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell prepareDisplayWith:self.viewModel.cellViewModels[indexPath.row]];
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 42;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    YCTHomeHotListItemViewModel * item = self.viewModel.cellViewModels[indexPath.row];
    if (self.type == YCTHotTagTypeHot) {
        YCTSearchViewController * vc = [[YCTSearchViewController alloc] initWithKeyWord:item.hotModel.tagText defaultSearchType:self.type == YCTHotTagTypeHot ? YCTSearchResultTypeAll : YCTSearchResultTypeUser];
        UINavigationController * nav = [[UINavigationController alloc] initWithRootViewController:vc];
        nav.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:nav animated:NO completion:nil];
    } else {
        YCTOtherPeopleHomeViewController *vc = [YCTOtherPeopleHomeViewController otherPeopleHomeWithUserId:item.userId needGoMinePageIfNeeded:YES];
        if (vc) {
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}

#pragma mark - JXCategoryListContentViewDelegate

- (UIView *)listView {
    return self.view;
}

#pragma mark - Getter

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:(UITableViewStylePlain)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedRowHeight = 44;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.backgroundView.backgroundColor = [UIColor clearColor];
        [_tableView registerNib:YCTHomeHotCell.nib forCellReuseIdentifier:YCTHomeHotCell.cellReuseIdentifier];
    }
    return _tableView;
}


- (YCTHomeHotSubViewModel *)viewModel{
    if (!_viewModel) {
        _viewModel = [[YCTHomeHotSubViewModel alloc] initWithType:self.type];
    }
    return _viewModel;
}
@end


#pragma mark - Hot
@interface YCTHomeHotViewController ()<JXCategoryListContainerViewDelegate,JXCategoryViewDelegate>
@property (strong, nonatomic) JXCategoryTitleView * segmentView;
@property (strong, nonatomic) JXCategoryListContainerView *subListView;

@end

@implementation YCTHomeHotViewController


#pragma mark - private
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
}

- (void)setupView{
    UIView * bgView = [UIView new];
    bgView.backgroundColor = UIColorFromRGB(0x303030);
    bgView.layer.cornerRadius = 10.f;
    
    self.segmentView.listContainer = self.subListView;
    
    [self.view addSubview:bgView];
    [bgView addSubview:self.segmentView];
    [bgView addSubview:self.subListView];
    
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(15 + kStatusBarHeight + 44, 15, -15, 15));
    }];
    
    [self.segmentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(44);
        make.left.right.mas_equalTo(0.f);
        make.top.mas_equalTo(11);
    }];
    
    [self.subListView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.segmentView.mas_bottom);
        make.bottom.mas_offset(-15);
        make.left.right.mas_offset(0);
    }];
}

#pragma mark - JXCategoryListContainerViewDelegate

- (NSInteger)numberOfListsInlistContainerView:(JXCategoryListContainerView *)listContainerView {
    return _segmentView.titles.count;
}

- (id<JXCategoryListContentViewDelegate>)listContainerView:(JXCategoryListContainerView *)listContainerView initListForIndex:(NSInteger)index {
    YCTHomeHotSubViewController *list = [[YCTHomeHotSubViewController alloc] initWithType:index == 0 ? YCTHotTagTypeHot : YCTHotTagTypeCo];
    return list;
}



#pragma mark - JXCategoryListContentViewDelegate

- (UIView *)listView {
    return self.view;
}

#pragma mark - Getter
- (JXCategoryTitleView *)segmentView{
    if (!_segmentView) {
        _segmentView = [JXCategoryTitleView normalCategoryTitleView];
        _segmentView.titleLabelZoomEnabled = YES;
        _segmentView.titleLabelZoomScale = 1.3;
        _segmentView.cellSpacing = 25;
        _segmentView.titleColor = UIColor.whiteColor;
        _segmentView.titleSelectedColor = UIColor.whiteColor;
        _segmentView.titleFont = [UIFont systemFontOfSize:18.f weight:UIFontWeightBold];
        _segmentView.contentEdgeInsetLeft = 31;
        _segmentView.titles = @[
            YCTLocalizedTableString(@"tabHot.HotSearchList", @"Home"),
            YCTLocalizedTableString(@"tabHot.HotBrandList", @"Home")];
        
        JXCategoryIndicatorLineView * lineView = (JXCategoryIndicatorLineView *)[_segmentView.indicators firstObject];
        lineView.indicatorColor = UIColor.whiteColor;
        UIView *line = [_segmentView viewWithTag:kLineViewTag];
        [line removeFromSuperview];
    }
    return _segmentView;
}

- (JXCategoryListContainerView *)subListView {
    if (!_subListView) {
        _subListView = [[JXCategoryListContainerView alloc] initWithType:JXCategoryListContainerType_ScrollView delegate:self];
        _subListView.contentScrollView.scrollEnabled = NO;
    }
    return _subListView;
}

@end
