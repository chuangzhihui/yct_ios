//
//  YCTVerticalButton.h
//  YCT
//
//  Created by 木木木 on 2021/12/18.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YCTVerticalButton : UIButton

@property (assign, nonatomic) CGFloat spacing;

- (void)configTitle:(NSString *)title imageName:(NSString *)imageName;

@end

NS_ASSUME_NONNULL_END
