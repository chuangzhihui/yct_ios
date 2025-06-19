//
//  YCTBannerViewController.m
//  YCT
//
//  Created by 张大爷的 on 2022/7/11.
//

#import "YCTBannerViewController.h"
#import "SetBannerTableViewCell.h"
#import "YCTApiUpdateBanner.h"
#import "YCTApiGetMyBanner.h"
#import "YCTUserDataManager+Update.h"
#import "YCTImagePickerViewController.h"
#import "YCTApiUpload.h"
@interface YCTBannerViewController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,YCTImagePickerViewControllerDelegate>
@property(nonatomic,strong)UITableView *table;
@property(nonatomic,strong)UIButton *addBtn;
@end

@implementation YCTBannerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=YCTLocalizedTableString(@"mine.becomeCompany.companyPic", @"Mine");
    // Do any additional setup after loading the view.
    self.addBtn=[self addBtn];
    // Do any additional setup after loading the view.
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc] initWithCustomView:self.addBtn];
    [self.addBtn addTarget:self action:@selector(addBanner) forControlEvents:UIControlEventTouchUpInside];
}
-(UIButton *)addBtn
{
    if(!_addBtn){
        _addBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        _addBtn.frame=CGRectMake(0, 0, 60, 30);
        [_addBtn setTitle:YCTLocalizedTableString(@"mine.becomeCompany.add", @"Mine") forState:UIControlStateNormal];
        _addBtn.titleLabel.font=fontSize(14);
        [_addBtn setTitleColor:rgba(255,255,255,1) forState:UIControlStateNormal];
        _addBtn.layer.cornerRadius=2;
        _addBtn.layer.masksToBounds=YES;
        _addBtn.backgroundColor=rgba(0,198,255,1);
        
    }
    return _addBtn;
}
-(void)setupView{
    UIView *head=[[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 44)];
    head.backgroundColor=[UIColor whiteColor];
    
    UILabel *tip=[[UILabel alloc] init];
    tip.text=YCTLocalizedTableString(@"mine.becomeCompany.imgMax", @"Mine");
    tip.font=fontSize(16);
    tip.textColor=rgba(193,193,193,1);
    [head addSubview:tip];
    [tip mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(head.mas_centerY);
        make.left.equalTo(head.mas_left).offset(15);
    }];
    self.table.tableHeaderView=head;
    [self.table mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(44, 0, 0, 0));
    }];
}
-(UITableView *)table{
    if(!_table){
        _table=[[UITableView alloc] initWithFrame:CGRectMake(0, StatusBarHeight+54, 0, 0)];
        [self.view addSubview:_table];
        _table.separatorStyle=UITableViewCellSeparatorStyleNone;
        _table.rowHeight=UITableViewAutomaticDimension;//动态高度
        _table.estimatedRowHeight=130;//预估高度
        _table.delegate=self;
        _table.dataSource=self;
        _table.backgroundColor=[UIColor whiteColor];
        if (@available(iOS 15.0, *)) {
            _table.sectionHeaderTopPadding=0;
        }
    }
    return _table;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [YCTUserDataManager sharedInstance].userInfoModel.banners.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    SetBannerTableViewCell *cell=cell=[[SetBannerTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SetBannerTableViewCell"];
    YCTUserBannerItemModel * banner=[YCTUserDataManager sharedInstance].userInfoModel.banners[indexPath.row];
    NSURL *url=[NSURL URLWithString:banner.url];
    [cell.img sd_setImageWithURL:url completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        if(cell.height==0){
            CGFloat height=(WIDTH-30)*(image.size.height/image.size.width);
            cell.height=height;
            [self.table reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        }
    }];
    if(cell.height>0){
        [cell setUpUi];
        cell.delBtn.tag=indexPath.row;
        [cell.delBtn addTarget:self action:@selector(delBanner:) forControlEvents:UIControlEventTouchUpInside];
        cell.setTop.tag=indexPath.row;
        [cell.setTop addTarget:self action:@selector(setBannerTop:) forControlEvents:UIControlEventTouchUpInside];
    }
//    [cell.img sd_setImageWithURL:];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    return cell;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(void)setBannerTop:(UIButton *)btn{
    YCTUserBannerItemModel * banner=[YCTUserDataManager sharedInstance].userInfoModel.banners[btn.tag];
    [self topTheBanner:banner.bannerId];
}
-(void)delBanner:(UIButton *)btn{
    [UIView showAlertSheetWith:YCTLocalizedTableString(@"mine.becomeCompany.removeComfirm", @"Mine") clickAction:^{
        NSLog(@"ud:%ld",btn.tag);
        YCTUserBannerItemModel * banner=[YCTUserDataManager sharedInstance].userInfoModel.banners[btn.tag];
        [self deleteTheBanner:banner.bannerId];
    }];
  
}
- (void)deleteTheBanner:(NSString *)bannerId {
    [[YCTHud sharedInstance] showLoadingHud];
    [[[YCTApiDeleteBanner alloc] initWithBannerId:bannerId] startWithCompletionBlockWithSuccess:^(__kindof YCTBaseRequest * _Nonnull request) {
        [[YCTHud sharedInstance] hideHud];
        [self requestBanners:NO];
    } failure:^(__kindof YCTBaseRequest * _Nonnull request) {
        [[YCTHud sharedInstance] showDetailToastHud:request.getError];
    }];
}
- (void)requestBanners:(BOOL)needHud {
    if (needHud) {
        [[YCTHud sharedInstance] showLoadingHud];
    }
    [[[YCTApiGetMyBanner alloc] init] startWithCompletionBlockWithSuccess:^(__kindof YCTBaseRequest * _Nonnull request) {
        [[YCTUserDataManager sharedInstance] updateBanners:request.responseDataModel];
        if (needHud) {
            [[YCTHud sharedInstance] hideHud];
        }
        [self.table reloadData];
//        [self.collectionView reloadData];
    } failure:^(__kindof YCTBaseRequest * _Nonnull request) {
        if (needHud) {
            [[YCTHud sharedInstance] showDetailToastHud:request.getError];
        }
    }];
}
-(void)addBanner{
    YCTImagePickerViewController *vc = [[YCTImagePickerViewController alloc] initWithMaxImagesCount:1 delegate:self];
    [self presentViewController:vc animated:YES completion:NULL];
}
#pragma mark - YCTImagePickerViewControllerDelegate

- (void)imagePickerController:(YCTImagePickerViewController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos {
    if (photos.count) {
        NSData *imgData=UIImagePNGRepresentation(photos.firstObject);
        NSInteger length=[imgData length];
        NSLog(@"大小:%ld",length);
        if(length>1024*1024*2){
            [[YCTHud sharedInstance] showDetailToastHud:YCTLocalizedTableString(@"mine.becomeCompany.imgMax", @"Mine")];
            return;
        }
        [self uploadBannerImage:photos.firstObject];
    }
}
- (void)uploadBannerImage:(UIImage *)bannerImage {
    [[YCTHud sharedInstance] showLoadingHud];
    [[[YCTApiUpload alloc] initWithImage:bannerImage] doStartWithSuccess:^(YCTCOSUploaderResult * _Nullable result) {
        [self requestAddBanner:result.url image:bannerImage];
    } failure:^(NSString * _Nonnull errorString) {
        [[YCTHud sharedInstance] showDetailToastHud:errorString];
    }];
}
- (void)requestAddBanner:(NSString *)url image:(UIImage *)image {
    YCTApiAddBanner *api = [[YCTApiAddBanner alloc] initWithBannerUrl:url];
    [api startWithCompletionBlockWithSuccess:^(__kindof YCTBaseRequest * _Nonnull request) {
//        [[YCTHud sharedInstance] showSuccessHud:request.getMsg];
        [[YCTHud sharedInstance] hideHud];
        [self requestBanners:NO];
    } failure:^(__kindof YCTBaseRequest * _Nonnull request) {
        [[YCTHud sharedInstance] showDetailToastHud:request.getError];
    }];
}
- (void)topTheBanner:(NSString *)bannerId {
    [[YCTHud sharedInstance] showLoadingHud];
    [[[YCTApiSetBannerTop alloc] initWithBannerId:bannerId] startWithCompletionBlockWithSuccess:^(__kindof YCTBaseRequest * _Nonnull request) {
        [[YCTHud sharedInstance] hideHud];
        [self requestBanners:NO];
    } failure:^(__kindof YCTBaseRequest * _Nonnull request) {
        [[YCTHud sharedInstance] showDetailToastHud:request.getError];
    }];
}
@end
