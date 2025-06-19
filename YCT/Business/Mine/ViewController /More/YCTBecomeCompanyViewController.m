//
//  YCTBecomeCompanyViewController.m
//  YCT
//
//  Created by 张大爷的 on 2022/7/9.
//

#import "YCTBecomeCompanyViewController.h"
#import "BecomeCompanyInputCell.h"
#import "YCTLocationManager.h"
#import "YCTImagePickerViewController.h"
#import "YCTGetLocationViewController.h"
#import "YCTDatePickerView.h"
#import "YCTMineEditLabelViewController.h"
#import "YCTChooseIndustryViewController.h"
#import "YCTBannerViewController.h"
#import "YCTApiUpgradeToVendor.h"
#import "YCTApiUpload.h"

#import "CompanyAuditApi.h"
#import "YCTPublishSettingBottomView.h"
#import "YCTApiAuthPay.h"
#import "YCTAuthPayModel.h"
#import "YCTPaypalViewController.h"
#import "YCTApiPayPalDoPay.h"
#import <AlipaySDK/AlipaySDK.h>

#import "YCTRootViewController.h"

@interface YCTBecomeCompanyViewController ()<YCTGetLocationViewControllerDelegate,UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,UITextFieldDelegate,UITextViewDelegate>
@property(nonatomic,strong)UITableView *table;
@property(nonatomic,strong)YCTApiUpgradeToVendor *api;
@property BOOL needUploadYY;
@property(nonatomic,strong)UIImage *YyImg;
@property BOOL needUploadDoor;
@property(nonatomic,strong)UIImage *doorImg;

@property(nonatomic,strong)UIButton *submitBtn;
@property(nonatomic,assign)BOOL isPay;
@end

