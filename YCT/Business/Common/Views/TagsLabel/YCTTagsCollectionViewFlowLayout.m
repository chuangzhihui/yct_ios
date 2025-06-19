//
//  YCTTagsCollectionViewFlowLayout.m
//  YCT
//
//  Created by 木木木 on 2021/12/15.
//

#import "YCTTagsCollectionViewFlowLayout.h"

@interface YCTTagsCollectionViewFlowLayout()

@property (nonatomic, weak) id<UICollectionViewDelegateFlowLayout> delegate;
@property (nonatomic, strong) NSMutableArray *itemAttributes;
@property (nonatomic, assign) CGFloat contentWidth;/// 滑动宽度 水平
@property (nonatomic, assign) CGFloat contentHeight;/// 滑动高度 垂直

@end

@implementation YCTTagsCollectionViewFlowLayout

- (instancetype)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

#pragma mark -

- (void)prepareLayout {
    [super prepareLayout];
    
    [self.itemAttributes removeAllObjects];
    
    /// 滑动的宽度 = 左边
    self.contentWidth = self.sectionInset.left;
    
    /// cell的高度 = 顶部 + 高度
    self.contentHeight = self.sectionInset.top + self.itemSize.height;
    
    CGFloat originX = self.sectionInset.left;
    CGFloat originY = self.sectionInset.top;
    
    NSInteger itemCount = [self.collectionView numberOfItemsInSection:0];
    
    for (NSInteger i = 0; i < itemCount; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        CGSize itemSize = [self itemSizeForIndexPath:indexPath];

        if (self.scrollDirection == UICollectionViewScrollDirectionVertical) {
            if ((originX + itemSize.width + self.sectionInset.right) > self.collectionView.frame.size.width && i > 0) {
                originX = self.sectionInset.left;
                originY += itemSize.height + self.minimumLineSpacing;
                self.contentHeight += itemSize.height + self.minimumLineSpacing;
            }
        } else {
            self.contentWidth += itemSize.width;
            if (i == itemCount - 1) {
                self.contentWidth += self.sectionInset.right;
            } else {
                self.contentWidth += self.minimumInteritemSpacing;
            }
        }
        
        UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
        attributes.frame = CGRectMake(originX, originY, itemSize.width, itemSize.height);
        [self.itemAttributes addObject:attributes];
        
        originX += itemSize.width;
        if (i == itemCount - 1) {
            originX += self.sectionInset.right;
        } else {
            originX += self.minimumInteritemSpacing;
        }
    }

    self.contentHeight += self.sectionInset.bottom;
}

- (CGSize)collectionViewContentSize {
    if (self.scrollDirection == UICollectionViewScrollDirectionVertical) {
        return CGSizeMake(self.collectionView.frame.size.width, self.contentHeight);
    } else {
        return CGSizeMake(self.contentWidth, self.collectionView.frame.size.height);
    }
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    return self.itemAttributes;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return CGRectGetWidth(newBounds) != CGRectGetWidth(self.collectionView.bounds);
}

- (CGSize)itemSizeForIndexPath:(NSIndexPath *)indexPath {
    if ([self.delegate respondsToSelector:@selector(collectionView:layout:sizeForItemAtIndexPath:)]) {
        self.itemSize = [self.delegate collectionView:self.collectionView layout:self sizeForItemAtIndexPath:indexPath];
    }
    return self.itemSize;
}

#pragma mark - Getter

- (id<UICollectionViewDelegateFlowLayout>)delegate {
    if (!_delegate) {
        _delegate = (id<UICollectionViewDelegateFlowLayout>)self.collectionView.delegate;
    }
    return _delegate;
}

- (NSMutableArray *)itemAttributes {
    if (!_itemAttributes) {
        _itemAttributes = [NSMutableArray array];
    }
    return _itemAttributes;
}

@end
