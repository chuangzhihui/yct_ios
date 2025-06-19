//
//  DraggableView.h
//  YCT
//
//  Created by Fenris on 7/19/24.
//

#import <UIKit/UIKit.h>

@interface DraggableView : UIView
@property (nonatomic, copy) void (^onChatBotViewControllerAppearing)(void);
@property (nonatomic, assign) BOOL shouldShowLabelAndBackground;

- (instancetype)initWithFrame:(CGRect)frame showLabelAndBackground:(BOOL)showLabelAndBackground;

@end

