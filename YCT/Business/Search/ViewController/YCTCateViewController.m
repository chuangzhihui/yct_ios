//
//  YCTCateViewController.m
//  YCT
//
//  Created by 张大爷的 on 2022/10/10.
//

#import "YCTCateViewController.h"
#import "YCTCateViewCell.h"
#import "YCTApiSearchAllCate.h"
#import "YCTSearchViewController.h"
#import "YCTAPIGoodsTypeList.h"
@interface YCTCateViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *table;
@property(nonatomic,strong)NSArray<YCTCatesModel*> *datas;

@end

@implementation YCTCateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
}
-(void)setupView{
    [self.view addSubview:self.table];
    [self.table mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
}
-(void)requestData{
    YCTAPIGoodsTypeList *api=[[YCTAPIGoodsTypeList alloc] initWithTypeId:self.typeId];
    @weakify(self);
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        @strongify(self);
        NSMutableArray<YCTCatesModel *>*models=[NSMutableArray array];
        NSDictionary *res=request.responseObject;
        NSLog(@"请求回调:%@",res);
        int code=[[res objectForKey:@"code"] intValue];
        if(code!=1){
            return;
        }
        NSArray *data=[res objectForKey:@"data"];
        int level=1;
        if(self.selectModel){
            level=self.selectModel.level+1;
            if(self.selectModel.level==2 && !(self.isFromHomeSearch)){
                [models addObject:self.selectModel];
            }
        }
        for(int i=0;i<data.count;i++){
            NSDictionary *item=data[i];
            YCTCatesModel *m1=[[YCTCatesModel alloc] initWithDic:item level:level pid:0 pname:@"" ppid:0 ppname:@""];
            [models addObject:m1];
        }
        
        self.datas=models;
        [self.table reloadData];
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        
    }];
}
-(void)bindViewModel{
    [self requestData];
//    YCTApiSearchAllCate * api=[[YCTApiSearchAllCate alloc] init];
//    @weakify(self);
//    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
//        @strongify(self);
////        NSArray * cateSearchKeys = [request.responseObject valueForKeyPath:@"data.name"];
//        NSMutableArray<YCTCatesModel *>*models=[NSMutableArray array];
//        NSDictionary *res=request.responseObject;
//        int code=[[res objectForKey:@"code"] intValue];
//        if(code!=1){
//            return;
//        }
//        NSArray *data=[res objectForKey:@"data"];
//        for(int i=0;i<data.count;i++){
//            NSDictionary *item=data[i];
//            YCTCatesModel *m1=[[YCTCatesModel alloc] initWithDic:item level:1 pid:0 pname:@"" ppid:0 ppname:@""];
//            [models addObject:m1];
//            NSArray *son1=[item objectForKey:@"child"];
//            for(int a=0;a<son1.count;a++){
//                NSDictionary * item2=son1[a];
//                YCTCatesModel *m2=[[YCTCatesModel alloc] initWithDic:item2 level:2 pid:m1.cateId pname:m1.name ppid:0 ppname:@""];
//                [models addObject:m2];
//                NSArray *son2=[item2 objectForKey:@"child"];
//                for(int s=0;s<son2.count;s++){
//                    NSDictionary * item3=son2[s];
//                    YCTCatesModel *m3=[[YCTCatesModel alloc] initWithDic:item3 level:3 pid:m2.cateId pname:m2.name ppid:m2.pid ppname:m2.pname];
//                    [models addObject:m3];
//                }
//            }
//        }
//        self.datas=models;
//        [self.table reloadData];
//        NSLog(@"请求回调:%@",request.responseObject);
//
//    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
//
//    }];
}
-(UITableView *)table{
    if(!_table){
        _table=[[UITableView alloc] init];
        
        _table.delegate=self;
        _table.dataSource=self;
        _table.rowHeight=UITableViewAutomaticDimension;
        _table.showsVerticalScrollIndicator=NO;
        _table.backgroundColor=[UIColor whiteColor];
    }
    return _table;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44.f;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.datas.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YCTCateViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"YCTCateViewCell"];
    if(!cell){
        cell=[[YCTCateViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"YCTCateViewCell"];
    }
    YCTCatesModel *model=self.datas[indexPath.row];
    if (self.isFromHomeSearch) {
        [cell setCellUIForHomeSearch:model];
    } else {
        [cell setCellUI:model];
    }
//    cell.title.text=model.name;
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    cell.backgroundColor=[UIColor whiteColor];

    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    YCTCatesModel *model=self.datas[indexPath.row];
    if(model.level==1 || (model.level==2 && model.cateId!=self.typeId)){
    
        if (self.isFromHomeSearch) {
            YCTCateViewController* cateVC=[[YCTCateViewController alloc] init];
            cateVC.isFromHomeSearch = self.isFromHomeSearch;
            cateVC.typeId = model.cateId;
            cateVC.selectModel = model;
            [self.navigationController pushViewController:cateVC animated:YES];
        } else {
            self.typeId=model.cateId;
            self.selectModel=model;
            [self requestData];
        }
        return;
    } else {
        if (self.isFromHomeSearch) {
            YCTSearchViewController * vc = [YCTSearchViewController new];
            vc.isCallApi = self.isFromHomeSearch;
            vc.name = model.name;
            [self.navigationController pushViewController:vc animated:YES];
        } else {
            self.onSelected(model);
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    
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
