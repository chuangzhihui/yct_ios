//
//  YCTTagsView.m
//  YCT
//
//  Created by 木木木 on 2021/12/15.
//

#import "YCTTagsView.h"
#import "YCTTagCell.h"
#import "YCTTagInputCell.h"
#import "YCTTagsCollectionViewFlowLayout.h"

@interface YCTTagsView () <UICollectionViewDelegate, UICollectionViewDataSource> {
    BOOL _clearInput;
}

@property (strong, nonatomic, readwrite) YCTTagAttributeConfiguration *tagAttributeConfiguration;

@property (strong, nonatomic) NSMutableArray *selectedTagsM;
@property (strong, nonatomic) UICollectionView *collectionView;

@end

@implementation YCTTagsView

static NSString * const reuseIdentifier = @"YCTTagCellId";
static NSString * const inputReuseIdentifier = @"YCTTagInputCellId";

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self setup];
    }
    return self;
}

- (void)setup {
    self.selectedTagsM = @[].mutableCopy;
    self.tagAttributeConfiguration = [YCTTagAttributeConfiguration new];
    [self addSubview:self.collectionView];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.collectionView.frame = self.bounds;
}

- (void)resetConfiguration {
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
    layout.itemSize = self.tagAttributeConfiguration.itemSize;
    layout.minimumInteritemSpacing = self.tagAttributeConfiguration.minimumInteritemSpacing;
    layout.minimumLineSpacing = self.tagAttributeConfiguration.minimumLineSpacing;
    layout.sectionInset = self.tagAttributeConfiguration.sectionInset;
    layout.scrollDirection = self.tagAttributeConfiguration.scrollDirection;
    
    if (layout.scrollDirection == UICollectionViewScrollDirectionVertical) {
        self.collectionView.showsVerticalScrollIndicator = YES;
        self.collectionView.showsHorizontalScrollIndicator = NO;
    } else {
        self.collectionView.showsHorizontalScrollIndicator = YES;
        self.collectionView.showsVerticalScrollIndicator = NO;
    }
}

#pragma mark - Public

- (void)reloadData {
    [self resetConfiguration];
    [self.collectionView reloadData];
}

- (void)setCanScroll:(BOOL)canScroll {
    self.collectionView.scrollEnabled = canScroll;
}

- (NSArray<NSString *> *)selectedTags {
    return self.selectedTagsM.copy;
}

- (void)updateSelectedTags:(NSArray *)seletedTags {
    NSMutableSet *seletedTagsSet = [NSMutableSet setWithArray:seletedTags];
    [seletedTagsSet intersectSet:[NSSet setWithArray:self.tags]];
    
    [self.selectedTagsM removeAllObjects];
    [self.selectedTagsM addObjectsFromArray:seletedTagsSet.allObjects];
    
    if (self.window) {
        [self reloadData];
    }
}

