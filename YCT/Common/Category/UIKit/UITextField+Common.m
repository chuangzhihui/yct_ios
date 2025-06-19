//
//  UITextField+Common.m
//  YCT
//
//  Created by 木木木 on 2021/12/25.
//

#import "UITextField+Common.h"
#import "NSString+Common.h"

@implementation UITextField (Common)

- (void)executeValueChangedTransactionKeepingCursorPosition:(void (^)(void))transaction {
    if (!transaction) {
        return;
    }
    
    NSInteger offset = [self offsetFromPosition:self.selectedTextRange.end toPosition:self.endOfDocument];
    
    transaction();
    
    UITextPosition *position1 = [self positionFromPosition:self.endOfDocument inDirection:(UITextLayoutDirectionLeft) offset:offset];
    UITextPosition *position2 = [self positionFromPosition:self.endOfDocument inDirection:(UITextLayoutDirectionLeft) offset:offset];
    UITextRange *selectionRange = [self textRangeFromPosition:position1 toPosition:position2];
    self.selectedTextRange = selectionRange;
}

@end
