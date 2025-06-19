//
//  AiClassificationListVC.m
//  YCT
//
//  Created by 林涛 on 2025/3/25.
//

#import "AiClassificationListVC.h"
#import "YCT-Swift.h"
#import "YCTWebViewController.h"
#import "YCTWebviewURLProvider.h"
#import "AiMyAiVC.h"

#import "AiClassificationListHeadView.h"
#import "AiClassificationListCell.h"

#import "YCTApiHomeVideoList.h"
#import "AiTagsModel.h"
#import "ApiAiGetAiTags.h"


static NSString *const kAiClassificationListHeadViewId = @"kAiClassificationListHeadViewId";
static NSString *const kAiClassificationListCellId = @"kAiClassificationListCellId";
@interface AiClassificationListVC ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) UICollectionViewFlowLayout *layout;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, strong) Children *selectModel;
@property (nonatomic, strong) NSIndexPath *selectIndexPath;
@property (nonatomic, strong) NSString *webUrl;

@property (nonatomic, strong) UIButton *okBtn;
@end

@implementation AiClassificationListVC
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setViewUI];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self getPayAiState];
}
#pragma mark ------ UI ------
- (void)setViewUI {
    [self.view addSubview:self.collectionView];
    [self.view addSubview:self.okBtn];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(2);
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(_okBtn.mas_top).offset(-5);
    }];
    [self.okBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-30);
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.height.mas_equalTo(44);
    }];
}
#pragma mark ------ UITableViewDataSource ------
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return _dataArr.count;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    Children *modelArr = _dataArr[section];
    return modelArr.children.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    AiClassificationListCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kAiClassificationListCellId forIndexPath:indexPath];
    Children *model = _dataArr[indexPath.section];
    Children *model2 = model.children[indexPath.row];
    cell.dataModel = model2;
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(collectionView.frame.size.width, 50);
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView
           viewForSupplementaryElementOfKind:(NSString *)kind
                                 atIndexPath:(NSIndexPath *)indexPath {
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        AiClassificationListHeadView *header = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:kAiClassificationListHeadViewId forIndexPath:indexPath];
        Children *model = _dataArr[indexPath.section];
        header.nameLb.text = model.name;
        return header;
    }
    return nil;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    Children *model = _dataArr[indexPath.section];
    Children *model2 = model.children[indexPath.row];
    _selectModel = model2;
    _selectIndexPath = indexPath;
//    [self setOkBtnState:_selectModel];
    [self goOpenItmeAi:model2.name url:model2.url];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    Children *model = _dataArr[indexPath.section];
    Children *model2 = model.children[indexPath.row];
    UIFont *      font  = [UIFont systemFontOfSize:14];
    NSDictionary *attrs = @{NSFontAttributeName : font};
    CGSize        size  = [model2.name sizeWithAttributes:attrs];
    return CGSizeMake(size.width+30, 35);
}

#pragma mark ------ Data ------
- (void)setDataArr:(NSArray<Children *> *)dataArr {
    _dataArr = dataArr;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.collectionView selectItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] animated:true scrollPosition:(UICollectionViewScrollPositionNone)];
        [self setSelectData:[NSIndexPath indexPathForItem:0 inSection:0]];
    });
}
- (void)getData{
    
}

#pragma mark ------ method ------
- (void)setSelectData:(NSIndexPath *)indexPath {
    if (_dataArr.count) {
        Children *model = _dataArr[indexPath.section];
        Children *model2 = model.children[indexPath.row];
        _selectModel = model2;
        _selectIndexPath = indexPath;
    //    [self setOkBtnState:_selectModel];
    }
}
- (BOOL)isMyAi:(Children *)model {
    if (_selectModel.type == 1) {
        return true;
    }
    return false;
}
- (void)setOkBtnState:(Children *)model {
    if ([self isMyAi:model]) {
        [_okBtn setTitle:YCTLocalizedTableString(@"ai.myAi", @"Home") forState:(UIControlStateNormal)];
    } else {
        [_okBtn setTitle:YCTLocalizedTableString(@"ai.buy", @"Home") forState:(UIControlStateNormal)];
    }
}
- (BOOL)lookMyAi:(NSInteger)code {
    if (code == 200) {
        return true;
    }
    return false;
}
- (void)setOkBtnCode:(NSInteger)code {
//    if (code == 200 || code == 400) {
//        if ([self lookMyAi:code]) {
//            _okBtn.selected = false;
//        } else {
//            _okBtn.selected = true;
//        }
//    } else {
//        _okBtn.userInteractionEnabled = false;
//        _okBtn.alpha = 0.3;
//    }
    if ([self lookMyAi:code]) {
        _okBtn.selected = false;
    } else {
        _okBtn.selected = true;
    }
}


