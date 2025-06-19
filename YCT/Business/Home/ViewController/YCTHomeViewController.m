//
//  YCTHomeViewController.m
//  YCT
//
//  Created by hua-cloud on 2021/12/11.
//

#import "YCTHomeViewController.h"
#import "YCTCategoryTitleView.h"
#import "YCTSearchViewController.h"
#import "YCTHomeHotViewController.h"
#import "YCTHomeVideoViewController.h"
#import "JXCategoryTitleView+Customization.h"
#import "YCTRootViewController.h"
#import "UIWindow+Common.h"
#import "YCTLoginViewController.h"
#import "YCT-Swift.h"
#import "YCT-Bridging-Header.h"
#import "AiHomeVC.h"
#import "YCTApiMineUserInfo.h"


@interface YCTHomeViewController ()<JXCategoryViewDelegate,YCTCategoryViewDelegate,JXCategoryListContainerViewDelegate>
@property (strong, nonatomic) UIView * effectBgVw;
@property (strong, nonatomic) YCTCategoryTitleView *segmentView;
@property (strong, nonatomic) UIButton * aiButton;
@property (strong, nonatomic) UIButton * searchButton;
@property (strong, nonatomic) UIImageView * aiImg;
@property (strong, nonatomic) UIImageView * searchImg;
@property (strong, nonatomic) JXCategoryListContainerView *listView;
@property (strong, nonatomic) YCTHomeVideoViewController *focusVc;
@property (assign, nonatomic) BOOL isStatusBarLight;
@property (assign, nonatomic) BOOL isMerchant;
@end


@implementation YCTHomeViewController

#pragma mark - private
- (void)viewDidLoad {
    [super viewDidLoad];
    
    /*
//    [[YCTUserDataManager sharedInstance] updateUserInfo:request.responseDataModel];
    if ([YCTUserDataManager sharedInstance].isLogin) {
        YCTApiMineUserInfo *apiUserInfo = [[YCTApiMineUserInfo alloc] init];
        [apiUserInfo startWithCompletionBlockWithSuccess:^(__kindof YCTBaseRequest * _Nonnull request) {
            YCTMineUserInfoModel *model = request.responseDataModel;
            self.isMerchant = model.isMerchant;
//            self.isMerchant = true;
            if (self.isMerchant) {
                self.segmentView.titles = @[
                    YCTLocalizedTableString(@"tab.follow", @"Home"),
                    YCTLocalizedTableString(@"tab.List", @"Home"),
                    YCTLocalizedTableString(@"tab.foryou", @"Home"),
                ];
                [self.segmentView reloadData];
            }
        } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
            
        }];
    }
    */
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
//    [self.navigationController setToolbarHidden:YES animated:animated];
}

- (BOOL)naviagtionBarHidden{
    return YES;
}

- (void)setupView{
    self.isStatusBarLight = YES;
    UIView * topView = [UIView new];
    
    self.segmentView.listContainer = self.listView;
    
    [self.view addSubview:self.listView];
    [self.view addSubview:self.segmentView];
    [self.view addSubview:self.effectBgVw];
    [self.view addSubview:topView];
    [topView addSubview:self.segmentView];
    [topView addSubview:self.aiImg];
    [topView addSubview:self.aiButton];
    [topView addSubview:self.searchImg];
    [topView addSubview:self.searchButton];
    
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(kStatusBarHeight);
        make.left.right.mas_offset(0);
        make.height.mas_equalTo(44);
    }];
    
    [self.segmentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(topView);
        make.height.mas_equalTo(49);
        make.left.mas_offset(0);//45
        make.right.mas_equalTo(_aiImg.mas_left).offset(-kAutoScaleX(5));
//        make.right.mas_offset(-49);
    }];
    
    [self.aiImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(17, 18));
        make.centerY.mas_equalTo(_segmentView);
        make.right.mas_equalTo(_searchImg.mas_left).offset(-(kAutoScaleX(46)));
    }];
    [self.searchImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(17, 18));
        make.centerY.mas_equalTo(_segmentView);
        make.right.mas_equalTo(-(kAutoScaleX(29)));
    }];
    [self.aiButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(40, 40));
        make.center.mas_equalTo(_aiImg);
    }];
    [self.searchButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(_aiButton);
        make.center.mas_equalTo(_searchImg);
    }];
    
    [self.listView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
}

- (void)bindViewModel{
    @weakify(self);
    [[self.searchButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        YCTSearchViewController * vc = [YCTSearchViewController new];
        vc.isFromHomeSearch = YES;
        UINavigationController * nav = [[UINavigationController alloc] initWithRootViewController:vc];
        nav.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:nav animated:NO completion:nil];
    }];
    
    [[self.aiButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        AiHomeVC *vc = [AiHomeVC new];
        vc.hidesBottomBarWhenPushed = true;
        [self.navigationController pushViewController:vc animated:true];
    }];
    
}

