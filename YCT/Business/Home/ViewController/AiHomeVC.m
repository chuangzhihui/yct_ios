//
//  AiHomeVC.m
//  YCT
//
//  Created by 林涛 on 2025/3/24.
//

#import "AiHomeVC.h"
#import "YCT-Swift.h"
#import "AiClassificationPageVC.h"
#import "AiImportVC.h"

#import "AiHomeCell.h"
#import "AiHomeChangeView.h"

#import "AiTagsModel.h"
#import "ApiAiGetAiTags.h"

static NSString *const kAiHomeCellId = @"kAiHomeCellId";
@interface AiHomeVC ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *titleArr;
@property (nonatomic, strong) NSArray *textArr;

@property (nonatomic, strong) NSMutableArray<AiTagsModel *> *dataArr;
@property (nonatomic, strong) AiHomeChangeView *changeVw;
@property (nonatomic, strong) UIButton *barButton;
//@property (nonatomic, strong) UIButton *changeVw;

@end

@implementation AiHomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"AI";
    
    //    "ai.openaiName" = "Open AI";
    //    "ai.commerceName" = "AI电商";
    //    "ai.suppliersName" = "这里有全球200个国家的供应商与进口商";
    //    "ai.openai" = "Ftozon building with OPENAI。";
    //    "ai.commerce" = "您想买哪个工厂产品，可以进来与AI讨论产品细节并与工厂直接成交，工厂通过AI建设商铺，让AI直接与您对接。";
    //    "ai.suppliers" = "全球供应商与进口商，(我们数据来源于第三方，也是全球公开贸易数据，我们不承担任何法律问题，)";
    
//    self.titleArr = @[YCTLocalizedTableString(@"ai.openaiName", @"Home"),
//                      YCTLocalizedTableString(@"ai.commerceName", @"Home"),
//                      YCTLocalizedTableString(@"ai.suppliersName", @"Home")];
//    self.textArr = @[YCTLocalizedTableString(@"ai.openai", @"Home"),
//                     YCTLocalizedTableString(@"ai.commerce", @"Home"),
//                     YCTLocalizedTableString(@"ai.suppliers", @"Home")];
    [self setTextShowType:1];
    
    [self setViewUI];
    [self getData];
}
#pragma mark ------ UI ------
- (void)setViewUI {
    self.barButton = [UIButton buttonWithType:UIButtonTypeSystem];
    //    barButton.imageEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 0);
    [_barButton setTitle:@"English ▼" forState:(UIControlStateNormal)];
    [_barButton setTitle:@"中文 ▼" forState:(UIControlStateSelected)];
    [_barButton setTitleColor:UIColorFromRGB(0x333333) forState:(UIControlStateNormal)];
    _barButton.titleLabel.font = [UIFont systemFontOfSize:13 weight:(UIFontWeightRegular)];
    [_barButton setFrame:CGRectMake(0, 0, 42, 40)];
    [_barButton addTarget:self action:@selector(onRightItemTouch:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:_barButton];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(kNavigationBarHeight);
        make.left.bottom.right.mas_equalTo(0);
    }];
}
#pragma mark ------ UITableViewDataSource ------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _titleArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AiHomeCell *cell = [tableView dequeueReusableCellWithIdentifier:kAiHomeCellId];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.nameLb.text = _titleArr[indexPath.row];
    cell.textLb.text = _textArr[indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        [self goOpenAi];
    } else if (indexPath.row == 1) {
        AiClassificationPageVC *vc = [[AiClassificationPageVC alloc]init];
        vc.title = _titleArr[indexPath.row];
        vc.dataArr = _dataArr;
        [self.navigationController pushViewController:vc animated:true];
    } else if (indexPath.row == 2) {
//        AiImportVC *vc = [[AiImportVC alloc]init];
//        vc.title = _titleArr[indexPath.row];
//        [self.navigationController pushViewController:vc animated:true];
        SearchModuleVC *vc = [[SearchModuleVC alloc] init];
        vc.topY = kNavigationBarHeight;
        vc.title = _titleArr[indexPath.row];
        [self.navigationController pushViewController:vc animated:true];
    }
}

