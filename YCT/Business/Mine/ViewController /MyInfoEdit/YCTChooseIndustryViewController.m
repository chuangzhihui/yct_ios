//
//  YCTChooseIndustryViewController.m
//  YCT
//
//  Created by 张大爷的 on 2022/7/11.
//

#import "YCTChooseIndustryViewController.h"

#import "YCTChooseIndustryCell.h"
#import "YCTTableViewCell.h"
@interface YCTChooseIndustryViewController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>
@property(nonatomic,strong)UITableView *table;
@property (strong, nonatomic) YCTGetGoodsTypeListViewModel *viewModel;
@end

@implementation YCTChooseIndustryViewController
-(instancetype)initWithPid:(NSString *)pid onChoosed:(nullable void (^)(YCTMintGetLocationModel * data))onChoosed{
    self=[super init];
    if(self){
        self.viewModel = [[YCTGetGoodsTypeListViewModel alloc] initWithPid:pid];
        self.onChoosed = onChoosed;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = YCTLocalizedTableString(@"mine.title.goodsType", @"Mine");
    if (!self.viewModel.dataDict) {
        [self.viewModel requestData];
    }
    // Do any additional setup after loading the view.
}
- (void)bindViewModel {
    @weakify(self);
    [self.viewModel.loadAllDataSubject subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        [self.table reloadData];
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
}

-(void)setupView{
    [self.view addSubview:self.table];
    [self.table mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(kNavigationBarHeight);
        make.left.right.bottom.mas_equalTo(0);
    }];
}
-(UITableView *)table{
    if(!_table){
        _table = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _table.delegate = self;
        _table.dataSource = self;
        _table.sectionIndexBackgroundColor = UIColor.clearColor;
        _table.sectionIndexColor = UIColor.mainTextColor;
        _table.backgroundColor = self.view.backgroundColor;
        _table.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_table registerClass:YCTTableViewCell.class forCellReuseIdentifier:YCTTableViewCell.cellReuseIdentifier];
    }
    return _table;
}
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
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSString *group = self.viewModel.groupList[indexPath.section];
    NSArray *list = self.viewModel.dataDict[group];
    YCTMintGetLocationModel *data = list[indexPath.row];
    self.onChoosed(data);
    [self.navigationController popViewControllerAnimated:YES];
//    self.currentSelectedModel = data;
//    self.nextLevelViewModel = [[YCTGetGoodsTypeListViewModel alloc] initWithPid:data.cid];
//    [self.nextLevelViewModel requestData];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