#pragma mark - UICollectionViewDataSource & UICollectionViewDelegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (self.tagAttributeConfiguration.displayType == YCTTagDisplayTypeNormal) {
        return self.tags.count;
    } else {
        return self.tags.count + 1;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < self.tags.count) {
        YCTTagCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
        cell.layer.borderColor = self.tagAttributeConfiguration.borderColor.CGColor;
        cell.layer.cornerRadius = self.tagAttributeConfiguration.cornerRadius;
        cell.layer.borderWidth = self.tagAttributeConfiguration.borderWidth;
        
        cell.titleLabel.font = self.tagAttributeConfiguration.titleFont;
        cell.titleLabel.text = self.tags[indexPath.item];
        
        [cell setTagText:self.tags[indexPath.item]
              canOperate:self.tagAttributeConfiguration.displayType != YCTTagDisplayTypeNormal
                  margin:self.tagAttributeConfiguration.margin];
            
        if ([self.selectedTagsM containsObject:self.tags[indexPath.item]]) {
            cell.backgroundColor = self.tagAttributeConfiguration.selectedBackgroundColor;
            cell.titleLabel.textColor = self.tagAttributeConfiguration.selectedTextColor;
        } else {
            cell.backgroundColor = self.tagAttributeConfiguration.normalBackgroundColor;
            cell.titleLabel.textColor = self.tagAttributeConfiguration.textColor;
        }
        
        __weak __typeof(self) weakSelf = self;
        cell.clickBlock = ^{
            __strong __typeof(self) strongSelf = weakSelf;
            [strongSelf deleteTagAtIndex:indexPath.row];
        };
        
        return cell;
    } else {
        YCTTagInputCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:inputReuseIdentifier forIndexPath:indexPath];
        cell.layer.borderColor = self.tagAttributeConfiguration.borderColor.CGColor;
        cell.layer.cornerRadius = self.tagAttributeConfiguration.cornerRadius;
        cell.layer.borderWidth = self.tagAttributeConfiguration.borderWidth;
        cell.backgroundColor = self.tagAttributeConfiguration.normalBackgroundColor;
        cell.inputView.textColor = self.tagAttributeConfiguration.textColor;
        cell.inputView.font = self.tagAttributeConfiguration.titleFont;
        [cell setMargin:self.tagAttributeConfiguration.margin];
        
        if (_clearInput) {
            cell.inputView.text = @"";
            _clearInput = NO;
        }
        
        __weak __typeof(self) weakSelf = self;
        cell.clickBlock = ^(NSString * _Nonnull text) {
            __strong __typeof(self) strongSelf = weakSelf;
            [strongSelf insertTag:text];
        };
        
        return cell;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row >= self.tags.count) {
        return;
    }
    
    YCTTagCell *cell = (YCTTagCell *)[collectionView cellForItemAtIndexPath:indexPath];
    
    if ([self.selectedTagsM containsObject:self.tags[indexPath.item]]) {
        cell.backgroundColor = self.tagAttributeConfiguration.normalBackgroundColor;
        cell.titleLabel.textColor = self.tagAttributeConfiguration.textColor;
        [self.selectedTagsM removeObject:self.tags[indexPath.item]];
    } else {
        if (self.isMultiSelect) {
            if (self.delegate
                && [self.delegate respondsToSelector:@selector(tagsView:shouldSelectIndexPath:)]
                && ![self.delegate tagsView:self shouldSelectIndexPath:indexPath]
                ) {
                return;
            }
            cell.backgroundColor = self.tagAttributeConfiguration.selectedBackgroundColor;
            cell.titleLabel.textColor = self.tagAttributeConfiguration.selectedTextColor;
            [self.selectedTagsM addObject:self.tags[indexPath.item]];
        } else {
            [self.selectedTagsM removeAllObjects];
            [self.selectedTagsM addObject:self.tags[indexPath.item]];
            [self reloadData];
        }
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(tagsView:didSelectTags:)]) {
        [self.delegate tagsView:self didSelectTags:self.selectedTags];
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < self.tags.count) {
        return [self cellSizeOfText:self.tags[indexPath.item]];
    } else {
        return [self cellSizeOfText:[[self class] addLabelPlaceholder]];
    }
}

#pragma mark - Private

- (void)deleteTagAtIndex:(NSUInteger)index {
    if (index >= self.tags.count) {
        return;
    }
    NSString *tag = self.tags[index];
    [self.collectionView performBatchUpdates:^{
        NSMutableArray *tags = [NSMutableArray arrayWithArray:self.tags];
        [tags removeObjectAtIndex:index];
        self.tags = tags.copy;
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
        [self.collectionView deleteItemsAtIndexPaths:@[indexPath]];
    } completion:^(BOOL finished) {
        [self.selectedTagsM removeObject:tag];
        if (self.delegate && [self.delegate respondsToSelector:@selector(tagsViewDidRemoveTag:)]) {
            [self.delegate tagsViewDidRemoveTag:self];
        }
        [self.collectionView reloadData];
    }];
}

- (void)insertTag:(NSString *)tag {
    tag = [NSString stringWithFormat:@"#%@", tag];
    [self.collectionView performBatchUpdates:^{
        NSMutableArray *tags = [NSMutableArray arrayWithArray:self.tags];
        [tags addObject:tag];
        self.tags = tags.copy;
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.tags.count inSection:0];
        [self.collectionView insertItemsAtIndexPaths:@[indexPath]];
    } completion:^(BOOL finished) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(tagsViewDidAddNewTag:)]) {
            [self.delegate tagsViewDidAddNewTag:self];
        }
        self->_clearInput = YES;
        [self.collectionView reloadData];
    }];
}

