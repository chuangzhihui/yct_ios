//
//  YCTSearchSubViewController.m
//  YCT
//
//  Created by hua-cloud on 2021/12/23.
//

#import "YCTSearchSubViewController.h"
#import "YCTSearchResultHeaderView.h"
#import "YCTSearchUserCell.h"
#import "YCTSearchHotCell.h"
#import "YCTSearchVideoCell.h"
#import "YCTSearchViewModel.h"
#import "UIScrollView+YCTEmptyView.h"
#import "YCTVideoDetailViewController.h"
#import "YCTOtherPeopleHomeViewController.h"
@interface YCTSearchSubViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) UICollectionView * collection;
@property (nonatomic, strong) YCTSearchResultViewModel * viewModel;
@property (nonatomic, assign) YCTSearchResultType type;
@end

@implementation YCTSearchSubViewController

- (instancetype)initWithType:(YCTSearchResultType)type
                     keyword:(NSString *)keyword
                  locationId:(NSString *)locationId
{
    self = [super init];
    if (self) {
        self.type = type;
        self.viewModel = [[YCTSearchResultViewModel alloc] initWithType:type keyword:keyword locationId:locationId];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)setupView{
    [self.view addSubview:self.collection];
    
    [self.collection mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
}

- (void)bindViewModel{
    @weakify(self);
    if (self.type != YCTSearchResultTypeAll) {
        self.collection.mj_footer = [YCTRefreshFooter footerWithRefreshingBlock:^{
            @strongify(self);
            [self.viewModel loadMore];
        }];
    }
    
    [self.viewModel.loadingSubject subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        [x boolValue] ? [self.collection showLoadingHud] : [self.collection hideHud];
    }];
    
    [self.viewModel.reloadSubject subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        [self.collection reloadData];
        [x boolValue] ? [self.collection.mj_footer endRefreshingWithNoMoreData] : [self.collection.mj_footer endRefreshing];
    }];
    
    [self.viewModel.nodataSubject subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        [self.collection showEmptyViewWithImage:[UIImage imageNamed:@"empty_search"] emptyInfo:YCTLocalizedTableString(@"search.noSearch", @"Home") inset:UIEdgeInsetsMake(270, 0, 0, 0)];
    }];
}

