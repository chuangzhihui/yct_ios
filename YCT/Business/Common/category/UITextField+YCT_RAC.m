//
//  UITextField+YCT_RAC.m
//  YCT
//
//  Created by 木木木 on 2021/12/25.
//

#import "UITextField+YCT_RAC.h"
#import "NSObject+RACDescription.h"

@implementation UITextField (YCT_RAC)

- (RACSignal *)rac_inputTextSignal {
    @weakify(self);
    return [[[[[[RACSignal
                defer:^{
                    @strongify(self);
                    return [RACSignal return:self];
                }]
               concat:[self rac_signalForControlEvents:UIControlEventAllEditingEvents]]
              filter:^BOOL(UITextField *x) {
                  if (!x.markedTextRange) {
                      return YES;
                  } else {
                      return NO;
                  }
              }]
              map:^(UITextField *x) {
                  return x.text;
              }]
             takeUntil:self.rac_willDeallocSignal]
            setNameWithFormat:@"%@ -rac_yctTextSignal", RACDescription(self)];
}


@end
