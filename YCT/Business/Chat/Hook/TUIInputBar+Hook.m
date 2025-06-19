//
//  TUIInputBar+Hook.m
//  YCT
//
//  Created by 木木木 on 2021/12/20.
//

#import "TUIInputBar+Hook.h"
#import "NSObject+Utils.h"
#import "TUIDefine.h"
#import "TUIInputController.h"
#import "TUIBaseChatViewController.h"

@implementation TUIInputBar (Hook)

+ (void)load {
    SEL sel1 = NSSelectorFromString(@"defaultLayout");
    SEL sel2 = NSSelectorFromString(@"layoutButton:");
    [NSObject methodSwizzleWithClass:self.class origSEL:sel1 overrideSEL:@selector(yct_defaultLayout)];
    [NSObject methodSwizzleWithClass:self.class origSEL:sel2 overrideSEL:@selector(yct_layoutButton:)];
}

- (void)yct_defaultLayout {
    self.lineView.frame = CGRectMake(0, 0, Screen_Width, TLine_Heigh);
    
    CGSize buttonSize = TTextView_Button_Size;
    CGFloat buttonOriginY = (TTextView_Height - buttonSize.height) * 0.5;
    
    self.moreButton.frame = CGRectMake(Screen_Width - buttonSize.width - TTextView_Margin, buttonOriginY, buttonSize.width, buttonSize.height);
    self.faceButton.frame = CGRectMake(self.moreButton.frame.origin.x - buttonSize.width - TTextView_Margin, buttonOriginY, buttonSize.width, buttonSize.height);
    self.keyboardButton.frame = self.moreButton.frame;

    CGFloat beginX = 15;
    CGFloat endX = self.faceButton.frame.origin.x - TTextView_Margin;
    self.inputTextView.frame = CGRectMake(beginX, (TTextView_Height - TTextView_TextView_Height_Min) * 0.5, endX - beginX, TTextView_TextView_Height_Min);
    
    self.inputTextView.backgroundColor = UIColor.tableBackgroundColor;
    self.inputTextView.layer.cornerRadius = 18;
    self.inputTextView.layer.borderColor = nil;
    self.inputTextView.layer.borderWidth = 0;
    
    self.backgroundColor = UIColor.whiteColor;
    
    self.recordButton.frame = CGRectZero;
    self.micButton.frame = CGRectZero;
    
    self.lineView.backgroundColor = UIColor.separatorColor;
    
    [self.faceButton setImage:[UIImage imageNamed:@"chat_tool_emotion"] forState:UIControlStateNormal];
    [self.faceButton setImage:[UIImage imageNamed:@"chat_tool_emotion"] forState:UIControlStateHighlighted];
    
    [self.keyboardButton setImage:[UIImage imageNamed:@"chat_tool_keyboard"] forState:UIControlStateNormal];
    [self.keyboardButton setImage:[UIImage imageNamed:@"chat_tool_keyboard"] forState:UIControlStateHighlighted];
    
    [self.moreButton setImage:[UIImage imageNamed:@"chat_tool_more"] forState:UIControlStateNormal];
    [self.moreButton setImage:[UIImage imageNamed:@"chat_tool_more"] forState:UIControlStateHighlighted];
    
    [self.moreButton removeTarget:nil action:nil forControlEvents:(UIControlEventTouchUpInside)];
    [self.moreButton addTarget:self action:@selector(yct_clickMoreBtn:) forControlEvents:(UIControlEventTouchUpInside)];
}

- (void)yct_layoutButton:(CGFloat)height {
    CGRect frame = self.frame;
    CGFloat offset = height - frame.size.height;
    frame.size.height = height;
    self.frame = frame;

    CGSize buttonSize = TTextView_Button_Size;
    CGFloat bottomMargin = (TTextView_Height - buttonSize.height) * 0.5;
    CGFloat originY = frame.size.height - buttonSize.height - bottomMargin;

    CGRect faceFrame = self.faceButton.frame;
    faceFrame.origin.y = originY;
    self.faceButton.frame = faceFrame;

    CGRect moreFrame = self.moreButton.frame;
    moreFrame.origin.y = originY;
    self.moreButton.frame = moreFrame;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(inputBar:didChangeInputHeight:)]) {
        [self.delegate inputBar:self didChangeInputHeight:offset];
    }
}

- (void)yct_clickMoreBtn:(UIButton *)sender {
    if ([self.delegate isKindOfClass:TUIInputController.class]) {
        TUIInputController *inputController = (TUIInputController *)self.delegate;
        if ([inputController.delegate isKindOfClass:TUIBaseChatViewController.class]) {
            TUIBaseChatViewController *chatVC = (TUIBaseChatViewController *)inputController.delegate;
            SEL selectPhotoForSend = NSSelectorFromString(@"selectPhotoForSend");
            if ([chatVC respondsToSelector:selectPhotoForSend]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
                [chatVC performSelector:selectPhotoForSend];
#pragma clang diagnostic pop
            }
        }
    }
}

@end