@implementation YCTBecomeCompanyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.api=[[YCTApiUpgradeToVendor alloc] init];
    // Do any additional setup after loading the view.
    [self getIsPayData];
}
-(void)setupView{
//    self.title=YCTLocalizedTableString(@"mine.more.upgradeToVendor", @"Mine");
    
    [self.table mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    [self autoLocating];
    [[RACObserve([YCTUserDataManager sharedInstance], userInfoModel.userTags) takeUntil:self.rac_willDeallocSignal] subscribeNext:^(NSString * _Nullable x) {
        NSIndexPath *indexpath=[NSIndexPath indexPathForRow:2 inSection:0];
        BecomeCompanyInputCell *cell=[self.table cellForRowAtIndexPath:indexpath];
        if([x isEqual:@""]){
            cell.chooseTxt.text=YCTLocalizedTableString(@"mine.becomeCompany.companyTagsP", @"Mine");
            cell.chooseTxt.textColor=rgba(193,193,193,1);
        }else{
            cell.chooseTxt.text=x;
            cell.chooseTxt.textColor=rgba(51, 51, 51, 1);
        }
    }];
    [[RACObserve([YCTUserDataManager sharedInstance], userInfoModel.banners) takeUntil:self.rac_willDeallocSignal] subscribeNext:^(NSArray<YCTUserBannerItemModel *> *banners) {
        NSIndexPath *indexpath=[NSIndexPath indexPathForRow:19 inSection:0];
        BecomeCompanyInputCell *cell=[self.table cellForRowAtIndexPath:indexpath];
        cell.chooseTips.text=[NSString stringWithFormat:@"%ld/6",banners.count];
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
        UIView *head=[[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 90)];
        
        UILabel *title=[[UILabel alloc] init];
        title.textColor=[UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.00];
        title.font=[UIFont boldSystemFontOfSize:18];
        title.text=YCTLocalizedTableString(@"mine.more.upgradeToVendor", @"Mine");
        [head addSubview:title];
        [title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(head.mas_top).offset(15);
            make.left.equalTo(head.mas_left).offset(30);
        }];
        
        UILabel *secTitle=[[UILabel alloc] init];
        secTitle.text=[NSString stringWithFormat:@"(%@)",YCTLocalizedTableString(@"mine.userInfo.becomeCompany", @"Mine")];
        secTitle.font=fontSize(14);
        secTitle.textColor=rgba(193,193,193,1);
        [head addSubview:secTitle];
        
        [secTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(title.mas_centerY);
            make.left.equalTo(title.mas_right);
        }];
        
        UILabel *desc=[[UILabel alloc] init];
        desc.text=YCTLocalizedTableString(@"mine.becomeCompany.desc", @"Mine");
        desc.font=fontSize(14);
        desc.textColor=rgba(193,193,193,1);
        desc.numberOfLines=0;
        [head addSubview:desc];
        
        [desc mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(title.mas_left);
            make.top.equalTo(title.mas_bottom).offset(10);
            make.right.equalTo(head.mas_right).offset(-30);
        }];
        
        
        
        _table.tableHeaderView=head;
        
        
        UIView * foot=[[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 200)];
        
        UILabel *footDesc=[[UILabel alloc] init];
        footDesc.text=YCTLocalizedTableString(@"mine.becomeCompany.footTip", @"Mine");
        footDesc.font=fontSize(14);
        footDesc.textColor=rgba(193,193,193,1);
        footDesc.numberOfLines=0;
        [foot addSubview:footDesc];
       
        
        UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
        
        [btn setTitle:YCTLocalizedTableString(@"mine.becomeCompany.submit", @"Mine") forState:UIControlStateNormal];
        btn.layer.masksToBounds=YES;
        btn.layer.cornerRadius=25;
//        YCTMineUserInfoModel *userInfoModel=[YCTUserDataManager sharedInstance].userInfoModel;
//        if(userInfoModel.status==0){
//           
//            //审核中
//            btn.backgroundColor=rgba(239,239,239,1);
//            [btn setTitleColor:rgba(193,193,193,1) forState:UIControlStateNormal];
//        }else{
//            btn.backgroundColor=rgba(0,198,255,1);
//            [btn setTitleColor:rgba(255,255,255,1) forState:UIControlStateNormal];
//            [btn addTarget:self action:@selector(submitRequest) forControlEvents:UIControlEventTouchUpInside];
//        }
        btn.backgroundColor=rgba(0,198,255,1);
        [btn setTitleColor:rgba(255,255,255,1) forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(submitRequest) forControlEvents:UIControlEventTouchUpInside];
       
        btn.titleLabel.font=[UIFont boldSystemFontOfSize:16];
        self.submitBtn = btn;
        [foot addSubview:btn];
        
        [footDesc mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(foot.mas_top).offset(10);
            make.left.equalTo(foot.mas_left).offset(30);
            make.right.equalTo(foot.mas_right).offset(-30);
        }];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.sizeOffset(CGSizeMake((WIDTH-60), 50));
            make.centerX.equalTo(foot.mas_centerX);
            make.top.equalTo(footDesc.mas_bottom).offset(20);
           
        }];
        
        _table.tableFooterView=foot;
    }
    return _table;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 20;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger type=1;
    if(indexPath.row==0 || indexPath.row==3 || indexPath.row==6 || indexPath.row==7 || indexPath.row==8 || indexPath.row==9 || indexPath.row==11 || (indexPath.row>=15 && indexPath.row<19)){
        type=1;
    }else if(indexPath.row==1 || indexPath.row==14){
        type=2;
    }else if(indexPath.row==2  || indexPath.row==5  || indexPath.row==10){
        type=3;
    }else if(indexPath.row==12 || indexPath.row==13){
        type=4;
    }else if(indexPath.row==4){
        type=5;
    }else if(indexPath.row==19){
        type=6;
    }
    YCTMineUserInfoModel *userInfoModel=[YCTUserDataManager sharedInstance].userInfoModel;
    
    NSString *identifier=[NSString stringWithFormat:@"BecomeCompanyInputCell%ld",(long)indexPath.row];
    BecomeCompanyInputCell *cell=[tableView dequeueReusableCellWithIdentifier:identifier];
    BOOL isInit=NO;
    if(!cell){
        isInit=YES;
        cell=[[BecomeCompanyInputCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier withType:type];
    }
    
    if(indexPath.row==0){
        cell.title.text=YCTLocalizedTableString(@"mine.becomeCompany.companyName", @"Mine");
        cell.input.placeholder=YCTLocalizedTableString(@"mine.becomeCompany.companyNameP", @"Mine");
      
        //公司名称
        if(![userInfoModel.companyName isEqualToString:@""] && isInit){
            cell.input.text=userInfoModel.companyName;
            self.api.companyName=userInfoModel.companyName;
        }
       
    }else if(indexPath.row==1){
        cell.title.text=YCTLocalizedTableString(@"mine.becomeCompany.companyprofile", @"Mine");
        cell.textViewPlaceholder.text=YCTLocalizedTableString(@"mine.becomeCompany.companyprofileP", @"Mine");
        
        cell.maxLength=50;
        //公司简介
        if(![userInfoModel.introduce isEqualToString:@""] && userInfoModel.introduce!=NULL && isInit){
            cell.textView.text=userInfoModel.introduce;
            self.api.introduce=userInfoModel.introduce;
        }
    }else if(indexPath.row==2){
        cell.title.text=YCTLocalizedTableString(@"mine.becomeCompany.companyTags", @"Mine");
        if([userInfoModel.userTags isEqual:@""]){
            cell.chooseTxt.text=YCTLocalizedTableString(@"mine.becomeCompany.companyTagsP", @"Mine");
            cell.chooseTxt.textColor=rgba(193,193,193,1);
        }else{
            cell.chooseTxt.text=[YCTUserDataManager sharedInstance].userInfoModel.userTags;
            cell.chooseTxt.textColor=rgba(51, 51, 51, 1);
        }
        
    }else if(indexPath.row==3){
        cell.title.text=YCTLocalizedTableString(@"mine.becomeCompany.companyProduct", @"Mine");
        cell.input.placeholder=YCTLocalizedTableString(@"mine.becomeCompany.companyProductP", @"Mine");
        //主营商品
        if(![userInfoModel.direction isEqualToString:@""] && isInit){
            cell.input.text=userInfoModel.direction;
            self.api.direction=userInfoModel.direction;
        }
    }else if(indexPath.row==4){
        cell.title.text=YCTLocalizedTableString(@"mine.becomeCompany.companyIndustry", @"Mine");
        [cell.btn1 addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chooseFirst)]];
        [cell.btn2 addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chooseSec)]];
        [cell.btn3 addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chooseThird)]];
