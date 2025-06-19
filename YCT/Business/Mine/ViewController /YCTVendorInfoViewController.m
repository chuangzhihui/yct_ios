//
//  YCTVendorInfoViewController.m
//  YCT
//
//  Created by 木木木 on 2022/5/8.
//

#import "YCTVendorInfoViewController.h"
#import "YCTOtherPeopleInfoModel.h"
#import "CompanyInfoTableViewCell.h"
#import "CompanyTitleCell.h"
#import "SetBannerTableViewCell.h"
#import "YCTBecomeCompanyViewController.h"
@interface YCTVendorInfoViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *table;
@property (nonatomic, strong) UIButton *editButton;
@property (nonatomic, strong) YCTOtherPeopleInfoModel *otherModel;
@property (nonatomic, assign) BOOL isMine;
@property   (strong,nonatomic) UIView       *tableHeaderView;
@property  (strong,nonatomic)  UIImageView  *imageView;
@property  (strong,nonatomic)  YCTMineUserInfoModel  *userInfoModel;//自己的
@end

@implementation YCTVendorInfoViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self changeNavigationBarColor:UIColor.clearColor titleColor:UIColor.navigationBarTitleColor];
    if(self.isMine){
        self.userInfoModel=[YCTUserDataManager sharedInstance].userInfoModel;;
        [self.table reloadData];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self changeNavigationBarColor:UIColor.whiteColor titleColor:UIColor.navigationBarTitleColor];
}
- (instancetype)initWithOtherPeople:(YCTOtherPeopleInfoModel *)model {
    if (self = [super init]) {
        self.otherModel = model;
        self.isMine = NO;
        
    }
    return self;
}