- (void)okBtn:(UIButton *)btn {
//    if (!_selectModel) {
//        [[YCTHud sharedInstance] showProgress:2 text:@"请选择AI"];
//        return;
//    }
    
//    if ([self isMyAi:_selectModel]) {
//        [self goMyAi];
//    } else {
//        [self goPayPop];
//    }
    
    if (_okBtn.isSelected) {
        [self goPayPop];
    } else {
        [self goMyAi];
    }
}

- (void)goPayPop {
    
//    NSInteger aiID = self.selectModel.id;
//    NSString *price = self.selectModel.price;
//    if ([price integerValue] == 0) {
//        YCTApiAuthPay *api=[[YCTApiAuthPay alloc] initWithType:[NSString stringWithFormat:@"%ld",(long)1] usrType:(ApiAuthPayTypeAiOther) price:price aiID:aiID];
//        [[YCTHud sharedInstance] showLoadingHud];
//        [api startWithCompletionBlockWithSuccess:^(__kindof YCTBaseRequest * _Nonnull request) {
//            [[YCTHud sharedInstance] hideHud];
////            YCTAuthPayModel * model=request.responseDataModel;
////            [self onAuthPaySuccess];
//            [self goMyAi];
//        } failure:^(__kindof YCTBaseRequest * _Nonnull request) {
//            NSLog(@"请求失败:%@%@",request.requestUrl,[request getError]);
//            [[YCTHud sharedInstance] hideHud];
//            [[YCTHud sharedInstance] showToastHud:@"获取支付失败"];
//        }];
//        
//        return;
//    }
    
    
    
    //弹窗选择支付方式
    NSArray *titles = @[
//                                @"微信支付",
                    YCTLocalizedTableString(@"mine.payment.alipay", @"Mine"),@"PayPal"];
    NSArray *subtitles = @[
//                    @"",
        @"",@""];
    NSArray *subIcons = @[
//                    @"wx_icon",
        @"ali_icon",@"paypal_icon"];
    NSInteger index = 3;
    @weakify(self);
    YCTPublishSettingBottomView *view = [YCTPublishSettingBottomView settingViewIconWithDefaultIndex:index title:YCTLocalizedTableString(@"mine.payment.place", @"Mine") titles:titles icons:subIcons subtitles:subtitles  selectedHandler:^(NSString * _Nullable title, NSInteger index) {
        @strongify(self);
        NSLog(@"回调:%ld",index);
        NSInteger aiID = self.selectModel.id;
        NSString *price = self.selectModel.price; // 和列表没有关联不在使用价格和id,里面已经注释
        YCTApiAuthPay *api=[[YCTApiAuthPay alloc] initWithType:[NSString stringWithFormat:@"%ld",(long)index+1] usrType:(ApiAuthPayTypeAiOther) price:price aiID:aiID];
        [[YCTHud sharedInstance] showLoadingHud];
        [api startWithCompletionBlockWithSuccess:^(__kindof YCTBaseRequest * _Nonnull request) {
            [[YCTHud sharedInstance] hideHud];
            YCTAuthPayModel * model=request.responseDataModel;
            NSLog(@"url:%@",model.url);
            if(index==1)
            {
                //paypal
                YCTPaypalViewController *vc=[[YCTPaypalViewController alloc] init];
                vc.url=[NSURL URLWithString:model.url];
                vc.onAuthSuccesss = ^(NSString * _Nonnull result) {
                    //授权成功
                    YCTApiPayPalDoPay * doPayApi=[[YCTApiPayPalDoPay  alloc] init];
                    doPayApi.order_sn=model.order_sn;
                    [[YCTHud sharedInstance] showLoadingHud];
                    [doPayApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
                        [[YCTHud sharedInstance] hideHud];
                        [self onAuthPaySuccess];
                    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
                        [[YCTHud sharedInstance] showToastHud:YCTLocalizedTableString(@"mine.payment.faile", @"Mine")];
                    }];
                };
// /xunji/credits
                [self.navigationController pushViewController:vc animated:YES];
            } else if(index==0) {
                //支付宝
                [[AlipaySDK defaultService] payOrder:model.url fromScheme:@"yct" callback:^(NSDictionary *resultDic) {
                    dispatch_async(dispatch_get_main_queue(), ^(void){
                      NSLog(@"支付结果:%@",resultDic);
                        NSString *status=[NSString stringWithFormat:@"%@",resultDic[@"resultStatus"]];
                        NSLog(@"status:%@",[resultDic objectForKey:@"resultStatus"]);
                      if ([status isEqualToString:@"9000"]) {
                          [self onAuthPaySuccess];
                      }

                    });
                }];
            }
        } failure:^(__kindof YCTBaseRequest * _Nonnull request) {
            NSLog(@"请求失败:%@ %@",request.requestUrl,[request getError]);
            NSLog(@"请求数据：%@",request.responseString);
            [[YCTHud sharedInstance] hideHud];
            [[YCTHud sharedInstance] showToastHud:@"获取支付失败"];
        }];
    }];
    [view yct_show];
}
- (void)getPayAiState {
    NSInteger aiID = self.selectModel.id;
    YCTApiAuthPay *api=[[YCTApiAuthPay alloc] initWithUsrType:ApiAuthPayTypeAiOther aiID:aiID];
    [[YCTHud sharedInstance] showLoadingHud];
    [api startWithCompletionBlockWithSuccess:^(__kindof YCTBaseRequest * _Nonnull request) {
        [[YCTHud sharedInstance] hideHud];
        NSInteger code = [request.responseObject[@"code"] integerValue];
        id data = request.responseObject[@"data"];
        if([data isKindOfClass:[NSString class]]){
            self.webUrl = [data stringValue];
            [self setOkBtnCode:code];
        }
    } failure:^(__kindof YCTBaseRequest * _Nonnull request) {
        NSInteger code = [request.responseObject[@"code"] integerValue];
        NSLog(@"请求失败:%@ %@ code:%ld",request.requestUrl,[request getError], code);
        id data = request.responseObject[@"data"];
        if([data isKindOfClass:[NSString class]]){
            self.webUrl = [data stringValue];
            [self setOkBtnCode:code];
        }
        [[YCTHud sharedInstance] hideHud];
    }];
}