#pragma mark ------ Data ------
- (void)getData{
    [self requestForVideoData];
}

//- (void)loadMore{
//    [self requestForVideoData];
//}

- (void)requestForVideoData{
    [[YCTHud sharedInstance] showLoadingHud];
    
    ApiAiGetAiTags * api = [[ApiAiGetAiTags alloc] init];
    @weakify(self);
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSLog(@"请求主页数据成功");
        @strongify(self);
        NSArray<AiTagsModel *> * models;
        if ([api.responseDataModel isKindOfClass:[NSMutableArray class]]) {
            models = YCTArray(api.responseDataModel, @[]);
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
- (void)setTextShowType:(NSInteger)type {
    NSString *lg = type == 0 ? ZH:EN;
    NSString *openaiName = [YCTSanboxTool localizedStringForKey:@"ai.openaiName" language:lg podName:nil table:@"Home"];
    NSString *commerceName = [YCTSanboxTool localizedStringForKey:@"ai.commerceName" language:lg podName:nil table:@"Home"];
    NSString *suppliersName = [YCTSanboxTool localizedStringForKey:@"ai.suppliersName" language:lg podName:nil table:@"Home"];
    self.titleArr = @[openaiName,
                      commerceName,
                      suppliersName];
    NSString *openai = [YCTSanboxTool localizedStringForKey:@"ai.openai" language:lg podName:nil table:@"Home"];
    NSString *commerce = [YCTSanboxTool localizedStringForKey:@"ai.commerce" language:lg podName:nil table:@"Home"];
    NSString *suppliers = [YCTSanboxTool localizedStringForKey:@"ai.suppliers" language:lg podName:nil table:@"Home"];
    self.textArr = @[openai,
                     commerce,
                     suppliers];
    
    [self.tableView reloadData];
}
- (void)goOpenAi {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"AIChatBot" bundle:nil];
    // Instantiate the ChatBotViewController from the storyboard
    ChatBotViewController *chatBotVC = [storyboard instantiateViewControllerWithIdentifier:@"ChatBotViewController"];
    // Configure the modal presentation and transition styles
    chatBotVC.modalPresentationStyle = UIModalPresentationPageSheet;
    chatBotVC.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    [self presentViewController:chatBotVC animated:YES completion:^{
        
    }];
}
- (void)onRightItemTouch:(UIButton *)btn {
    if (_changeVw == nil) {
        UIWindow * keyWindow = [UIApplication sharedApplication].keyWindow;
        [keyWindow addSubview:self.changeVw];
    }
    [_changeVw show];
}
- (void)changeBgVwTouch {
    [_changeVw hide];
}
- (void)languageBtn1Touch:(UIButton *)btn {
    [_changeVw hide];
    NSString *text = [NSString stringWithFormat:@"%@ ▼",btn.titleLabel.text];
    [_barButton setTitle:text forState:(UIControlStateNormal)];
    [self setTextShowType:0];
}
- (void)languageBtn2Touch:(UIButton *)btn {
    [_changeVw hide];
    NSString *text = [NSString stringWithFormat:@"%@ ▼",btn.titleLabel.text];
    [_barButton setTitle:text forState:(UIControlStateNormal)];
    [self setTextShowType:1];
}


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
        _tableView.estimatedRowHeight = 135;
        
        _tableView.dataSource = self;
        _tableView.delegate = self;
        
        [_tableView registerClass:[AiHomeCell class] forCellReuseIdentifier:kAiHomeCellId];
        
    }
    return _tableView;
}
- (NSMutableArray *)dataArr {
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}

- (AiHomeChangeView *)changeVw {
    if (!_changeVw) {
        _changeVw = [[AiHomeChangeView alloc]initWithFrame:(CGRectMake(0, 0, Iphone_Width, Iphone_Height))];
        [_changeVw.bgVw addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeBgVwTouch)]];
        [_changeVw.btn1 addTarget:self action:@selector(languageBtn1Touch:) forControlEvents:(UIControlEventTouchUpInside)];
        [_changeVw.btn2 addTarget:self action:@selector(languageBtn2Touch:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _changeVw;
}
@end
