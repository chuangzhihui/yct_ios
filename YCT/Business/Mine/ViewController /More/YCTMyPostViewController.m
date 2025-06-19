//
//  YCTMyPostViewController.m
//  YCT
//
//  Created by 木木木 on 2021/12/15.
//

#import "YCTMyPostViewController.h"
#import "YCTMyPostSubViewController.h"
#import "JXCategoryTitleView+Customization.h"

@interface YCTMyPostViewController ()<JXCategoryListContainerViewDelegate>

@property (strong, nonatomic) JXCategoryListContainerView *listView;
@property (strong, nonatomic) JXCategoryTitleView *titleView;
@property (copy, nonatomic) NSArray *titles;

@end

@implementation YCTMyPostViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        self.titles = @[
            YCTLocalizedTableString(@"mine.post.all", @"Mine"),
            YCTLocalizedTableString(@"mine.post.display", @"Mine"),
            YCTLocalizedTableString(@"mine.post.audit", @"Mine"),
            YCTLocalizedTableString(@"mine.post.failed", @"Mine"),
            YCTLocalizedTableString(@"mine.post.removed", @"Mine")];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = YCTLocalizedTableString(@"mine.title.myPost", @"Mine");
}

- (void)setupView {
    [self.view addSubview:self.titleView];
    [self.titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(kNavigationBarHeight);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(44);
    }];
    
    [self.view addSubview:self.listView];
    [self.listView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleView.mas_bottom);
        make.bottom.left.right.mas_equalTo(0);
    }];
    
    self.titleView.listContainer = self.listView;
}

#pragma mark - JXCategoryListContainerViewDelegate

- (NSInteger)numberOfListsInlistContainerView:(JXCategoryListContainerView *)listContainerView {
    return self.titles.count;
}

- (id<JXCategoryListContentViewDelegate>)listContainerView:(JXCategoryListContainerView *)listContainerView initListForIndex:(NSInteger)index {
    YCTMyPostSubViewController *list = [[YCTMyPostSubViewController alloc] initWithType:index];
    return list;
}

#pragma mark - Getter

- (JXCategoryTitleView *)titleView {
    if (!_titleView) {
        _titleView = ({
            JXCategoryTitleView *titleView = [JXCategoryTitleView normalCategoryTitleView];
            titleView.contentScrollViewClickTransitionAnimationEnabled = NO;
            titleView.averageCellSpacingEnabled = YES;
            titleView.titles = self.titles;
            titleView.cellSpacing = 0;
            titleView.contentEdgeInsetRight = titleView.contentEdgeInsetLeft;
            titleView.backgroundColor = UIColor.whiteColor;
            titleView;
        });
    }
    return _titleView;
}

- (JXCategoryListContainerView *)listView {
    if (!_listView) {
        _listView = [[JXCategoryListContainerView alloc] initWithType:JXCategoryListContainerType_ScrollView delegate:self];
        _listView.contentScrollView.scrollEnabled = NO;
    }
    return _listView;
}

@end
