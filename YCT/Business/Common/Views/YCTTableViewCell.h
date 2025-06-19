//
//  YCTTableViewCell.h
//  YCT
//
//  Created by 木木木 on 2021/12/24.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YCTTableViewCellData : NSObject
@property (nonatomic, copy) NSString *key;
@property (nonatomic, copy) NSString *value;
@property (nonatomic, strong) UIColor *keyColor;
@property (nonatomic, strong) UIColor *valueColor;
@end

@interface YCTTableViewCell : UITableViewCell

@property (readonly) UIView *yct_accessoryView;
@property (readonly) YCTTableViewCellData *textData;

- (void)fillWithData:(YCTTableViewCellData *)data;

@property (nonatomic, assign) CGFloat margin;
@property (nonatomic, assign) CGFloat imageTitleSpacing;

- (void)setMargin:(CGFloat)margin
          spacing:(CGFloat)imageTitleSpacing;

@end

NS_ASSUME_NONNULL_END
