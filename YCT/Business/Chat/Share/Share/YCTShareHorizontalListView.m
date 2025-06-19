//
//  YCTShareHorizontalListView.m
//  YCT
//
//  Created by 木木木 on 2021/12/18.
//

#import "YCTShareHorizontalListView.h"
#import "YCTVerticalButton.h"
#import "YCTShareModel.h"

@interface YCTShareHorizontalCell : UICollectionViewCell
@property (nonatomic, strong) YCTVerticalButton *actionButton;
@end

@implementation YCTShareHorizontalCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    self.actionButton = ({
        YCTVerticalButton *view = [YCTVerticalButton buttonWithType:(UIButtonTypeCustom)];
        view.spacing = 10;
        view.titleLabel.font = [UIFont PingFangSCMedium:12];
        [view setTitleColor:UIColor.mainTextColor forState:(UIControlStateNormal)];
        view;
    });
    [self.contentView addSubview:self.actionButton];
    [self.actionButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
}

@end

@interface YCTShareHorizontalListView ()<UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, copy) NSArray<YCTShareItem *> *items;
@property (nonatomic, copy) void (^clickBlock)(NSUInteger index);
@end

@implementation YCTShareHorizontalListView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViews];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    [self addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    
    UIView *line = ({
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = UIColor.separatorColor;
        view;
    });
    [self addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(0);
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.height.mas_equalTo(onePx);
    }];
}

-  (void)configItems:(NSArray<YCTShareItem *> *)items clickBlock:(void (^)(NSUInteger))clickBlock {
    self.items = items;
    self.clickBlock = clickBlock;
    
    [self.collectionView reloadData];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.items.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    YCTShareHorizontalCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:YCTShareHorizontalCell.cellReuseIdentifier forIndexPath:indexPath];
    [cell.actionButton configTitle:self.items[indexPath.row].shareTitle
                         imageName:self.items[indexPath.row].imageName];
    @weakify(self);
    [[[cell.actionButton rac_signalForControlEvents:(UIControlEventTouchUpInside)] takeUntil:cell.rac_prepareForReuseSignal] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        if (self.clickBlock) {
            self.clickBlock(self.items[indexPath.row].shareType);
        }
    }];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(70, collectionView.bounds.size.height);
}

#pragma mark - Getter

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        _collectionView = ({
            UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
            layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
            layout.sectionInset = UIEdgeInsetsMake(0, 10, 0, 10);
            layout.minimumInteritemSpacing = 0;
            layout.minimumLineSpacing = 0;
            
            UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:(CGRectZero) collectionViewLayout:layout];
            collectionView.showsHorizontalScrollIndicator = NO;
            collectionView.backgroundColor = UIColor.whiteColor;
            collectionView.delegate = self;
            collectionView.dataSource = self;
            [collectionView registerClass:YCTShareHorizontalCell.class forCellWithReuseIdentifier:YCTShareHorizontalCell.cellReuseIdentifier];
            collectionView;
        });
    }
    return _collectionView;
}

@end
