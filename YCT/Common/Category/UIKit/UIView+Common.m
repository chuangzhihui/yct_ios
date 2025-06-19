//
//  UIView+Common.m
//  YCT
//
//  Created by 木木木 on 2021/12/9.
//

#import "UIView+Common.h"
#import "UIGestureRecognizer+Common.h"

@implementation UIView (Common)

- (CGFloat)safeBottom {
    if (@available(iOS 11.0, *)) {
        return self.safeAreaInsets.bottom;
    } else {
        return 0;
    }
}

- (CGFloat)safeTop {
    if (@available(iOS 11.0, *)) {
        return self.safeAreaInsets.top;
    } else {
        return 0;
    }
}

+ (UINib *)nib {
    return [UINib nibWithNibName:[[self class] cellReuseIdentifier] bundle:[NSBundle mainBundle]];
}

+ (NSString *)cellReuseIdentifier {
    return NSStringFromClass([self class]);
}

- (UIViewController *)superVC {
    UIResponder *responder = [self nextResponder];
    while (responder && ![responder isKindOfClass:[UIViewController class]]) {
        responder = [responder nextResponder];
    }
    return (UIViewController *)responder;
}

- (UIViewController *)parentVC {
    UIViewController *vc = self.superVC;
    while (vc.parentViewController)
        vc = vc.parentViewController;
    return vc;
}

- (void)setDismissOnClick {
    @weakify(self);
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
        @strongify(self);
        [self.superVC.view endEditing:YES];
    }];
    tapGesture.cancelsTouchesInView = NO;
    [self addGestureRecognizer:tapGesture];
}

@end
