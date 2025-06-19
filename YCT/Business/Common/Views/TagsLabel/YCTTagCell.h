//
//  YCTTagCell.h
//  YCT
//
//  Created by 木木木 on 2021/12/15.
//

#import <UIKit/UIKit.h>

@interface YCTTagCell : UICollectionViewCell

@property (copy, nonatomic) void (^clickBlock)(void);

@property (strong, nonatomic) UILabel *titleLabel;

- (void)setTagText:(NSString *)tagText
        canOperate:(BOOL)canOperate
            margin:(CGFloat)margin;

@end
