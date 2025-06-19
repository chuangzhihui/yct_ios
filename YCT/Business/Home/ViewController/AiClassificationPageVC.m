//
//  AiClassificationPageVC.m
//  YCT
//
//  Created by 林涛 on 2025/3/25.
//

#import "AiClassificationPageVC.h"
#import "YCTCategoryTitleView.h"
#import "YCTHomeVideoViewController.h"
#import "AiClassificationListVC.h"
#import "AiHomeTitleVw.h"

@interface AiClassificationPageVC ()<JXCategoryViewDelegate,YCTCategoryViewDelegate,JXCategoryListContainerViewDelegate>
@property (strong, nonatomic) AiHomeTitleVw *topTitleVw;
@property (strong, nonatomic) YCTCategoryTitleView *segmentView;
@property (strong, nonatomic) JXCategoryListContainerView *listView;
@end

@implementation AiClassificationPageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

- (void)setupView{
    
    [self.view addSubview:self.topTitleVw];
    self.segmentView.listContainer = self.listView;
    
    [self.view addSubview:self.listView];
    [self.view addSubview:self.segmentView];
    
    [self.topTitleVw mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(kNavigationBarHeight);
        make.height.mas_equalTo(37);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
    }];
    [self.segmentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_topTitleVw.mas_bottom);
        make.height.mas_equalTo(44);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
    }];
    [self.listView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_segmentView.mas_bottom);
        make.left.right.mas_offset(0);
        make.bottom.mas_equalTo(0);
    }];
}

#pragma mark - JXCategoryListContainerViewDelegate
- (NSInteger)numberOfListsInlistContainerView:(JXCategoryListContainerView *)listContainerView {
    return self.segmentView.titles.count;
}
- (id<JXCategoryListContentViewDelegate>)listContainerView:(JXCategoryListContainerView *)listContainerView initListForIndex:(NSInteger)index {
    AiClassificationListVC * list = [[AiClassificationListVC alloc] init];
    list.dataArr = _dataArr[index].children;
    return list;
}

#pragma mark - Set
- (AiHomeTitleVw *)topTitleVw {
    if (!_topTitleVw) {
        _topTitleVw = [[AiHomeTitleVw alloc]init];
        _topTitleVw.backgroundColor = UIColor.whiteColor;
    }
    return _topTitleVw;
}
- (YCTCategoryTitleView *)segmentView{
    if (!_segmentView) {
        _segmentView = [YCTCategoryTitleView new];
        _segmentView.delegate = self;
        _segmentView.UIDelegate = self;
//        _segmentView.titleColorGradientEnabled = YES;
        _segmentView.averageCellSpacingEnabled = NO;
        _segmentView.titleColor = UIColorFromRGB(0x666666); // UIColor.segmentTitleColor
        _segmentView.titleSelectedColor = UIColorFromRGB(0x333333);
        _segmentView.cellSpacing = 15;
        _segmentView.contentEdgeInsetLeft = 10;
        _segmentView.contentEdgeInsetRight = 0;

        _segmentView.titleFont = [UIFont systemFontOfSize:16.f weight:UIFontWeightBold];
        _segmentView.titleSelectedFont = [UIFont systemFontOfSize:16.f weight:UIFontWeightBold];
        _segmentView.defaultSelectedIndex = 0;

        // Allow titles to span multiple lines
        _segmentView.titleNumberOfLines = 1; // Maximum 2 lines
//        _segmentView.lineBreakMode = NSLineBreakByWordWrapping; // Ensure text wraps to the next line

        _segmentView.backgroundColor = UIColor.whiteColor;
//        _segmentView.titleSelectedColor = UIColor.blackColor;
//        _segmentView.cornerRadius = 5;
        NSArray *names = [_dataArr valueForKeyPath:@"@unionOfObjects.name"];
        _segmentView.titles = names;
        
        JXCategoryIndicatorLineView *lineView = [[JXCategoryIndicatorLineView alloc] init];
    //    lineView.lineStyle = JXCategoryIndicatorLineStyle_LengthenOffset;
        lineView.indicatorWidth = 21;
        lineView.indicatorHeight = 3;
    //    lineView.indicatorCornerRadius = 2;
        lineView.indicatorColor = UIColorFromRGB(0xF6BC4E);
    //    lineView.lineScrollOffsetX = -50;
        _segmentView.indicators = @[lineView];
        
        UIView *line = [[UIView alloc] init];
        line.backgroundColor = UIColor.separatorColor;
        [_segmentView addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.mas_equalTo(0);
            make.height.mas_equalTo(onePx);
        }];
    }
    return _segmentView;
}

- (JXCategoryListContainerView *)listView {
    if (!_listView) {
        _listView = [[JXCategoryListContainerView alloc] initWithType:JXCategoryListContainerType_ScrollView delegate:self];
    }
    return _listView;
}

@end
