//
//  YCTTagInputCell.h
//  HXTagsView
//
//  Created by 木木木 on 2021/12/15.
//  Copyright © 2021 IT小子. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YCTTagInputCell : UICollectionViewCell

@property (copy, nonatomic) void (^clickBlock)(NSString *text);

@property (strong, nonatomic) UITextField *inputView;

- (void)setMargin:(CGFloat)margin;

@end

NS_ASSUME_NONNULL_END
