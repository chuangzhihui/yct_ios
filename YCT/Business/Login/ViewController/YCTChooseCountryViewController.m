//
//  YCTChooseCountryViewController.m
//  YCT
//
//  Created by 木木木 on 2022/1/8.
//

#import "YCTChooseCountryViewController.h"
#import "YCTTableViewCell.h"
#import "YCTApiGetPhoneArea.h"
#import "NSString+TUIUtil.h"

@interface YCTChooseCountryViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, copy) NSDictionary<NSString *, NSArray<YCTPhoneAreaModel *> *> *dataDict;
@property (nonatomic, copy) NSArray *groupList;

@end

@implementation YCTChooseCountryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = YCTLocalizedTableString(@"login.title.country", @"Login");
    [self requestGetPhoneArea];
}

- (void)setupView {
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(kNavigationBarHeight);
        make.left.right.bottom.mas_equalTo(0);
    }];
}

- (void)requestGetPhoneArea {
    [[YCTHud sharedInstance] showLoadingHud];
    YCTApiGetPhoneArea *api = [YCTApiGetPhoneArea new];
    [api startWithCompletionBlockWithSuccess:^(__kindof YCTBaseRequest * _Nonnull request) {
        if (YCT_IS_ARRAY(request.responseDataModel)) {
            [self handleData:request.responseDataModel];
        }
        [[YCTHud sharedInstance] hideHud];
    } failure:^(__kindof YCTBaseRequest * _Nonnull request) {
        [[YCTHud sharedInstance] showDetailToastHud:request.getError];
    }];
}

- (void)handleData:(NSArray *)responseData {
    NSMutableDictionary *dataDict = @{}.mutableCopy;
    NSMutableArray *groupList = @[].mutableCopy;
    NSMutableArray *nonameList = @[].mutableCopy;

    for (YCTPhoneAreaModel *model in responseData) {
       NSString *group = [[model.name firstPinYin] uppercaseString];
       if (group.length == 0 || !isalpha([group characterAtIndex:0])) {
           [nonameList addObject:model];
           continue;
       }
       NSMutableArray *list = [dataDict objectForKey:group];
       if (!list) {
           list = @[].mutableCopy;
           dataDict[group] = list;
           [groupList addObject:group];
       }
       [list addObject:model];
    }

    [groupList sortUsingSelector:@selector(localizedStandardCompare:)];
    if (nonameList.count) {
       [groupList addObject:@"#"];
       dataDict[@"#"] = nonameList;
    }
    for (NSMutableArray *list in [dataDict allValues]) {
       [list sortUsingSelector:@selector(compare:)];
    }
    self.groupList = groupList;
    self.dataDict = dataDict;
    [self.tableView reloadData];
}

#pragma mark - UITableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.groupList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSString *group = self.groupList[section];
    NSArray *list = self.dataDict[group];
    return list.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YCTTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:YCTTableViewCell.cellReuseIdentifier forIndexPath:indexPath];
    NSString *group = self.groupList[indexPath.section];
    NSArray *list = self.dataDict[group];
    YCTPhoneAreaModel *data = list[indexPath.row];
    cell.margin = 30;
    cell.detailTextLabel.textColor = UIColor.mainGrayTextColor;
    cell.textLabel.text = data.name;
    cell.detailTextLabel.text = data.no;
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
            view.backgroundColor = tableView.backgroundColor;
            view;
        });
        UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        textLabel.tag = TEXT_TAG;
        textLabel.font = [UIFont PingFangSCBold:22];
        textLabel.textColor = UIColor.mainTextColor;
        [headerView addSubview:textLabel];
        [textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(30);
            make.centerY.mas_equalTo(8);
        }];
    }
    UILabel *label = [headerView viewWithTag:TEXT_TAG];
    label.text = self.groupList[section];
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 65;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    NSMutableArray *array = @[].mutableCopy;
    [array addObjectsFromArray:self.groupList];
    return array;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.choosePhoneAreaBlock) {
        NSString *group = self.groupList[indexPath.section];
        NSArray *list = self.dataDict[group];
        YCTPhoneAreaModel *data = list[indexPath.row];
        self.choosePhoneAreaBlock(data.no, data.name);
    }
    [self.navigationController popViewControllerAnimated:YES];
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
