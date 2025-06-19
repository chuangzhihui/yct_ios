//
//  YYCopyLabel.m
//  YCT
//
//  Created by 张大爷的 on 2022/9/14.
//

#import "YYCopyLabel.h"

@interface YYCopyLabel ()

@property (nonatomic, strong) UILongPressGestureRecognizer *longPressGR;

@end

@implementation YYCopyLabel

- (void)setCopyEnabled:(BOOL)copyEnabled
{
    _copyEnabled = copyEnabled;
    
    // 确保 UILabel 可交互
    self.userInteractionEnabled = copyEnabled;
    
    if (copyEnabled && !self.longPressGR) {
        self.longPressGR = [[UILongPressGestureRecognizer alloc] initWithTarget:self
                                                                         action:@selector(handleLongPressGesture:)];
        [self addGestureRecognizer:self.longPressGR];
    }
    
    if (self.longPressGR) {
        self.longPressGR.enabled = copyEnabled;
    }
}

- (void)handleLongPressGesture:(UILongPressGestureRecognizer *)longPressGR
{
    if (longPressGR.state == UIGestureRecognizerStateBegan) {
        [self becomeFirstResponder];
        UIMenuItem *item1= [[UIMenuItem alloc]initWithTitle:YCTLocalizedTableString(@"mine.companyInfo.copy", @"Mine") action:@selector(copyAction)];;
        UIMenuController *menu =[UIMenuController sharedMenuController];
        [menu setMenuItems:[NSArray arrayWithObjects:item1,nil]];
        
        [menu setMenuVisible:YES animated:YES];
        [menu setTargetRect:self.frame inView:[self superview]];
        [menu setArrowDirection:UIMenuControllerArrowDown];
    }
}

#pragma mark - UIMenuController
-(void)copyAction{
    
    UIPasteboard *pastboard = [UIPasteboard generalPasteboard];
    [pastboard setString:self.text];
}
- (BOOL)canBecomeFirstResponder
{
    return YES;
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    // 自定义响应UIMenuItem Action，例如你可以过滤掉多余的系统自带功能（剪切，选择等），只保留复制功能。
    return (action == @selector(copyAction));
}

- (void)copy:(id)sender
{
    [[UIPasteboard generalPasteboard] setString:self.text];
}
@end
