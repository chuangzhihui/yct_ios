 //
//  YTCPostViewController.m
//  YCT
//
//  Created by 木木木 on 2021/12/9.
//

#import "YCTPostViewController.h"
#import "YCTPostSubViewController.h"
#import "YCTPostAddViewController.h"
#import "YTCCategoryNavigationTitleView.h"
#import "YCTPostCreationView.h"
#import "YCTNavigationCoordinator.h"
#import "YCTPostAddSuccessViewController.h"
#import "YCTPostSearchViewController.h"
#import "YCTNavigationCoordinator.h"

@interface YCTPostViewController ()<JXCategoryListContainerViewDelegate>


@property (nonatomic, strong) YTCCategoryNavigationTitleView *titleView;
@property (nonatomic, strong) JXCategoryListContainerView *listView;
@property (nonatomic, strong) UIButton *addButton;

@end

@implementation YCTPostViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = UIColor.whiteColor;
    
    [self setupNavigationBar];
}

#pragma mark - Private

- (void)setupNavigationBar {
    YTCCategoryNavigationTitleView *titleView = [[YTCCategoryNavigationTitleView alloc] init];
    titleView.titleView.titles = @[
        YCTLocalizedTableString(@"post.newest", @"Post"),
        YCTLocalizedTableString(@"post.supply", @"Post"),
        YCTLocalizedTableString(@"post.demand", @"Post")];
    self.navigationItem.titleView = titleView;
    self.titleView = titleView;
    self.navigationItem.leftBarButtonItems = nil;
    
    UIButton *searchButton = [UIButton buttonWithType:UIButtonTypeSystem];
    searchButton.tintColor = UIColor.mainTextColor;
    [searchButton setImage:[[UIImage imageNamed:@"home_search"] imageWithRenderingMode:(UIImageRenderingModeAlwaysTemplate)] forState:UIControlStateNormal];
    @weakify(self);
    [[searchButton rac_signalForControlEvents:(UIControlEventTouchUpInside)] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        YCTPostSearchViewController *vc = [[YCTPostSearchViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }];
    [searchButton.widthAnchor constraintEqualToConstant:22].active = YES;
    [searchButton.heightAnchor constraintEqualToConstant:22].active = YES;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:searchButton];
    
    titleView.titleView.listContainer = self.listView;
}

- (void)setupView {
    [self.view addSubview:self.listView];
    [self.listView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];

    [self.view addSubview:self.addButton];
    [self.addButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.bottom.offset(-20);
        make.width.height.mas_equalTo(55);
    }];
}

- (void)refreshWhenTapTabbarItem {
    id<JXCategoryListContentViewDelegate> crtVC = self.listView.validListDict[@(self.titleView.titleView.selectedIndex)];
    if (crtVC && [crtVC isKindOfClass:YCTPostSubViewController.class]) {
        YCTPostSubViewController *vc = (YCTPostSubViewController *)crtVC;
        [vc reset];
    }
}

#pragma mark - JXCategoryListContainerViewDelegate

- (NSInteger)numberOfListsInlistContainerView:(JXCategoryListContainerView *)listContainerView {
    return 3;
}

- (id<JXCategoryListContentViewDelegate>)listContainerView:(JXCategoryListContainerView *)listContainerView initListForIndex:(NSInteger)index {
    YCTPostSubViewController *list = [[YCTPostSubViewController alloc] initWithType:index];
    return list;
}

#pragma mark - Getter

- (JXCategoryListContainerView *)listView {
    if (!_listView) {
        _listView = [[JXCategoryListContainerView alloc] initWithType:JXCategoryListContainerType_ScrollView delegate:self];
        _listView.contentScrollView.scrollEnabled = NO;
    }
    return _listView;
}

- (UIButton *)addButton {
    if (!_addButton) {
        _addButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_addButton setImage:[UIImage imageNamed:@"post_add"] forState:(UIControlStateNormal)];
        _addButton.layer.shadowColor = [UIColor blackColor].CGColor;
        _addButton.layer.shadowOffset = CGSizeMake(2, 2);
        _addButton.layer.shadowRadius = 2;
        _addButton.layer.shadowOpacity = 0.3;
        @weakify(self);
        [[_addButton rac_signalForControlEvents:(UIControlEventTouchUpInside)] subscribeNext:^(id x) {
            @strongify(self);
            [YCTNavigationCoordinator loginIfNeededWithAction:^{
                YCTPostCreationView *postCreationView = [[YCTPostCreationView alloc] init];
                [postCreationView yct_show];
                postCreationView.clickBlock = ^(int buttonIndex) {
                    if (buttonIndex == 1 && ![YCTNavigationCoordinator checkIfMoveToUserProfileWithNav:self.navigationController alertContent:YCTLocalizedString(@"alert.postNeedAuth")]) {
                        return;
                    }
                    YCTPostAddViewController *vc = [[YCTPostAddViewController alloc] initWithType:buttonIndex];
                    [self.navigationController pushViewController:vc animated:YES];
                    
                };
            }];
        }];
    }
    return _addButton;
}

@end


