//
//  UITextView+YCT_RAC.m
//  YCT
//
//  Created by 木木木 on 2021/12/25.
//

#import "UITextView+YCT_RAC.h"
#import "NSObject+RACDescription.h"

@implementation UITextView (YCT_RAC)

static void RACUseDelegateProxy_(UITextView *self) {
    if (self.delegate == (id)self.rac_delegateProxy) return;
    
    self.rac_delegateProxy.rac_proxiedDelegate = self.delegate;
    self.delegate = (id)self.rac_delegateProxy;
}

- (RACSignal *)rac_inputTextSignal {
    @weakify(self);
    RACSignal *signal = [[[[[[[RACSignal
                             defer:^{
                                 @strongify(self);
                                 return [RACSignal return:RACTuplePack(self)];
                             }]
                            concat:[self.rac_delegateProxy signalForSelector:@selector(textViewDidChange:)]]
                            reduceEach:^(UITextView *x) {
                                return x;
                            }]
                           filter:^BOOL(UITextView *x) {
                               if (!x.markedTextRange) {
                                   return YES;
                               } else {
                                   return NO;
                               }
                           }]
                           map:^(UITextView *x) {
                               return x.text;
                           }]
                          takeUntil:self.rac_willDeallocSignal]
                         setNameWithFormat:@"%@ -rac_yctTextSignal", RACDescription(self)];
    
    RACUseDelegateProxy_(self);
    
    return signal;
}

@end