//        [cell.btn1 addTarget:self action:@selector(chooseFirst) forControlEvents:UIControlEventTouchUpInside];
//        [cell.btn2 addTarget:self action:@selector(chooseSec) forControlEvents:UIControlEventTouchUpInside];
//        [cell.btn3 addTarget:self action:@selector(chooseThird) forControlEvents:UIControlEventTouchUpInside];
        if(![userInfoModel.goodstypef isEqualToString:@""] && userInfoModel.goodstypef!=NULL && isInit){
            cell.btn1.title.font=fontSize(12);
            cell.btn1.title.textColor=rgba(51, 51, 51, 1);
            cell.btn1.title.text=userInfoModel.goodstypef;
            self.api.goodstypef=userInfoModel.goodstypef;
            self.api.goodstypefid=userInfoModel.goodstypefid;
        }
        if(![userInfoModel.goodstypes isEqualToString:@""] && userInfoModel.goodstypes!=NULL && isInit){
            cell.btn2.title.font=fontSize(12);
            cell.btn2.title.textColor=rgba(51, 51, 51, 1);
            cell.btn2.title.text=userInfoModel.goodstypes;
            self.api.goodstypes=userInfoModel.goodstypes;
            self.api.goodstypesid=userInfoModel.goodstypesid;
        }
        if(![userInfoModel.goodstypet isEqualToString:@""] && userInfoModel.goodstypet!=NULL && isInit){
            cell.btn3.title.font=fontSize(12);
            cell.btn3.title.textColor=rgba(51, 51, 51, 1);
            cell.btn3.title.text=userInfoModel.goodstypet;
            self.api.goodstypet=userInfoModel.goodstypet;
        }