- (instancetype)initWithMine {
    if (self = [super init]) {
        self.userInfoModel=[YCTUserDataManager sharedInstance].userInfoModel;
        self.isMine = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
   
}





- (void)setupView {
    if(self.isMine){
        self.editButton = ({
            UIButton *editButton = [UIButton buttonWithType:UIButtonTypeSystem];
            [editButton setImage:[[UIImage imageNamed:@"mine_vendorInfor_edit"] imageWithRenderingMode:(UIImageRenderingModeAlwaysOriginal)] forState:UIControlStateNormal];
            [editButton addTarget:self action:@selector(rightBarButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            [editButton.widthAnchor constraintEqualToConstant:22].active = YES;
            [editButton.heightAnchor constraintEqualToConstant:22].active = YES;
            editButton;
        });
        UIBarButtonItem *editItem = [[UIBarButtonItem alloc] initWithCustomView:self.editButton];
        self.navigationItem.rightBarButtonItem = editItem;
    }
    self.imageView.contentMode=UIViewContentModeScaleAspectFill;
    [self.tableHeaderView addSubview:self.imageView];
    self.table.tableHeaderView=self.tableHeaderView;
    [self.view addSubview:self.table];
    
    if(self.isMine && self.userInfoModel.userBg!=NULL && ![self.userInfoModel.userBg isEqual:@""]){
        [self.imageView sd_setImageWithURL:[NSURL URLWithString:self.userInfoModel.userBg]];
    }
    if(!self.isMine && self.otherModel.userBg!=NULL && ![self.otherModel.userBg isEqual:@""]){
        [self.imageView sd_setImageWithURL:[NSURL URLWithString:self.otherModel.userBg]];
    }
}
#pragma mark - UI
-(UIView *)tableHeaderView{
    if(!_tableHeaderView){
        _tableHeaderView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 100)];
    }
    return _tableHeaderView;
}
-(UIImageView *)imageView{
    if(!_imageView){
        _imageView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mine_mine_bg"]];
        _imageView.frame=CGRectMake(0, 0, WIDTH, 100);
    }
    return _imageView;
}
-(UITableView *)table{
    if(!_table){
        _table=[[UITableView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
        _table.separatorStyle=UITableViewCellSeparatorStyleNone;
        _table.rowHeight=UITableViewAutomaticDimension;//动态高度
        _table.estimatedRowHeight=130;//预估高度
        _table.delegate=self;
        _table.dataSource=self;
        _table.backgroundColor=[UIColor whiteColor];
        _table.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        if (@available(iOS 15.0, *)) {
            _table.sectionHeaderTopPadding=0;
        }
    }
    return _table;
}
#pragma mark - tableviewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(section==0){
        return 2;
    }else if(section==1){
        return 1;
    }
    return self.isMine?self.userInfoModel.banners.count:self.otherModel.banners.count;
}
//-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
//    if(section==0){
//        return 10;
//    }
//    return 0;
//}
//-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
//    UIView *view=[[UIView alloc] init];
//    view.backgroundColor=rgba(248,248,248,1);
//    return view;
//}
//-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    UIView *view=[[UIView alloc] init];
//    view.backgroundColor=[UIColor whiteColor];
//    view.layer.masksToBounds=YES;
//    view.layer.cornerRadius=20;
//    if(section==0){
//        UILabel *title=[[UILabel alloc] init];
//        title.font=[UIFont boldSystemFontOfSize:18];
//        title.textColor=rgba(51,51,51,1);
//        title.text=self.isMine?self.userInfoModel.companyName: self.otherModel.companyName;
//        [view addSubview:title];
//        [title mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(view.mas_left).offset(15);
//            make.centerY.equalTo(view.mas_centerY);
//        }];
//    }
//    return view;
//}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section==0){
        if(indexPath.row==0){
            CompanyTitleCell *cell=[[CompanyTitleCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CompanyTitleCell"];
            cell.title.text=self.isMine?self.userInfoModel.companyName: self.otherModel.companyName;
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            cell.backgroundColor=[UIColor whiteColor];
            return cell;
        }else{
            CompanyInfoTableViewCell *cell=[[CompanyInfoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CompanyInfoTableViewCell"];
//            cell.xinyong.attributedText=[self attributedStringWithTitle:YCTLocalizedTableString(@"mine.companyInfo.daima", @"Mine") content:self.isMine?self.userInfoModel.socialcode:self.otherModel.socialcode];
            cell.xinyong.text=YCTLocalizedTableString(@"mine.companyInfo.daima", @"Mine");
            
            cell.xinyongVal.text=self.isMine?self.userInfoModel.socialcode:self.otherModel.socialcode;
            cell.leixing.text=YCTLocalizedTableString(@"mine.companyInfo.leixing", @"Mine");
            cell.leixingVal.text=self.isMine?self.userInfoModel.companytype:self.otherModel.companytype;
            
            
//            cell.riqi.attributedText=[self attributedStringWithTitle:YCTLocalizedTableString(@"mine.companyInfo.riqi", @"Mine") content:self.isMine?self.userInfoModel.businessstart:self.otherModel.businessstart];
            cell.riqi.text=YCTLocalizedTableString(@"mine.companyInfo.riqi", @"Mine");
            cell.riqiVal.text=self.isMine?self.userInfoModel.businessstart:self.otherModel.businessstart;
            
            
//            cell.faren.attributedText=[self attributedStringWithTitle:YCTLocalizedTableString(@"mine.companyInfo.faren", @"Mine") content:self.isMine?self.userInfoModel.legalname:self.otherModel.legalname];
            cell.faren.text=YCTLocalizedTableString(@"mine.companyInfo.faren", @"Mine");
            cell.farenVal.text=self.isMine?self.userInfoModel.legalname:self.otherModel.legalname;
            
            
//            cell.ziben.attributedText=[self attributedStringWithTitle:YCTLocalizedTableString(@"mine.companyInfo.ziben", @"Mine") content:self.isMine?self.userInfoModel.registeredcapital:self.otherModel.registeredcapital];
            cell.ziben.text=YCTLocalizedTableString(@"mine.companyInfo.ziben", @"Mine");
            cell.zibenVal.text=self.isMine?self.userInfoModel.registeredcapital:self.otherModel.registeredcapital;
            
            
//            cell.diqu.attributedText=[self attributedStringWithTitle:YCTLocalizedTableString(@"mine.companyInfo.diqu", @"Mine") content:self.isMine?self.userInfoModel.locationStr:self.otherModel.locationStr];
            cell.diqu.text=YCTLocalizedTableString(@"mine.companyInfo.diqu", @"Mine");
            cell.diquVal.text=self.isMine?self.userInfoModel.locationStr:self.otherModel.locationStr;
            
            
//            cell.dizhi.attributedText=[self attributedStringWithTitle:YCTLocalizedTableString(@"mine.companyInfo.dizhi", @"Mine") content:self.isMine?self.userInfoModel.companyAddress:self.otherModel.companyAddress];
            cell.dizhi.text=YCTLocalizedTableString(@"mine.companyInfo.dizhi", @"Mine");
            cell.dizhiVal.text=self.isMine?self.userInfoModel.companyAddress:self.otherModel.companyAddress;
            
            
//            cell.jieshao.attributedText=[self attributedStringWithTitle:YCTLocalizedTableString(@"mine.companyInfo.jieshao", @"Mine") content:self.isMine?self.userInfoModel.companydetail:self.otherModel.companydetail];
            cell.jieshao.text=YCTLocalizedTableString(@"mine.companyInfo.jieshao", @"Mine");
            cell.jieshaoVal.text=self.isMine?self.userInfoModel.companydetail:self.otherModel.companydetail;
            
            
//            cell.contact.attributedText=[self attributedStringWithTitle:YCTLocalizedTableString(@"mine.companyInfo.lianxiren", @"Mine") content:self.isMine?self.userInfoModel.companyContact:self.otherModel.companyContact];
            cell.contact.text=YCTLocalizedTableString(@"mine.companyInfo.lianxiren", @"Mine");
            cell.contactVal.text=self.isMine?self.userInfoModel.companyContact:self.otherModel.companyContact;
            
            
            
//            cell.mobile.attributedText=[self attributedStringWithTitle:YCTLocalizedTableString(@"mine.companyInfo.mobile", @"Mine") content:self.isMine?self.userInfoModel.companyPhone:self.otherModel.companyPhone];
            cell.mobile.text=YCTLocalizedTableString(@"mine.companyInfo.mobile", @"Mine");
            cell.mobileVal.text=self.isMine?self.userInfoModel.companyPhone:self.otherModel.companyPhone;
            
            
            
//            cell.email.attributedText=[self attributedStringWithTitle:YCTLocalizedTableString(@"mine.companyInfo.email", @"Mine") content:self.isMine?self.userInfoModel.companyEmail:self.otherModel.companyEmail];
            cell.email.text=YCTLocalizedTableString(@"mine.companyInfo.email", @"Mine");
            cell.emailVal.text=self.isMine?self.userInfoModel.companyEmail:self.otherModel.companyEmail;
            
            
//            cell.website.attributedText=[self attributedStringWithTitle:YCTLocalizedTableString(@"mine.companyInfo.website", @"Mine") content:self.isMine?self.userInfoModel.companyWebSite:self.otherModel.companyWebSite];
            cell.website.text=YCTLocalizedTableString(@"mine.companyInfo.website", @"Mine");
            cell.websiteVal.text=self.isMine?self.userInfoModel.companyWebSite:self.otherModel.companyWebSite;
            
            
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            cell.backgroundColor=[UIColor whiteColor];
            return cell;
        }
    }else if(indexPath.section==1){
        CompanyTitleCell *cell=[[CompanyTitleCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CompanyTitleCell"];
        cell.title.text=YCTLocalizedTableString(@"mine.becomeCompany.jieshaoTitle", @"Mine");
        cell.title.textAlignment=NSTextAlignmentCenter;
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        cell.backgroundColor=[UIColor whiteColor];
        return cell;
    }else{
        SetBannerTableViewCell *cell=[[SetBannerTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SetBannerTableViewCell"];
        NSURL *url;
        if(self.isMine){
            YCTUserBannerItemModel * banner=self.userInfoModel.banners[indexPath.row];
            url=[NSURL URLWithString:banner.url];
        }else{
            url=[NSURL URLWithString:self.otherModel.banners[indexPath.row]];
        }
        [cell.img sd_setImageWithURL:url completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            if(cell.height==0){
                CGFloat height=(WIDTH-30)*(image.size.height/image.size.width);
                cell.height=height;
                [self.table reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            }
        }];
        cell.delBtn.hidden=YES;
        cell.setTop.hidden=YES;
        if(cell.height>0){
            [cell setUpUi];
        }
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        cell.backgroundColor=[UIColor whiteColor];
        return cell;
    }
    return nil;
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGPoint offset = scrollView.contentOffset;
    if (offset.y <= -91) {
        CGRect rect =self.tableHeaderView.frame;
        rect.origin.y = offset.y;
        if(offset.y<-91){
            rect.size.height =CGRectGetHeight(rect)-offset.y;
        }else{
            rect.size.height =CGRectGetHeight(rect)+[UIDevice vg_statusBarHeight];
        }
        self.imageView.frame = rect;
        self.tableHeaderView.clipsToBounds=NO;
    }
}
#pragma mark - Action

- (void)rightBarButtonClick:(UIButton *)sender {
    YCTBecomeCompanyViewController *vc=[[YCTBecomeCompanyViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}



#pragma mark - Private


- (NSAttributedString *)attributedStringWithTitle:(NSString *)title content:(NSString *)content {
    if (!content) {
        content = @"";
    } else {
        content = [NSString stringWithFormat:@"  %@", content];
    }
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 5;
    
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:title];
    [string setAttributes:@{
        NSForegroundColorAttributeName: UIColor.mainTextColor,
        NSFontAttributeName: [UIFont PingFangSCBold:14],
        NSParagraphStyleAttributeName: paragraphStyle,
    } range:(NSRange){0, title.length}];
    
    [string appendAttributedString:[[NSAttributedString alloc] initWithString:content attributes:@{
        NSForegroundColorAttributeName: UIColor.mainGrayTextColor,
        NSFontAttributeName: [UIFont PingFangSCMedium:14],
        NSParagraphStyleAttributeName: paragraphStyle,
    }]];
    return string.copy;
}















@end
