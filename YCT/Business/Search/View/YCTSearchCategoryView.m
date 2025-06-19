//
//  YCTSearchCategoryView.m
//  YCT
//
//  Created by 张大爷的 on 2022/10/10.
//

#import "YCTSearchCategoryView.h"

@implementation YCTSearchCategoryView

-(instancetype)init{
    self=[super init];
    if(self){
        self.datas=[NSArray arrayWithObjects:@"分类1",@"分类2",@"分类3",@"分类4",@"分类5555",@"分类666", nil];
        self.backgroundColor=[UIColor whiteColor];
        [self addSubview:self.fenlei];
        [self addSubview:self.btn];
        [self addSubview:self.collect];
        [self.fenlei mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.mas_centerY);
            make.left.equalTo(self.mas_left).offset(15);
        }];
        [self.btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.sizeOffset(CGSizeMake(40, 40));
            make.centerY.mas_equalTo(self.mas_centerY);
            make.right.equalTo(self.mas_right).offset(-10);
        }];
        [self.collect mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(@44);
            make.left.equalTo(self.fenlei.mas_right).offset(10);
            make.right.equalTo(self.btn.mas_left).offset(-15);
        }];
    }
    return self;
}
-(UILabel *)fenlei{
    if(!_fenlei){
        _fenlei=[[UILabel alloc] init];
        _fenlei.font=fontSize(14);
        _fenlei.textColor=[UIColor mainTextColor];
        _fenlei.text=YCTLocalizedTableString(@"search.cate", @"Home");
    }
    return _fenlei;
}
-(UIButton *)btn{
    if(!_btn){
        _btn=[UIButton buttonWithType:UIButtonTypeCustom];
        [_btn setImage:[UIImage imageNamed:@"cate"] forState:UIControlStateNormal];
    }
    return _btn;
}
-(UICollectionView*)collect{
    if(!_collect){
        UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc] init];
        layout.estimatedItemSize = CGSizeMake(30, 30);
        layout.sectionInset=UIEdgeInsetsMake(0, 0, 0, 0);
        layout.minimumLineSpacing = 10;
        layout.scrollDirection=UICollectionViewScrollDirectionHorizontal;
        // 2.设置 最小列间距
        layout. minimumInteritemSpacing  = 10;
//        layout.scrollDirection =  UICollectionViewScrollDirectionVertical;
        _collect=[[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collect.delegate=self;
        _collect.dataSource=self;
        _collect.bounces=NO;
        _collect.alwaysBounceHorizontal=YES;
        _collect.showsHorizontalScrollIndicator=YES;
        _collect.backgroundColor=[UIColor whiteColor];
        [_collect registerClass:[YCTSearchCateCell class] forCellWithReuseIdentifier:@"YCTSearchCateCell"];
    }
    return _collect;
}
#pragma mark ---代理方法
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.datas.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath{
    YCTSearchCateCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"YCTSearchCateCell" forIndexPath:indexPath];
    YCTCatesModel *model=self.datas[indexPath.row];
    cell.title.text=model.name;
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    YCTCatesModel *model=self.datas[indexPath.row];
    NSLog(@"选中了:%@",model.name);
    self.onSelected(model);
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(void)setCollectData:(NSArray<YCTCatesModel *> *)datas{
    self.datas=datas;
    [self.collect reloadData];
}
@end
