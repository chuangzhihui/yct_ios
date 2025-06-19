//
//  YCTGetLocationViewController.m
//  YCT
//
//  Created by 木木木 on 2021/12/26.
//

#import "YCTGetLocationViewController.h"
#import "YCTMineGetLocationViewModel.h"
#import "YCTTableViewCell.h"

@interface YCTGetLocationViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) YCTMineGetLocationViewModel *viewModel;
@property (strong, nonatomic) YCTMineGetLocationViewModel *nextLevelViewModel;

@property (strong, nonatomic) UITableView *tableView;

@property (weak, nonatomic) id<YCTGetLocationViewControllerDelegate> delegate;

@property (strong, nonatomic) YCTMintGetLocationModel *currentSelectedModel;
@property (strong, nonatomic) NSMutableArray *cLocations;

- (instancetype)initWitPid:(NSString *)pid
                 viewModel:(YCTMineGetLocationViewModel *)viewModel
                cLocations:(nullable NSArray<YCTMintGetLocationModel *> *)cLocations
                  delegate:(id<YCTGetLocationViewControllerDelegate>)delegate
NS_DESIGNATED_INITIALIZER;

@end

@implementation YCTGetLocationViewController

- (instancetype)initWithDelegate:(id<YCTGetLocationViewControllerDelegate>)delegate {
    self = [self initWitPid:@"0" viewModel:nil cLocations:nil delegate:delegate];
    return self;
}

- (instancetype)initWitPid:(NSString *)pid
                 viewModel:(YCTMineGetLocationViewModel *)viewModel
                cLocations:(nullable NSArray<YCTMintGetLocationModel *> *)cLocations
                  delegate:(id<YCTGetLocationViewControllerDelegate>)delegate {
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        self.delegate = delegate;
        self.cLocations = [NSMutableArray arrayWithArray:cLocations];
        if (viewModel) {
            self.viewModel = viewModel;
        } else {
            self.viewModel = [[YCTMineGetLocationViewModel alloc] initWithPid:pid];
        }
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = YCTLocalizedTableString(@"mine.title.address", @"Mine");
    
    if (!self.viewModel.dataDict) {
        [self.viewModel requestData];
    }
}

- (void)bindViewModel {
    @weakify(self);
    [self.viewModel.loadAllDataSubject subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        [self.tableView reloadData];
    }];
    
    [self.viewModel.toastSubject subscribeNext:^(NSString * _Nullable x) {
        if (YCT_IS_STRING(x)) {
            [[YCTHud sharedInstance] showDetailToastHud:x];
        } else {
            [[YCTHud sharedInstance] hideHud];
        }
    }];
    
    [self.viewModel.loadingSubject subscribeNext:^(NSNumber * _Nullable x) {
        if (x.boolValue) {
            [[YCTHud sharedInstance] showLoadingHud];
        } else {
            [[YCTHud sharedInstance] hideHud];
        }
    }];
    
    RACSignal *nlViewModelToastSubject = [[RACObserve(self, nextLevelViewModel) skip:1] flattenMap:^__kindof RACSignal * _Nullable(YCTMineGetLocationViewModel * _Nullable value) {
        return value.toastSubject;
    }];
    
    RACSignal *nlViewModelLoadingSubject = [[RACObserve(self, nextLevelViewModel) skip:1] flattenMap:^__kindof RACSignal * _Nullable(YCTMineGetLocationViewModel * _Nullable value) {
        return value.loadingSubject;
    }];
    
    RACSignal *nlViewModelLoadAllDataSubject = [[RACObserve(self, nextLevelViewModel) skip:1] flattenMap:^__kindof RACSignal * _Nullable(YCTMineGetLocationViewModel * _Nullable value) {
        return value.loadAllDataSubject;
    }];

    [nlViewModelLoadAllDataSubject subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        [self didRequestNextLevelData];
    }];
    
    [nlViewModelToastSubject subscribeNext:^(NSString * _Nullable x) {
        if (YCT_IS_STRING(x)) {
            [[YCTHud sharedInstance] showDetailToastHud:x];
        } else {
            [[YCTHud sharedInstance] hideHud];
        }
    }];
    
    [nlViewModelLoadingSubject subscribeNext:^(NSNumber * _Nullable x) {
        if (x.boolValue) {
            [[YCTHud sharedInstance] showLoadingHud];
        } else {
            [[YCTHud sharedInstance] hideHud];
        }
    }];
}

