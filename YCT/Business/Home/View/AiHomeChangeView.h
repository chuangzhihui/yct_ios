//
//  AiHomeChangeView.h
//  YCT
//
//  Created by 林涛 on 2025/3/26.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AiHomeChangeView : UIView
@property (nonatomic, strong) UIView *bgVw;
@property (nonatomic, strong) UIView *selectVw;
@property (nonatomic, strong) UIButton *btn1;
@property (nonatomic, strong) UIButton *btn2;

- (void)hide;
- (void)show;
@end

NS_ASSUME_NONNULL_END