- (CGSize)cellSizeOfText:(NSString *)text {
    return [[self class] cellSizeOfText:text collectionWidth:self.collectionView.frame.size.width tagAttributeConfiguration:self.tagAttributeConfiguration];
}

+ (CGSize)cellSizeOfText:(NSString *)text collectionWidth:(CGFloat)collectionWidth tagAttributeConfiguration:(YCTTagAttributeConfiguration *)tagAttributeConfiguration {
    CGSize maxSize = CGSizeMake(collectionWidth - tagAttributeConfiguration.sectionInset.left - tagAttributeConfiguration.sectionInset.right - tagAttributeConfiguration.margin * 2, tagAttributeConfiguration.itemSize.height);
    
    CGRect frame = [text boundingRectWithSize:maxSize
                                      options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin
                                   attributes:@{NSFontAttributeName: tagAttributeConfiguration.titleFont}
                                      context:nil];
    
    CGFloat width = frame.size.width + tagAttributeConfiguration.margin * 2;
    if (tagAttributeConfiguration.displayType != YCTTagDisplayTypeNormal) {
        width += 26;
    }
    
    return CGSizeMake(width, tagAttributeConfiguration.itemSize.height);
}

+ (NSString *)addLabelPlaceholder {
    return YCTLocalizedTableString(@"post.addLabelPlaceholder", @"Post");
}

#pragma mark - Getter

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:[[YCTTagsCollectionViewFlowLayout alloc] init]];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = UIColor.whiteColor;
        [_collectionView registerClass:[YCTTagCell class] forCellWithReuseIdentifier:reuseIdentifier];
        [_collectionView registerClass:[YCTTagInputCell class] forCellWithReuseIdentifier:inputReuseIdentifier];
        
        [self resetConfiguration];
    }
    return _collectionView;
}

#pragma mark - Setter

- (void)setTags:(NSArray<NSString *> *)tags {
    NSMutableArray *result = @[].mutableCopy;
    [tags enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (![result containsObject:obj]) {
            [result addObject:obj];
        }
    }];
    _tags = result.copy;
    if (self.window) {
        [self reloadData];
    }
}

#pragma mark - Public

+ (CGFloat)getHeightWithTags:(NSArray *)tags
                tagAttribute:(YCTTagAttributeConfiguration *)tagAttribute
                       width:(CGFloat)width {
    CGFloat contentHeight;
    
    if (!tagAttribute) {
        tagAttribute = [[YCTTagAttributeConfiguration alloc] init];
    }
    
    contentHeight = tagAttribute.sectionInset.top + tagAttribute.itemSize.height;

    CGFloat originX = tagAttribute.sectionInset.left;
    CGFloat originY = tagAttribute.sectionInset.top;
    
    NSInteger itemCount = tags.count + (tagAttribute.displayType == YCTTagDisplayTypeOperation ? 1 : 0);
    
    for (NSInteger i = 0; i < itemCount; i++) {
        NSString *tag = nil;
        if (i < tags.count) {
            tag = tags[i];
        } else {
            tag = [[self class] addLabelPlaceholder];
        }
        CGSize itemSize = [self cellSizeOfText:tag collectionWidth:width tagAttributeConfiguration:tagAttribute];
        
        if (tagAttribute.scrollDirection == UICollectionViewScrollDirectionVertical) {
            if ((originX + itemSize.width + tagAttribute.sectionInset.right) > width && i > 0) {
                originX = tagAttribute.sectionInset.left;
                originY += itemSize.height + tagAttribute.minimumLineSpacing;
                
                contentHeight += itemSize.height + tagAttribute.minimumLineSpacing;
            }
        }
        
        originX += itemSize.width + tagAttribute.minimumInteritemSpacing;
    }
    
    contentHeight += tagAttribute.sectionInset.bottom;
    return contentHeight;
}

@end
