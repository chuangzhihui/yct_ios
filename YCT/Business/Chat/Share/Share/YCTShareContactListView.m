//
//  YCYShareContactListView.m
//  YCT
//
//  Created by 木木木 on 2021/12/18.
//

#import "YCTShareContactListView.h"
#import "YCTFriendsViewModel.h"

@interface YCTShareContactListCell : UICollectionViewCell
@property (nonatomic, strong) CALayer *onlineLayer;
@property (nonatomic, strong) UIView *avatarContainerView;
@property (nonatomic, strong) UIImageView *avatarImageView;
@property (nonatomic, strong) UIImageView *checkImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *onlineStatusLabel;
@end

@implementation YCTShareContactListCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    self.avatarContainerView = ({
        UIView *view = [[UIView alloc] init];
        view;
    });
    [self.contentView addSubview:self.avatarContainerView];
    [self.avatarContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(15);
        make.size.mas_equalTo((CGSize){50, 50});
        make.centerX.mas_equalTo(0);
    }];
    
    self.avatarImageView = ({
        UIImageView *view = [[UIImageView alloc] init];
        view.backgroundColor = UIColor.mainTextColor;
        view.layer.cornerRadius = 25;
        view.layer.masksToBounds = YES;
        view;
    });
    [self.avatarContainerView addSubview:self.avatarImageView];
    [self.avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo((CGSize){50, 50});
        make.centerX.centerY.mas_equalTo(0);
    }];
    
    self.onlineLayer = [CALayer layer];
    self.onlineLayer.borderWidth = 2;
    self.onlineLayer.borderColor = UIColor.whiteColor.CGColor;
    self.onlineLayer.cornerRadius = 9;
    self.onlineLayer.backgroundColor = UIColorFromRGB(0x21E26E).CGColor;
    self.onlineLayer.frame = CGRectMake(32, 32, 18, 18);
    [self.avatarContainerView.layer addSublayer:self.onlineLayer];
    
    self.checkImageView = ({
        UIImageView *view = [[UIImageView alloc] init];
        view.hidden = YES;
        view.image = [UIImage imageNamed:@"share_selected"];
        view;
    });
    [self.contentView addSubview:self.checkImageView];
    [self.checkImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.right.mas_equalTo(self.avatarImageView);
        make.size.mas_equalTo((CGSize){18, 18});
    }];
    
    self.nameLabel = ({
        UILabel *view = [[UILabel alloc] init];
        view.font = [UIFont PingFangSCMedium:12];
        view.textColor = UIColor.mainTextColor;
        view.textAlignment = NSTextAlignmentCenter;
        view;
    });
    [self.contentView addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(5);
        make.right.mas_equalTo(-5);
        make.top.mas_equalTo(self.avatarImageView.mas_bottom).mas_offset(8);
    }];
    
    self.onlineStatusLabel = ({
        UILabel *view = [[UILabel alloc] init];
        view.font = [UIFont PingFangSCMedium:10];
        view.textColor = UIColor.subTextColor;
        view.textAlignment = NSTextAlignmentCenter;
        view;
    });
    [self.contentView addSubview:self.onlineStatusLabel];
    [self.onlineStatusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(5);
        make.right.mas_equalTo(-5);
        make.top.mas_equalTo(self.nameLabel.mas_bottom).mas_offset(4);
    }];
}

- (void)setSelected:(BOOL)selected {
    self.avatarImageView.alpha = selected ? 0.5 : 1;
    self.checkImageView.hidden = !selected;
}

@end

@interface YCTShareContactListView ()<UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate>
@property (nonatomic, strong, readwrite) UICollectionView *collectionView;
@end

@implementation YCTShareContactListView

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

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.models.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    YCTShareContactListCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:YCTShareContactListCell.cellReuseIdentifier forIndexPath:indexPath];
    YCTChatFriendModel *model = self.models[indexPath.row];
    cell.nameLabel.text = model.nickName;
    cell.onlineStatusLabel.text = model.subText;
    cell.onlineLayer.hidden = !model.isOnline;
    [cell.avatarImageView loadImageGraduallyWithURL:[NSURL URLWithString:model.avatar] placeholderImageName:kDefaultAvatarImageName];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(70, collectionView.bounds.size.height);
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([collectionView.indexPathsForSelectedItems containsObject:indexPath]) {
        [collectionView deselectItemAtIndexPath:indexPath animated:YES];
        if (self.selectedIndexPathsChangeBlock) {
            self.selectedIndexPathsChangeBlock(collectionView.indexPathsForSelectedItems);
        }
        return NO;
    }
    return YES;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.selectedIndexPathsChangeBlock) {
        self.selectedIndexPathsChangeBlock(collectionView.indexPathsForSelectedItems);
    }
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
            [collectionView registerClass:YCTShareContactListCell.class forCellWithReuseIdentifier:YCTShareContactListCell.cellReuseIdentifier];
            collectionView;
        });
    }
    return _collectionView;
}

- (NSArray<NSString *> *)selectedUserIds {
    NSMutableArray *userIds = @[].mutableCopy;
    [[self.collectionView indexPathsForSelectedItems] enumerateObjectsUsingBlock:^(NSIndexPath * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.row < self.models.count) {
            YCTChatFriendModel *model = self.models[obj.row];
            !model.userId ?: [userIds addObject:model.userId];
//            if (model.userId) {
//                [userIds addObject:model.userId];
//            }
        }
    }];
    return userIds.copy;
}
- (NSArray<NSIndexPath *> *)selectedIndexPaths {
    return [self.collectionView indexPathsForSelectedItems];
}

@end
