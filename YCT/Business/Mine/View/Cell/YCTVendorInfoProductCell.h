//
//  YCTVendorInfoProductCell.h
//  YCT
//
//  Created by 木木木 on 2022/5/8.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YCTVendorInfoAddProductCell : UICollectionViewCell

@property (nonatomic, copy) void (^addBlock)(void);

@end

@interface YCTVendorInfoProductCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *productImageView;

@property (nonatomic, strong) NSIndexPath *indexPath;

@property (nonatomic, copy) void (^deleteBlock)(NSIndexPath *indexPath);

- (void)setDeleteButtonHidden:(BOOL)isHidden;

@end

NS_ASSUME_NONNULL_END