-(void)onAuthPaySuccess {
    NSLog(@"支付成功同志");
    [[YCTHud sharedInstance] showSuccessHud:@"success"];
   //重载数据;
//    [self updateMineInfo];
    [self getPayAiState];
}
- (void)updateMineInfo {
    [[YCTUserManager sharedInstance] updateUserInfo];
    _selectModel.type = 1;
    Children *model = _dataArr[_selectIndexPath.section];
    Children *model2 = model.children[_selectIndexPath.row];
    model2.type = 1;
    [self setOkBtnState:_selectModel];
}
- (void)goMyAi {
    YCTWebViewController *vc = [[YCTWebViewController alloc] init];
    
//    if ([NSURL URLWithString:_selectModel.url]) {
    if (_webUrl.length) {
        vc.url = [NSURL URLWithString:_webUrl];
    }
    vc.title = _okBtn.titleLabel.text;
    [self.navigationController pushViewController:vc animated:YES];
    
//    AiMyAiVC *vc = [[AiMyAiVC alloc] init];
//    vc.title = _selectModel.name;
//    [self.navigationController pushViewController:vc animated:YES];
}

- (void)goOpenItmeAi:(NSString *)text url:(NSString *)url {
//    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"AIChatBot" bundle:nil];
//    // Instantiate the ChatBotViewController from the storyboard
//    ChatBotViewController *chatBotVC = [storyboard instantiateViewControllerWithIdentifier:@"ChatBotViewController"];
//    // Configure the modal presentation and transition styles
//    chatBotVC.modalPresentationStyle = UIModalPresentationPageSheet;
//    chatBotVC.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
//    chatBotVC.autoSendText = text;
//    [self presentViewController:chatBotVC animated:YES completion:^{
//        
//    }];
    
    YCTWebViewController *vc = [[YCTWebViewController alloc] init];
    if (url) {
        vc.url = [NSURL URLWithString:url];
    }
    vc.title = text;
    [self.navigationController pushViewController:vc animated:YES];
    
}

#pragma mark ------ Getters And Setters ------
- (UICollectionViewFlowLayout *)layout {
    if (!_layout) {
        _layout = [[UICollectionViewFlowLayout alloc] init];
        _layout.itemSize = CGSizeMake(78.5, 24);
        _layout.minimumLineSpacing = 10;
        _layout.minimumInteritemSpacing = 10;
        _layout.sectionInset = UIEdgeInsetsMake(0, 10, 0, 10);
        _layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    }
    return _layout;
}
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.layout];
        _collectionView.backgroundColor = UIColor.whiteColor;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.pagingEnabled = true;
        _collectionView.alwaysBounceVertical = YES;
        //        _collectionView.scrollEnabled  = false;
        
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        
        [_collectionView registerClass:[AiClassificationListHeadView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kAiClassificationListHeadViewId];
        [_collectionView registerClass:[AiClassificationListCell class] forCellWithReuseIdentifier:kAiClassificationListCellId];
    }
    return _collectionView;
}

- (UIButton *)okBtn {
    if (!_okBtn) {
        UIButton *btn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [btn setTitle:YCTLocalizedTableString(@"ai.myAi", @"Home") forState:(UIControlStateNormal)];
        [btn setTitle:YCTLocalizedTableString(@"ai.buy", @"Home") forState:(UIControlStateSelected)];
        [btn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:15 weight:(UIFontWeightBold)];
        btn.layer.cornerRadius = 44/2;
        btn.layer.masksToBounds = true;
        btn.backgroundColor = UIColorFromRGB(0xF6BC4E);
        _okBtn = btn;
        [_okBtn addTarget:self action:@selector(okBtn:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _okBtn;
}

#pragma mark - JXCategoryListContentViewDelegate
- (UIView *)listView {
    return self.view;
}

@end