#pragma mark - UICollectionViewDelegate & dataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 4;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    NSLog(@"sextion:%ld",section);
    if (section == 0 ) {
        return YCT_IS_VALID_ARRAY(self.viewModel.hotVideos) ? 1 : 0;
    }else if (section == 1 ){
        return self.viewModel.users.count;
    }else if (section == 2 ){
        return self.viewModel.videos.count;
    }else{
        return self.viewModel.recommendVideos.count;
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0 ) {
        return CGSizeMake(Iphone_Width, 385);
    }else if(indexPath.section == 1 ) {
        return YCTSearchUserCell.cellSize;
    }else if(indexPath.section == 2 ){
        return YCTSearchVideoCell.cellSize;
    }else {
        return YCTSearchVideoCell.cellSize;
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    if (self.type == YCTSearchResultTypeAll) {
        if (section == 0 && YCT_IS_VALID_ARRAY(self.viewModel.hotVideos)) {
            return CGSizeMake(Iphone_Width, 50);
        }else if(section == 1 && YCT_IS_VALID_ARRAY(self.viewModel.users)) {
            return CGSizeMake(Iphone_Width, 50);
        }else if(section == 2 && YCT_IS_VALID_ARRAY(self.viewModel.videos)){
            return CGSizeMake(Iphone_Width, 50);
        }else if(section == 3 && YCT_IS_VALID_ARRAY(self.viewModel.recommendVideos)){
            return CGSizeMake(Iphone_Width, 50);
        }
    }
    return CGSizeZero;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    return CGSizeZero;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        if (self.type == YCTSearchResultTypeAll) {
            if (indexPath.section == 0 && YCT_IS_VALID_ARRAY(self.viewModel.hotVideos)) {
                YCTSearchResultHeaderView * header = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:YCTSearchResultHeaderView.cellReuseIdentifier forIndexPath:indexPath];
                header.headerTitle.text = self.viewModel.hotTitle;
                header.isHot = YES;
                return header;
            }else if(indexPath.section == 1 && YCT_IS_VALID_ARRAY(self.viewModel.users)) {
                YCTSearchResultHeaderView * header = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:YCTSearchResultHeaderView.cellReuseIdentifier forIndexPath:indexPath];
                header.headerTitle.text = self.viewModel.userTitle;
                return header;
            }else if(indexPath.section == 2 && YCT_IS_VALID_ARRAY(self.viewModel.videos)){
                YCTSearchResultHeaderView * header = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:YCTSearchResultHeaderView.cellReuseIdentifier forIndexPath:indexPath];
                header.headerTitle.text = self.viewModel.videoTitle;
                return header;
            }else if(indexPath.section == 3 && YCT_IS_VALID_ARRAY(self.viewModel.recommendVideos)){
                YCTSearchResultHeaderView * header = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:YCTSearchResultHeaderView.cellReuseIdentifier forIndexPath:indexPath];
                header.headerTitle.text = self.viewModel.recommendTitle;
                return header;
            }else{
                YCTSearchResultHeaderView * header = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:YCTSearchResultHeaderView.cellReuseIdentifier forIndexPath:indexPath];
                header.hidden = YES;
                return header;
            }
        }
        
        UICollectionReusableView * header = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"header" forIndexPath:indexPath];
        return header;
    }else{
        UICollectionReusableView * footer = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"footer" forIndexPath:indexPath];
        return footer;
    }
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"选中%ld",indexPath.section);
    if (indexPath.section == 0) {
        YCTSearchHotCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:YCTSearchHotCell.cellReuseIdentifier forIndexPath:indexPath];
        [cell prepareForShowWithModels:self.viewModel.hotVideos];
        @weakify(self);
        [cell setDidSelectedItem:^{
            @strongify(self);
            YCTVideoDetailViewController * vc = [[YCTVideoDetailViewController alloc] initWithVideos:self.viewModel.hotVideos index:indexPath.row type:YCTVideoDetailTypeOther];
            [self.navigationController pushViewController:vc animated:YES];
        }];
        return cell;
    }else if (indexPath.section == 1){
        YCTSearchUserCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:YCTSearchUserCell.cellReuseIdentifier forIndexPath:indexPath];
        YCTSearchUserModel * model = self.viewModel.users[indexPath.row];
        [cell prepareForShowWithModel:model];
        
        return cell;
    }else if (indexPath.section == 2){
        YCTSearchVideoCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:YCTSearchVideoCell.cellReuseIdentifier forIndexPath:indexPath];
        [cell prepareForShowWithModel:self.viewModel.videos[indexPath.row]];
        return cell;
    }else{
        YCTSearchVideoCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:YCTSearchVideoCell.cellReuseIdentifier forIndexPath:indexPath];
        [cell prepareForShowWithModel:self.viewModel.recommendVideos[indexPath.row]];
        return cell;
    }
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(10, 15, 0, 15);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    if (section == 1) {
        return 30.f;
    }else{
        return 7.f;
    }
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    if (section == 1) {
        return 30.f;
    }else{
        return 7.f;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) return;
    if (indexPath.section == 1) {
        YCTSearchUserModel * user = self.viewModel.users[indexPath.row];
        YCTOtherPeopleHomeViewController * vc = [YCTOtherPeopleHomeViewController otherPeopleHomeWithUserId:user.userId];
        if (vc) {
            [self.navigationController pushViewController:vc animated:YES];
        }
    } else {
        NSArray * videos = indexPath.section == 0 ? self.viewModel.hotVideos : indexPath.section == 2 ? self.viewModel.videos : self.viewModel.recommendVideos;
        YCTVideoDetailViewController * vc = [[YCTVideoDetailViewController alloc] initWithVideos:videos index:indexPath.row type:YCTVideoDetailTypeOther];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - JXCategoryListContentViewDelegate

- (UIView *)listView {
    return self.view;
}

#pragma mark - getter
- (UICollectionView *)collection{
    if (!_collection) {
        UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
        _collection = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collection.backgroundColor = UIColor.whiteColor;
        _collection.delegate = self;
        _collection.dataSource = self;
        [_collection registerClass:[YCTSearchResultHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:YCTSearchResultHeaderView.cellReuseIdentifier];
        [_collection registerNib:YCTSearchUserCell.nib forCellWithReuseIdentifier:YCTSearchUserCell.cellReuseIdentifier];
        [_collection registerNib:YCTSearchVideoCell.nib forCellWithReuseIdentifier:YCTSearchVideoCell.cellReuseIdentifier];
        [_collection registerClass:[YCTSearchHotCell class] forCellWithReuseIdentifier:YCTSearchHotCell.cellReuseIdentifier];
        [_collection registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footer"];
        [_collection registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
    }
    return _collection;
}

@end