//        cell.chooseTxt.text=YCTLocalizedTableString(@"mine.becomeCompany.companyIndustryP", @"Mine");
    }else if(indexPath.row==5){
        cell.title.text=YCTLocalizedTableString(@"mine.becomeCompany.companyLocation", @"Mine");
        cell.chooseTxt.text=YCTLocalizedTableString(@"mine.becomeCompany.companyLocationP", @"Mine");
        if(![userInfoModel.locationStr isEqualToString:@""] && userInfoModel.locationStr!=NULL){
            cell.chooseTxt.text=userInfoModel.locationStr;
            cell.chooseTxt.textColor=rgba(51, 51, 51, 1);
            self.api.locationId=userInfoModel.locationid;
        }
    }else if(indexPath.row==6){
        cell.title.text=YCTLocalizedTableString(@"mine.becomeCompany.companyAddress", @"Mine");
        cell.input.placeholder=YCTLocalizedTableString(@"mine.becomeCompany.companyAddressP", @"Mine");
        //公司地址
        if(![userInfoModel.companyAddress isEqualToString:@""] && userInfoModel.companyAddress!=NULL && isInit){
            cell.input.text=userInfoModel.companyAddress;
            self.api.companyAddress=userInfoModel.companyAddress;
        }
    }else if(indexPath.row==7){
        cell.title.text=YCTLocalizedTableString(@"mine.becomeCompany.companyCreditcode", @"Mine");
        cell.input.placeholder=YCTLocalizedTableString(@"mine.becomeCompany.companyCreditcodeP", @"Mine");
        //信用代码
        if(![userInfoModel.socialcode isEqualToString:@""] && userInfoModel.socialcode!=NULL && isInit){
            cell.input.text=userInfoModel.socialcode;
            self.api.socialcode=userInfoModel.socialcode;
        }
        
    }else if(indexPath.row==8){
        cell.title.text=YCTLocalizedTableString(@"mine.becomeCompany.companyType", @"Mine");
        cell.input.placeholder=YCTLocalizedTableString(@"mine.becomeCompany.companyType", @"Mine");
        //公司类型
        if(![userInfoModel.companytype isEqualToString:@""] && userInfoModel.companytype!=NULL && isInit){
            cell.input.text=userInfoModel.companytype;
            self.api.companytype=userInfoModel.companytype;
        }
    }else if(indexPath.row==9){
        cell.title.text=YCTLocalizedTableString(@"mine.becomeCompany.companyRepresentative", @"Mine");
        cell.input.placeholder=YCTLocalizedTableString(@"mine.becomeCompany.companyRepresentativeP", @"Mine");
        //法人代表
        if(![userInfoModel.legalname isEqualToString:@""] && userInfoModel.legalname!=NULL && isInit){
            cell.input.text=userInfoModel.legalname;
            self.api.legalname=userInfoModel.legalname;
        }
    }else if(indexPath.row==10){
        cell.title.text=YCTLocalizedTableString(@"mine.becomeCompany.companyDate", @"Mine");
        cell.chooseTxt.text=YCTLocalizedTableString(@"mine.becomeCompany.companyDateP", @"Mine");
        //成立日期
        if(![userInfoModel.businessstart isEqualToString:@""] && userInfoModel.businessstart!=NULL){
            cell.chooseTxt.text=userInfoModel.businessstart;
            cell.chooseTxt.textColor=rgba(51, 51, 51, 1);
            self.api.businessstart=userInfoModel.businessstart;
        }
    }else if(indexPath.row==11){
        cell.title.text=YCTLocalizedTableString(@"mine.becomeCompany.companyMoney", @"Mine");
        cell.input.placeholder=YCTLocalizedTableString(@"mine.becomeCompany.companyMoneyP", @"Mine");
        //注册资本
        if(![userInfoModel.registeredcapital isEqualToString:@""] && userInfoModel.registeredcapital!=NULL && isInit){
            cell.input.text=userInfoModel.registeredcapital;
            self.api.registeredcapital=userInfoModel.registeredcapital;
        }
    }else if(indexPath.row==12){
        cell.title.text=YCTLocalizedTableString(@"mine.becomeCompany.companylicense", @"Mine");
        if(![userInfoModel.businessLicense isEqualToString:@""] && userInfoModel.businessLicense!=NULL && isInit){
            cell.needUpload=NO;
            self.api.businessLicense=userInfoModel.businessLicense;
            [cell.uploadImg sd_setImageWithURL:[NSURL URLWithString:userInfoModel.businessLicense]];
            cell.uploadView.hidden=YES;
            cell.uploadImg.hidden=NO;
        }
    }else if(indexPath.row==13){
        cell.title.text=YCTLocalizedTableString(@"mine.becomeCompany.companyPhoto", @"Mine");
        if(![userInfoModel.doorHeadPic isEqualToString:@""] && userInfoModel.doorHeadPic!=NULL && isInit){
            self.api.doorHeadPic=userInfoModel.doorHeadPic;
            cell.needUpload=NO;
            [cell.uploadImg sd_setImageWithURL:[NSURL URLWithString:userInfoModel.doorHeadPic]];
            cell.uploadView.hidden=YES;
            cell.uploadImg.hidden=NO;
            
        }
    }else if(indexPath.row==14){
        cell.title.text=YCTLocalizedTableString(@"mine.becomeCompany.companyDetails", @"Mine");
        cell.textViewPlaceholder.text=YCTLocalizedTableString(@"mine.becomeCompany.companyDetailsP", @"Mine");
        cell.maxLength=1000;
        if(![userInfoModel.companydetail isEqualToString:@""] && userInfoModel.companydetail!=NULL && isInit){
            cell.textView.text=userInfoModel.companydetail;
            self.api.companydetail=userInfoModel.companydetail;
        }
    }else if(indexPath.row==15){
        cell.title.text=YCTLocalizedTableString(@"mine.becomeCompany.companyContact", @"Mine");
        cell.input.placeholder=YCTLocalizedTableString(@"mine.becomeCompany.companyContactP", @"Mine");
        //联系人
        if(![userInfoModel.companyContact isEqualToString:@""] && userInfoModel.companyContact!=NULL && isInit){
            cell.input.text=userInfoModel.companyContact;
            self.api.companyContact=userInfoModel.companyContact;
        }
    }else if(indexPath.row==16){
        cell.title.text=YCTLocalizedTableString(@"mine.becomeCompany.companyContactMobile", @"Mine");
        cell.input.placeholder=YCTLocalizedTableString(@"mine.becomeCompany.companyContactMobile", @"Mine");
        //联系人电话
        if(![userInfoModel.companyPhone isEqualToString:@""] && userInfoModel.companyPhone!=NULL && isInit){
            cell.input.text=userInfoModel.companyPhone;
            self.api.companyPhone=userInfoModel.companyPhone;
        }
    }else if(indexPath.row==17){
        cell.title.text=YCTLocalizedTableString(@"mine.becomeCompany.companyWeb", @"Mine");
        cell.input.placeholder=YCTLocalizedTableString(@"mine.becomeCompany.companyWebP", @"Mine");
        //官网
        if(![userInfoModel.companyWebSite isEqualToString:@""] && userInfoModel.companyWebSite!=NULL && isInit){
            cell.input.text=userInfoModel.companyWebSite;
            self.api.companyWebSite=userInfoModel.companyWebSite;
        }
    }else if(indexPath.row==18){
        cell.title.text=YCTLocalizedTableString(@"mine.becomeCompany.companyEmail", @"Mine");
        cell.input.placeholder=YCTLocalizedTableString(@"mine.becomeCompany.companyEmailP", @"Mine");
        if(![userInfoModel.companyEmail isEqualToString:@""] && userInfoModel.companyEmail!=NULL && isInit){
            cell.input.text=userInfoModel.companyEmail;
            self.api.companyEmail=userInfoModel.companyEmail;
        }
    }else if(indexPath.row==19){
        cell.title.text=YCTLocalizedTableString(@"mine.becomeCompany.companyPic", @"Mine");
        cell.chooseTxt.text=YCTLocalizedTableString(@"mine.becomeCompany.companyPicP", @"Mine");
        cell.chooseTips.text=[NSString stringWithFormat:@"%ld/6",userInfoModel.banners.count];
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    NSArray * requiredIndex=[NSArray arrayWithObjects:@"0",@"1",@"3",@"5",@"6",@"12",@"13",@"15",@"18", nil];
    cell.start.hidden=![requiredIndex containsObject:[NSString stringWithFormat:@"%ld",indexPath.row]];
//    if(indexPath.row>16 || indexPath.row<15){
//        cell.start.hidden=YES;
//    }else{
//        cell.start.hidden=NO;
//    }
    if(type==1){
        cell.input.tag=indexPath.row;
        cell.input.delegate=self;
    }
    if(type==2){
        cell.textView.delegate=self;
        cell.textView.tag=indexPath.row;
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row==12 || indexPath.row==13){
        //上传营业执照12 13 厂区照片
        @weakify(self);
        YCTImagePickerViewController *vc = [[YCTImagePickerViewController alloc] initWithMaxImagesCount:1 didFinishPickingPhotos:^(NSArray<UIImage *> * _Nonnull photos) {
            @strongify(self);
            BecomeCompanyInputCell *cell=[self.table cellForRowAtIndexPath:indexPath];
            cell.uploadView.hidden=YES;
            cell.uploadImg.hidden=NO;
            cell.uploadImg.image=[photos firstObject];
            cell.imgUrl=@"";
            if(indexPath.row==12){
                self.api.businessLicense=@"";
                self.needUploadYY=YES;
                self.YyImg=[photos firstObject];
            }else if(indexPath.row==13){
                self.api.doorHeadPic=@"";
                self.needUploadDoor=YES;
                self.doorImg=[photos firstObject];
            }
            cell.needUpload=YES;
//            self.doorHeadResult = nil;
//            self.doorHeadImageView.image = [photos firstObject];
        }];
        [vc configCropSize:(CGSize){Iphone_Width, ceil((210.0 / 375.0) * Iphone_Width)}];
        [self presentViewController:vc animated:YES completion:NULL];
        return;
    }else if(indexPath.row==5){
        //选择地区
        YCTGetLocationViewController *vc = [[YCTGetLocationViewController alloc] initWithDelegate:self];
        [self.navigationController pushViewController:vc animated:YES];
    }else if(indexPath.row==10){
        YCTDatePickerView *datePickerView = [[YCTDatePickerView alloc] init];
        datePickerView.confirmClickBlock = ^(NSDate * _Nonnull date) {
            BecomeCompanyInputCell *cell=[self.table cellForRowAtIndexPath:indexPath];
            cell.chooseTxt.text=[date dateToStringWithFormate:@"yyyy-MM-dd"];
            cell.chooseTxt.textColor=rgba(51, 51, 51, 1);
//            self.foundDateTextField.text = [date dateToStringWithFormate:@"yyyy-MM-dd"];
        };
        [datePickerView yct_show];
    }else if(indexPath.row==2){
        YCTMineEditLabelViewController *vc = [[YCTMineEditLabelViewController alloc] init];
    
        if ([YCTUserDataManager sharedInstance].userInfoModel.userTags.length == 0) {
            vc.orginalLabels = nil;
        } else {
            vc.orginalLabels = [[YCTUserDataManager sharedInstance].userInfoModel.userTags componentsSeparatedByString:@","];
        }
        [self.navigationController pushViewController:vc animated:YES];
    }else if(indexPath.row==19){
        YCTBannerViewController *vc=[[YCTBannerViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
  
}
- (void)autoLocating {
    [[YCTLocationManager sharedInstance] requestLocationWithCompletion:^(YCTLocationResultModel * _Nullable model, NSError * _Nullable error) {
        if (model) {
            NSLog(@"address:%@",model.formattedAddress);
            NSIndexPath * path=[NSIndexPath indexPathForRow:6 inSection:0];
            BecomeCompanyInputCell *cell=[self.table cellForRowAtIndexPath:path];
            if([cell.input.text isEqualToString:@""]){
                cell.input.text=model.formattedAddress;
            }
            self.api.locationaddress=model.formattedAddress;
            YCTMineUserInfoModel *userInfoModel=[YCTUserDataManager sharedInstance].userInfoModel;
            if([userInfoModel.companyAddress isEqualToString:@""] || userInfoModel.companyAddress==NULL){
                self.api.companyAddress=model.formattedAddress;
            }
//            self.detailAddressTextField.text = model.formattedAddress;
        } else {
            [[YCTHud sharedInstance] showDetailToastHud:error.localizedDescription];
        }
    }];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if(scrollView.contentOffset.y>100){
        self.title=YCTLocalizedTableString(@"mine.more.upgradeToVendor", @"Mine");
    }else{
        self.title=@"";
    }
}
- (void)locationDidSelectWithAll:(NSArray<YCTMintGetLocationModel *> *)locations
                        lastPrev:(YCTMintGetLocationModel *)lastPrev
                            last:(YCTMintGetLocationModel *)last {
    NSString *address=@"";
    for(YCTMintGetLocationModel * model in locations){
        if([address isEqual:@""]){
            address=model.name;
        }else{
            address=[NSString stringWithFormat:@"%@/%@",address,model.name];
        }
    }
    NSIndexPath * path=[NSIndexPath indexPathForRow:5 inSection:0];
    BecomeCompanyInputCell *cell=[self.table cellForRowAtIndexPath:path];
    cell.chooseTxt.text=address;
    cell.chooseTxt.textColor=rgba(51, 51, 51, 1);
    self.api.locationId=last.cid;
    
//    self.areaTextField.text = last.name;
//    self.locationId = last.cid;
}
-(void)chooseFirst{
    YCTChooseIndustryViewController *vc=[[YCTChooseIndustryViewController alloc] initWithPid:@"0" onChoosed:^(YCTMintGetLocationModel * _Nonnull data) {
        NSIndexPath * path=[NSIndexPath indexPathForRow:4 inSection:0];
        BecomeCompanyInputCell *cell=[self.table cellForRowAtIndexPath:path];
        cell.btn1.title.text=data.name;
        cell.btn1.title.textColor=rgba(51, 51, 51, 1);
        self.api.goodstypef=data.name;
        self.api.goodstypesid=data.cid;
        if(![self.api.goodstypes isEqualToString:@""]){
           
            self.api.goodstypes=@"";
            self.api.goodstypefid=@"";
            self.api.goodstypet=@"";
            cell.btn2.title.text=YCTLocalizedTableString(@"mine.becomeCompany.select", @"Mine");
            cell.btn2.title.textColor=rgba(193,193,193,1);
            cell.btn3.title.text=YCTLocalizedTableString(@"mine.becomeCompany.select", @"Mine");
            cell.btn3.title.textColor=rgba(193,193,193,1);
        }
        
        
    }];
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)chooseSec{
    NSIndexPath * path=[NSIndexPath indexPathForRow:4 inSection:0];
    BecomeCompanyInputCell *cell=[self.table cellForRowAtIndexPath:path];
    if ([self.api.goodstypef isEqual:@""] || [self.api.goodstypef isEqual:@"0"]) {
            [[YCTHud sharedInstance] showDetailToastHud:YCTLocalizedTableString(@"mine.becomeCompany.chooseFirst", @"Mine")];
        return;
        }
  
    YCTChooseIndustryViewController *vc=[[YCTChooseIndustryViewController alloc] initWithPid:self.api.goodstypesid onChoosed:^(YCTMintGetLocationModel * _Nonnull data) {
        NSLog(@"2选择回调:%@",data.name);
        NSIndexPath * path=[NSIndexPath indexPathForRow:4 inSection:0];
        BecomeCompanyInputCell *cell=[self.table cellForRowAtIndexPath:path];
       
        cell.btn2.title.textColor=rgba(51, 51, 51, 1);
        cell.btn2.title.text=data.name;
        self.api.goodstypes=data.name;
        self.api.goodstypefid=data.cid;
        
        if(![self.api.goodstypet isEqualToString:@""]){
           
            self.api.goodstypet=@"";
            cell.btn3.title.text=YCTLocalizedTableString(@"mine.becomeCompany.select", @"Mine");
            cell.btn3.title.textColor=rgba(193,193,193,1);
           
        }
    }];
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)chooseThird{
    NSLog(@"id:%@",self.api.goodstypefid);
    if ([self.api.goodstypefid isEqual:@""] || [self.api.goodstypefid isEqual:@"0"]) {
            [[YCTHud sharedInstance] showDetailToastHud:YCTLocalizedTableString(@"mine.becomeCompany.chooseFirst", @"Mine")];
        return;
        }
  
    YCTChooseIndustryViewController *vc=[[YCTChooseIndustryViewController alloc] initWithPid:self.api.goodstypefid onChoosed:^(YCTMintGetLocationModel * _Nonnull data) {
        NSLog(@"3选择回调:%@",data.name);
        NSIndexPath * path=[NSIndexPath indexPathForRow:4 inSection:0];
        BecomeCompanyInputCell *cell=[self.table cellForRowAtIndexPath:path];
        self.api.goodstypet=data.name;
        cell.btn3.title.textColor=rgba(51, 51, 51, 1);
        cell.btn3.title.text=data.name;
    }];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)submitRequest {
//    //判断是否需要上传图片
//    NSIndexPath * path=[NSIndexPath indexPathForRow:12 inSection:0];
//    BecomeCompanyInputCell *cell=[self.table cellForRowAtIndexPath:path];
    if(self.needUploadYY){
        //上传营业执照
       // [[YCTHud sharedInstance] showDetailToastHud:@"营业执照上传开始"];
        [self requestForUploadPhotoWithCompletion:1 callBack:^(BOOL success) {
            if(success){
                //[[YCTHud sharedInstance] showDetailToastHud:@"营业执照上传成功"];
                [self submitRequest];
            }else{
                [[YCTHud sharedInstance] showDetailToastHud:@"营业执照上传失败"];
            }
            
        }];
        return;
    }
//    NSIndexPath * path1=[NSIndexPath indexPathForRow:13 inSection:0];
//    BecomeCompanyInputCell *cell1=[self.table cellForRowAtIndexPath:path1];
//
    if(self.needUploadDoor){
        //上传营业执照
      //  [[YCTHud sharedInstance] showDetailToastHud:@"厂区图片上传开始"];
        [self requestForUploadPhotoWithCompletion:2 callBack:^(BOOL success) {
            if(success){
            //    [[YCTHud sharedInstance] showDetailToastHud:@"厂区图片上传成功"];
                [self submitRequest];
            }else{
                [[YCTHud sharedInstance] showDetailToastHud:@"厂区图片上传失败"];
            }
            
        }];
        return;
    }
    if([self.api.companyName isEqualToString:@""] || self.api.companyName==NULL){
        NSLog(@"%@-%@",self.api.businessLicense,self.api.doorHeadPic);
        [[YCTHud sharedInstance] showDetailToastHud:YCTLocalizedTableString(@"mine.becomeCompany.companyNameP", @"Mine")];
        return;
    }
    if([self.api.introduce isEqualToString:@""] || self.api.introduce==NULL){
        NSLog(@"简介:%@",self.api.introduce);
        [[YCTHud sharedInstance] showDetailToastHud:YCTLocalizedTableString(@"mine.becomeCompany.companyprofileP", @"Mine")];
        return;
    }
    if([self.api.direction isEqualToString:@""] || self.api.direction==NULL){
        [[YCTHud sharedInstance] showDetailToastHud:YCTLocalizedTableString(@"mine.becomeCompany.companyProductP", @"Mine")];
        return;
    }
//    if([self.api.goodstypef isEqualToString:@""] || self.api.goodstypef==NULL){
//        [[YCTHud sharedInstance] showDetailToastHud:YCTLocalizedTableString(@"mine.becomeCompany.companyIndustryP", @"Mine")];
//        return;
//    }
    if([self.api.locationId isEqualToString:@""] || self.api.locationId==NULL){
        [[YCTHud sharedInstance] showDetailToastHud:YCTLocalizedTableString(@"mine.becomeCompany.companyLocationP", @"Mine")];
        return;
    }
    if([self.api.companyAddress isEqualToString:@""] || self.api.companyAddress==NULL){
        [[YCTHud sharedInstance] showDetailToastHud:YCTLocalizedTableString(@"mine.becomeCompany.companyAddressP", @"Mine")];
        return;
    }
//    if([self.api.companytype isEqualToString:@""] || self.api.companytype==NULL){
//        [[YCTHud sharedInstance] showDetailToastHud:YCTLocalizedTableString(@"mine.becomeCompany.companyTypeP", @"Mine")];
//        return;
//    }
    if([self.api.businessLicense isEqualToString:@""] || self.api.businessLicense==NULL){
        [[YCTHud sharedInstance] showDetailToastHud:YCTLocalizedTableString(@"mine.becomeCompany.companylicenseP", @"Mine")];
        return;
    }
    if([self.api.doorHeadPic isEqualToString:@""] || self.api.doorHeadPic==NULL){
        [[YCTHud sharedInstance] showDetailToastHud:YCTLocalizedTableString(@"mine.becomeCompany.companyPhotoP", @"Mine")];
        return;
    }
//    if([self.api.companydetail isEqualToString:@""] || self.api.companydetail==NULL){
//        [[YCTHud sharedInstance] showDetailToastHud:YCTLocalizedTableString(@"mine.becomeCompany.companyDetailsP", @"Mine")];
//        return;
//    }
    if([self.api.companyContact isEqualToString:@""] || self.api.companyContact==NULL){
        [[YCTHud sharedInstance] showDetailToastHud:YCTLocalizedTableString(@"mine.becomeCompany.companyContactP", @"Mine")];
        return;
    }
//    if([self.api.companyPhone isEqualToString:@""] || self.api.companyPhone==NULL){
//        [[YCTHud sharedInstance] showDetailToastHud:YCTLocalizedTableString(@"mine.becomeCompany.companyContactMobileP", @"Mine")];
//        return;
//    }
//    if([self.api.companyWebSite isEqualToString:@""] || self.api.companyWebSite==NULL){
//        [[YCTHud sharedInstance] showDetailToastHud:YCTLocalizedTableString(@"mine.becomeCompany.companyWebP", @"Mine")];
//        return;
//    }
    if([self.api.companyEmail isEqualToString:@""] || self.api.companyEmail==NULL){
        [[YCTHud sharedInstance] showDetailToastHud:YCTLocalizedTableString(@"mine.becomeCompany.companyEmailP", @"Mine")];
        return;
    }
    [[YCTHud sharedInstance] showLoadingHud];
    [self.api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        [[YCTHud sharedInstance] hideHud];
        [[YCTUserManager sharedInstance] updateUserInfo];
        if (self.isPay == false) {
            [[YCTHud sharedInstance] showDetailToastHud:YCTLocalizedTableString(@"mine.upgradeToVendor.submit.alert", @"Mine")];
            [[YCTHud sharedInstance] hideHudAfterDelay:kDefaultDelayTimeInterval completion:^{
                [self.navigationController popToRootViewControllerAnimated:YES];
            }];
        }
    } failure:^(__kindof YCTBaseRequest * _Nonnull request) {
        [[YCTHud sharedInstance] hideHud];
        [[YCTUserManager sharedInstance] updateUserInfo];
        if (self.isPay == false) {
            [[YCTHud sharedInstance] showDetailToastHud:YCTLocalizedTableString(@"mine.upgradeToVendor.submit.alert", @"Mine")];
            [[YCTHud sharedInstance] hideHudAfterDelay:kDefaultDelayTimeInterval completion:^{
                [self.navigationController popToRootViewControllerAnimated:YES];
            }];
        }
//        NSLog(@"info:%@_----res:%@",[request description],request.responseString);
//        [[YCTHud sharedInstance] showDetailToastHud:request.getError];
        
    }];
    
    if(self.isPay==true){
    //                [[YCTHud sharedInstance] showDetailToastHud:YCTLocalizedTableString(@"mine.upgradeToVendor.submit.buyunxu", @"Mine")];
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
        YCTPublishSettingBottomView *view = [YCTPublishSettingBottomView settingViewIconWithDefaultIndex:index title:YCTLocalizedTableString(@"mine.payment.place", @"Mine") titles:titles icons:subIcons subtitles:subtitles  selectedHandler:^(NSString * _Nullable title, NSInteger index) {
            NSLog(@"回调:%ld",index);
            YCTApiAuthPay *api=[[YCTApiAuthPay alloc] initWithType:[NSString stringWithFormat:@"%ld",(long)index+1]];
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
                        NSLog(@"支付结果:%@",resultDic);
                          NSString *status=[NSString stringWithFormat:@"%@",resultDic[@"resultStatus"]];
                          NSLog(@"status:%@",[resultDic objectForKey:@"resultStatus"]);
                        if ([status isEqualToString:@"9000"]) {
                            [self onAuthPaySuccess];
                        }
                    }];
                }
            } failure:^(__kindof YCTBaseRequest * _Nonnull request) {
                NSLog(@"请求失败:%@%@",request.requestUrl,[request getError]);
                [[YCTHud sharedInstance] hideHud];
                [[YCTHud sharedInstance] showToastHud:@"获取支付失败"];
            }];
        }];
        [view yct_show];
    }
    
}
-(void) onAuthPaySuccess{
    NSLog(@"支付成功同志");
    [[YCTHud sharedInstance] showSuccessHud:@"success"];
    [[YCTRootViewController sharedInstance] backToHome];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"BecomeCompanyPaySuccess" object:nil];