#pragma mark - JXCategoryViewDelegate
- (void)categoryView:(JXCategoryBaseView *)categoryView didSelectedItemAtIndex:(NSInteger)index{
    NSLog(@"点击:%ld",(long)index);
    if(index==0)
    {
        [_focusVc refresh];
    }
    /*//老版
    JXCategoryIndicatorLineView * lineView = (JXCategoryIndicatorLineView *)[_segmentView.indicators firstObject];
//    lineView.indicatorColor = UIColor.clearColor;
//    lineView.backgroundColor = UIColor.clearColor;
    YCTCategoryTitleView * cate = (YCTCategoryTitleView *)categoryView;
    cate.titleSelectedColor = UIColor.blackColor;
    cate.backgroundColor = UIColor.whiteColor;
    if (index == 0) {
//        lineView.indicatorColor = UIColor.clearColor;
//        lineView.backgroundColor = UIColor.clearColor;
        cate.titleSelectedColor = UIColor.segmentSelectedTitleColor;
    }
    
    [(YCTRootViewController *)self.tabBarController updateTabbarStyle:index == 0];

//    [self.segmentView mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.height.mas_equalTo(index == 0 ? 0 : 44); // Reset the height of the segment view
//    }];
    
//    [self.searchButton mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.height.mas_equalTo(index == 0 ? 0 : 44); // Set the height of the segment view to 0
//    }];
    [categoryView reloadDataWithoutListContainer];
    
    self.isStatusBarLight = index > 0;
    [self setNeedsStatusBarAppearanceUpdate];
     */
}
/*//老版
- (UIColor *)selectedTitleColorWhenRefreshToIndex:(NSInteger)index{
    if (index == 0) {
        return UIColor.segmentSelectedTitleColor;
    }
    return self.segmentView.titleSelectedColor;
}
*/

#pragma mark - JXCategoryListContainerViewDelegate

- (NSInteger)numberOfListsInlistContainerView:(JXCategoryListContainerView *)listContainerView {
    return self.segmentView.titles.count;
}
//        YCTHomeHotViewController *list = [[YCTHomeHotViewController alloc] init];

- (id<JXCategoryListContentViewDelegate>)listContainerView:(JXCategoryListContainerView *)listContainerView initListForIndex:(NSInteger)index {
    
//    if (index == 0) {
//        // Display Search Module
//        SearchModuleVC *list = [[SearchModuleVC alloc] init];
//        return list;
//    }
//    if(index==1)
//    {
//        YCTHomeVideoViewController * list = [[YCTHomeVideoViewController alloc] initWithType:YCTHomeVideoTypeFocus];
//        list.user_type=0;
//        return list;
//    }
//    if(index==2)
//    {
//        YCTHomeVideoViewController * list = [[YCTHomeVideoViewController alloc] initWithType: YCTHomeVideoTypeRecommand];
//        list.user_type=2;
//        return list;
//    }
//    if(index==3)
//    {
//        YCTHomeVideoViewController * list = [[YCTHomeVideoViewController alloc] initWithType: YCTHomeVideoTypeRecommand];
//        list.user_type=1;
//        return list;
//    }
    

    if(index==0)
    {
//        YCTHomeVideoViewController * list = [[YCTHomeVideoViewController alloc] initWithType:YCTHomeVideoTypeFocus];
//        list.user_type=0;
        return self.focusVc;
    }
    if(index==1)
    {
//        if (self.isMerchant) {
//            YCTHomeVideoViewController * list = [[YCTHomeVideoViewController alloc] initWithType: YCTHomeVideoTypeRecommand];
//            list.user_type=1;
//            return list;
//        } else {
//            YCTHomeVideoViewController * list = [[YCTHomeVideoViewController alloc] initWithType: YCTHomeVideoTypeRecommand];
//            list.user_type=2;
//            return list;
//        }
        YCTHomeVideoViewController * list = [[YCTHomeVideoViewController alloc] initWithType: YCTHomeVideoTypeRecommand];
        list.user_type=2;
        return list;
    }
    if(index==2)
    {
        YCTHomeVideoViewController * list = [[YCTHomeVideoViewController alloc] initWithType: YCTHomeVideoTypeRecommand];
        list.user_type=1;
        return list;
    }
    return NULL;
}

