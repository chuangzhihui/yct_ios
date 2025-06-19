//
//  YCTBecomeCompanyAuditListVC.m
//  YCT
//
//  Created by 林涛 on 2025/4/1.
//

#import "YCTBecomeCompanyAuditListVC.h"
#import "YCTBecomeCompanyViewController.h"

#import "YCTBecomeCompanyAuditListCell.h"

#import "ApiAiGetAiTags.h"
#import "CompanyAuditApi.h"

// 剪切走
static NSString *const kYCTBecomeCompanyAuditListCellId = @"kYCTBecomeCompanyAuditListCellId";
@interface YCTBecomeCompanyAuditListVC ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *typeArr;
@property (nonatomic, strong) NSMutableArray<CompanyAuditModel *> *dataArr;

@end

@implementation YCTBecomeCompanyAuditListVC
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = YCTLocalizedTableString(@"mine.audit.auditList", @"Mine");
    
    [self setViewUI];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [_tableView reloadData];
}
#pragma mark ------ UI ------
- (void)setViewUI {
    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(kNavigationBarHeight);
        make.left.bottom.right.mas_equalTo(0);
    }];
}
#pragma mark ------ UITableViewDataSource ------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YCTBecomeCompanyAuditListCell *cell = [tableView dequeueReusableCellWithIdentifier:kYCTBecomeCompanyAuditListCellId];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    YCTBecomeCompanyViewController *vc = [[YCTBecomeCompanyViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark ------ Data ------
- (void)getData{
    [[YCTHud sharedInstance] showLoadingHud];
    
    CompanyAuditApi * api = [[CompanyAuditApi alloc] init];
    @weakify(self);
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSLog(@"请求主页数据成功");
        @strongify(self);
        NSArray<CompanyAuditModel *> * models;
        if ([api.responseDataModel isKindOfClass:[NSMutableArray class]]) {
            models = YCTArray(api.responseDataModel, @[]);
        } else {
            CompanyAuditModel *model = api.responseDataModel;
        }
        NSLog(@"datas:%@",request.responseString);
        [self.dataArr removeAllObjects];
        [self.dataArr addObjectsFromArray:models];
        [[YCTHud sharedInstance] hideHud];
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSLog(@"请求主页数据失败：%@",request.requestUrl);
        NSLog(@"请求主页数据失败：%@",request.responseString);
        [[YCTHud sharedInstance] hideHud];
    }];
}

#pragma mark ------ method ------

#pragma mark ------ Getters And Setters ------
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.backgroundColor = UIColor.whiteColor;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        //设置自动计算行号模式
        _tableView.rowHeight = UITableViewAutomaticDimension;
        //设置预估行高
        _tableView.estimatedRowHeight = 131/2;
        
        _tableView.dataSource = self;
        _tableView.delegate = self;
        
        [_tableView registerClass:[YCTBecomeCompanyAuditListCell class] forCellReuseIdentifier:kYCTBecomeCompanyAuditListCellId];
        
    }
    return _tableView;
}

@end