//    [self.navigationController popToRootViewControllerAnimated:YES];
    
//
    
    
}
- (void)getIsPayData {
    // 检查是否付费
    CompanyAuditApi * api = [[CompanyAuditApi alloc] init];
    @weakify(self);
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        @strongify(self);
        CompanyAuditModel *model = api.responseDataModel;
        self.isPay = model.isPay;
//        if (self.isPay == true) {
//            self.submitBtn.backgroundColor=rgba(0,198,255,1);
//            [self.submitBtn setTitleColor:rgba(255,255,255,1) forState:UIControlStateNormal];
//            [self.submitBtn addTarget:self action:@selector(submitRequest) forControlEvents:UIControlEventTouchUpInside];
//        }
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSLog(@"请求主页数据失败：%@",request.requestUrl);
        NSLog(@"请求主页数据失败：%@",request.responseString);
    }];
}


-(void)textFieldDidChangeSelection:(UITextField *)textField{
    NSInteger row=textField.tag;
    NSString *text=textField.text;
    if(row==0){
        self.api.companyName=text;
    }else if(row==3){
        //主营产品
        self.api.direction=text;
    }else if(row==6){
        //公司地址
        self.api.companyAddress=text;
    }else if(row==7){
        //信用代码
        self.api.socialcode=text;
    }else if(row==8){
        //公司类型
        self.api.companytype=text;
    }else if(row==9){
        //法人代表
        self.api.legalname=text;
    }else if(row==11){
        //注册资本
        self.api.registeredcapital=text;
    }else if(row==15){
        //联系人
        self.api.companyContact=text;
    }else if(row==16){
        //联系电话
        self.api.companyPhone=text;
    }else if(row==17){
        //网站
        self.api.companyWebSite=text;
    }else if(row==18){
        self.api.companyEmail=text;
    }
}
- (void)textViewDidChange:(UITextView *)textView