#pragma mark - Override
- (UIStatusBarStyle)preferredStatusBarStyle {
    return self.isStatusBarLight;
}
#pragma mark - getter
- (UIView *)effectBgVw {
    if (!_effectBgVw) {
        CGFloat h = kNavigationBarHeight+2;
        CGFloat w = Iphone_Width;
        _effectBgVw = [[UIView alloc]initWithFrame:(CGRectMake(0, 0, w, h))];
        _effectBgVw.backgroundColor = UIColor.clearColor;
        _effectBgVw.alpha = 0.9;
        // 创建模糊效果
        UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        // 创建模糊视图
        UIVisualEffectView *blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
        blurEffectView.frame = CGRectMake(0, 0, w, h); // 模糊视图的大小与 contentView 一致
        // 将模糊视图添加到 contentView 上
        [_effectBgVw addSubview:blurEffectView];
    }
    return _effectBgVw;
}
- (UIButton *)aiButton {
    if (!_aiButton) {
        _aiButton = [UIButton buttonWithType:UIButtonTypeSystem];
    }
    return _aiButton;
}
- (UIButton *)searchButton {
    if (!_searchButton) {
        _searchButton = [UIButton buttonWithType:UIButtonTypeSystem];
//        [_searchButton setImage:[UIImage imageNamed:@"search"] forState:UIControlStateNormal];
//        [_searchButton setTintColor:UIColor.segmentTitleColor];
//        
//        _searchButton.backgroundColor = UIColor.whiteColor;
//        
//        // Configure shadow
//        _searchButton.layer.shadowColor = UIColor.blackColor.CGColor;
//        _searchButton.layer.shadowOffset = CGSizeMake(2, 2); // Slight downward shadow
//        _searchButton.layer.shadowOpacity = 0.2; // 30% opacity
//        _searchButton.layer.shadowRadius = 2.5; // Blur radius for softer shadow
//        _searchButton.layer.masksToBounds = NO; // Ensure shadow is visible outside the bounds
//        
//        // Optionally, round the corners for a better appearance
//        _searchButton.layer.cornerRadius = 4;
    }
    return _searchButton;
}
- (UIImageView *)aiImg {
    if (!_aiImg) {
        _aiImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ai_text_w"]];
        _aiImg.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _aiImg;
}
- (UIImageView *)searchImg {
    if (!_searchImg) {
        _searchImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"search_w"]];
        _aiImg.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _searchImg;
}

- (YCTCategoryTitleView *)segmentView{
    if (!_segmentView) {
        _segmentView = [YCTCategoryTitleView new];
        _segmentView.delegate = self;
        _segmentView.UIDelegate = self;
//        _segmentView.titleColorGradientEnabled = YES;
        _segmentView.averageCellSpacingEnabled = NO;
        _segmentView.titleColor = UIColor.whiteColor; // UIColor.segmentTitleColor
        _segmentView.titleSelectedColor = UIColor.whiteColor;
        _segmentView.averageCellSpacingEnabled = YES;
        _segmentView.cellSpacing = kAutoScaleX(45.5);
        _segmentView.contentEdgeInsetLeft = kAutoScaleX(30);
        _segmentView.contentEdgeInsetRight = kAutoScaleX(40);

        _segmentView.titleFont = [UIFont systemFontOfSize:16.f weight:UIFontWeightBold];
        _segmentView.titleSelectedFont = [UIFont systemFontOfSize:16.f weight:UIFontWeightBold];
        _segmentView.defaultSelectedIndex = 2;

        // Allow titles to span multiple lines
        _segmentView.titleNumberOfLines = 0; // Maximum 2 lines
//        _segmentView.lineBreakMode = NSLineBreakByWordWrapping; // Ensure text wraps to the next line

        _segmentView.backgroundColor = UIColor.clearColor;
//        _segmentView.titleSelectedColor = UIColor.blackColor;
//        _segmentView.cornerRadius = 5;
        _segmentView.titles = @[
//            YCTLocalizedTableString(@"tab.List", @"Home"),
            YCTLocalizedTableString(@"tab.follow", @"Home"),
            YCTLocalizedTableString(@"tab.life", @"Home"),
            YCTLocalizedTableString(@"tab.foryou", @"Home"),
        ];
        
        JXCategoryIndicatorLineView *lineView = [[JXCategoryIndicatorLineView alloc] init];
    //    lineView.lineStyle = JXCategoryIndicatorLineStyle_LengthenOffset;
        lineView.indicatorWidth = 18;
        lineView.indicatorHeight = 2;
    //    lineView.indicatorCornerRadius = 2;
        lineView.indicatorColor = UIColor.whiteColor;
    //    lineView.lineScrollOffsetX = -50;
        _segmentView.indicators = @[lineView];
        
        // Add shadow
//        _segmentView.layer.shadowColor = UIColor.blackColor.CGColor;
//        _segmentView.layer.shadowOffset = CGSizeMake(2, 2); // Horizontal and vertical offset
//        _segmentView.layer.shadowOpacity = 0.2; // Transparency level of the shadow
//        _segmentView.layer.shadowRadius = 3; // Blur radius
//        _segmentView.layer.masksToBounds = NO; // Ensures the shadow is visible outside bounds
    }
    return _segmentView;
}




- (JXCategoryListContainerView *)listView {
    if (!_listView) {
        _listView = [[JXCategoryListContainerView alloc] initWithType:JXCategoryListContainerType_ScrollView delegate:self];
    }
    return _listView;
}
-(YCTHomeVideoViewController *)focusVc
{
    if(!_focusVc)
    {
       
        _focusVc=[[YCTHomeVideoViewController alloc] initWithType:YCTHomeVideoTypeFocus];
        _focusVc.user_type=0;
    }
    return _focusVc;
}

@end