- (void)setupView {
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(kNavigationBarHeight);
        make.left.right.bottom.mas_equalTo(0);
    }];
}

#pragma mark - UITableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.viewModel.groupList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSString *group = self.viewModel.groupList[section];
    NSArray *list = self.viewModel.dataDict[group];
    return list.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YCTTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:YCTTableViewCell.cellReuseIdentifier forIndexPath:indexPath];
    NSString *group = self.viewModel.groupList[indexPath.section];
    NSArray *list = self.viewModel.dataDict[group];
    YCTMintGetLocationModel *data = list[indexPath.row];
    cell.margin = 25;
    cell.textLabel.text = data.name;
    cell.accessoryView = nil;
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
#define TEXT_TAG 1
    static NSString *headerViewId = @"HeaderView";
    UITableViewHeaderFooterView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:headerViewId];
    if (!headerView) {
        headerView = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:headerViewId];
        headerView.backgroundView = ({
            UIView *view = [UIView new];
            view.backgroundColor = UIColor.tableBackgroundColor;
            view;
        });
        UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        textLabel.tag = TEXT_TAG;
        textLabel.font = [UIFont PingFangSCMedium:12];
        textLabel.textColor = UIColor.mainTextColor;
        [headerView addSubview:textLabel];
        [textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(25);
            make.centerY.mas_equalTo(0);
        }];
    }
    UILabel *label = [headerView viewWithTag:TEXT_TAG];
    label.text = self.viewModel.groupList[section];
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 25;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    NSMutableArray *array = [NSMutableArray arrayWithObject:@""];
    [array addObjectsFromArray:self.viewModel.groupList];
    return array;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSString *group = self.viewModel.groupList[indexPath.section];
    NSArray *list = self.viewModel.dataDict[group];
    YCTMintGetLocationModel *data = list[indexPath.row];
    
    self.currentSelectedModel = data;
    self.nextLevelViewModel = [[YCTMineGetLocationViewModel alloc] initWithPid:data.cid];
    [self.nextLevelViewModel requestData];
}

#pragma mark - Private

- (void)didRequestNextLevelData {
    [self.cLocations addObject:self.currentSelectedModel];
    
    if (self.nextLevelViewModel.dataDict.count == 0) {
        NSMutableArray *viewControllers = self.navigationController.viewControllers.mutableCopy;
        [self.navigationController.viewControllers enumerateObjectsWithOptions:(NSEnumerationReverse) usingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:[self class]]) {
                [viewControllers removeObject:obj];
            } else {
                *stop = YES;
            }
        }];
        [self.navigationController setViewControllers:viewControllers.copy animated:YES];
        
        YCTMintGetLocationModel *lastPrev = nil;
        if (self.cLocations.count > 1) {
            lastPrev = self.cLocations[self.cLocations.count - 2];
        }
        if ([self.delegate respondsToSelector:@selector(locationDidSelectWithAll:lastPrev:last:)]) {
            [self.delegate locationDidSelectWithAll:self.cLocations.copy lastPrev:lastPrev last:self.cLocations.lastObject];
        }
    } else {
        YCTGetLocationViewController *vc = [[YCTGetLocationViewController alloc] initWitPid:self.currentSelectedModel.cid viewModel:self.nextLevelViewModel cLocations:self.cLocations delegate:self.delegate];
        [self.navigationController pushViewController:vc animated:YES];
        
        self.currentSelectedModel = nil;
        self.nextLevelViewModel = nil;
    }
}

#pragma mark - Getter

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.sectionIndexBackgroundColor = UIColor.clearColor;
        _tableView.sectionIndexColor = UIColor.mainTextColor;
        _tableView.backgroundColor = self.view.backgroundColor;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:YCTTableViewCell.class forCellReuseIdentifier:YCTTableViewCell.cellReuseIdentifier];
    }
    return _tableView;
}

@end