{
    NSInteger row=textView.tag;
    NSIndexPath * path=[NSIndexPath indexPathForRow:row inSection:0];
    BecomeCompanyInputCell *cell=[self.table cellForRowAtIndexPath:path];
    
    //实时显示字数
    cell.textViewTips.text = [NSString stringWithFormat:@"%lu/%d", (unsigned long)textView.text.length,cell.maxLength];
    //字数限制操作
    if (textView.text.length >= cell.maxLength) {
        textView.text = [textView.text substringToIndex:cell.maxLength];
        cell.textViewTips.text = [NSString stringWithFormat:@"%d/%d",cell.maxLength,cell.maxLength];
    }
    if(row==1){
        self.api.introduce=textView.text;
        NSLog(@"修改简介:%@",self.api.introduce);
    }else{
        self.api.companydetail=textView.text;
    }
}
- (void)requestForUploadPhotoWithCompletion:(int)type callBack:(void(^)(BOOL success))completion {
    BecomeCompanyInputCell *cell;
    if(type==1){
        NSIndexPath * path=[NSIndexPath indexPathForRow:12 inSection:0];
        cell=[self.table cellForRowAtIndexPath:path];
    }else{
        NSIndexPath * path=[NSIndexPath indexPathForRow:13 inSection:0];
        cell=[self.table cellForRowAtIndexPath:path];
    }
    YCTApiUpload *apiUpload = [[YCTApiUpload alloc] initWithImage:type==1?self.YyImg:self.doorImg];
    [[YCTHud sharedInstance] showLoadingHud];
    @weakify(self);
    [apiUpload doStartWithSuccess:^(YCTCOSUploaderResult * _Nullable result) {
        @strongify(self);
        [[YCTHud sharedInstance] hideHud];
        cell.needUpload=NO;
        if(type==1){
            self.needUploadYY=NO;
            self.api.businessLicense=result.url;
        }else{
            self.needUploadDoor=NO;
            self.api.doorHeadPic=result.url;
        }
        completion(YES);
    } failure:^(NSString * _Nonnull errorString) {
        completion(NO);
        [[YCTHud sharedInstance] showDetailToastHud:errorString];
    }];
}
@end
