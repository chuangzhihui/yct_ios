//
//  UIView+Presentation.m
//  YCT
//
//  Created by 木木木 on 2021/12/14.
//

#import "UIView+Presentation.h"
#import <LEEAlert/LEEAlert.h>
#import "YCTDragPresentView.h"

typedef LEEBaseConfigModel * _Nonnull (^LEEConfigToConfigTextAndLabel)(NSString *str, void(^ _Nullable)(UILabel *label));

typedef LEEBaseConfigModel * _Nonnull (^LEEConfigToConfigAction)(NSString *title, LEEActionType type);

@interface LEEBaseConfigModel (Ext)

@property (nonatomic, copy, readonly) LEEConfigToConfigTextAndLabel LeeYctAddTitle;
@property (nonatomic, copy, readonly) LEEConfigToConfigAction LeeYctAddAction;

@end

@implementation LEEBaseConfigModel (Ext)

- (LEEConfigToConfigTextAndLabel)LeeYctAddTitle {
    return ^(NSString *str, void(^block)(UILabel *)) {
        if (str.length == 0) {
            return self;
        }
        return self.LeeAddItem(^(LEEItem *item) {
            item.type = LEEItemTypeTitle;
            item.insets = UIEdgeInsetsMake(5, 0, 5, 0);
            item.block = block;
        });
    };
}

- (LEEConfigToConfigAction)LeeYctAddAction {
    return ^(NSString *title, LEEActionType type) {
        if (title.length == 0) {
            return self;
        }
        return self.LeeAddAction(^(LEEAction *action) {
            action.type = type;
            action.title = title;
            action.titleColor = UIColor.mainGrayTextColor;
            action.font = [UIFont PingFangSCMedium:16];
        });
    };
}

@end

@implementation UIView (Presentation)

- (void)yct_show {
    [self yct_showWithTitle:@""];
}

- (void)yct_showWithTitle:(NSString *)title {
    [self yct_showWithTitle:title cancelTitle:nil];
}

- (void)yct_showWithTitle:(NSString *)title
              cancelTitle:(NSString *)cancelTitle {
    [LEEAlert actionsheet].config
        .LeeYctAddTitle(title, ^(UILabel * _Nonnull label) {
            label.text = title;
            label.textColor = UIColor.mainTextColor;
            label.font = [UIFont PingFangSCBold:15];
        })
        .LeeItemInsets(UIEdgeInsetsMake(18, 0, 18, 0))
        .LeeAddCustomView(^(LEECustomView *custom) {
            custom.view = self;
            custom.isAutoWidth = YES;
        })
        .LeeYctAddAction(cancelTitle, LEEActionTypeCancel)
        .LeeActionSheetCancelActionSpaceColor(UIColor.tableBackgroundColor)
        .LeeItemInsets(UIEdgeInsetsZero)
        .LeeHeaderInsets(UIEdgeInsetsZero)
        .LeeActionSheetBottomMargin(0)
        .LeeOpenAnimationDuration(0.2)
        .LeeActionSheetBackgroundColor([UIColor whiteColor])
        .LeeActionSheetHeaderCornerRadii(CornerRadiiMake(20, 20, 0, 0))
        .LeeConfigMaxWidth(^CGFloat(LEEScreenOrientationType type, CGSize size) {
            return size.width;
        })
        
        .LeeCloseComplete(^{
        
        })
        .LeeShow();
}

- (void)yct_showAlertStyle {
    [self yct_showAlertStyleWithTitle:@""];
}

- (void)yct_showAlertStyleWithTitle:(NSString *)title {
    [LEEAlert alert].config
        .LeeYctAddTitle(title, ^(UILabel * _Nonnull label) {
            label.text = title;
            label.textColor = UIColor.mainTextColor;
            label.font = [UIFont PingFangSCBold:15];
        })
        .LeeCustomView(self)
        .LeeItemInsets(UIEdgeInsetsMake(0, 0, 0, 0))
        .LeeHeaderInsets(UIEdgeInsetsMake(10, 0, 0, 0))
        .LeeClickBackgroundClose(YES)
        .LeeCornerRadius(6)
        .LeeOpenAnimationDuration(0.2)
        .LeeConfigMaxWidth(^CGFloat(LEEScreenOrientationType type, CGSize size) {
            return self.bounds.size.width;
        })
        .LeeShow();
}

- (void)yct_closeWithCompletion:(void (^)(void))completion {
    __weak typeof(self) weakSelf = self;
    [LEEAlert closeWithCompletionBlock:^{
        if (!weakSelf) return;
        !completion ? : completion();
    }];
}

- (void)dismissForDragPresent {
    [self dismissForDragPresentWithCompletion:NULL];
}

- (void)dismissForDragPresentWithCompletion:(void (^)(void))completion {
    [[YCTDragPresentView sharePresentView] dismissWithCompletion:completion];
}

#pragma mark - AlertSheet

+ (void)showAlertSheetWith:(NSString *)title
               clickAction:(void (^)(void))clickAction {
    [LEEAlert actionsheet].config
        .LeeAddAction(^(LEEAction *action) {
            action.type = LEEActionTypeDestructive;
            action.title = title;
            action.titleColor = UIColor.yct_redColor;
            action.font = [UIFont PingFangSCBold:16];
            action.clickBlock = clickAction;
        })
        .LeeAddAction(^(LEEAction *action) {
            action.type = LEEActionTypeCancel;
            action.title = YCTLocalizedString(@"action.cancel");
            action.titleColor = UIColor.mainGrayTextColor;
            action.font = [UIFont PingFangSCMedium:16];
        })
        .LeeActionSheetCancelActionSpaceColor(UIColor.tableBackgroundColor)
        .LeeActionSheetBottomMargin(0)
        .LeeOpenAnimationDuration(0.2)
        .LeeCornerRadii(CornerRadiiMake(20, 20, 0, 0))
        .LeeActionSheetHeaderCornerRadii(CornerRadiiZero())
        .LeeActionSheetCancelActionCornerRadii(CornerRadiiZero())
        .LeeConfigMaxWidth(^CGFloat(LEEScreenOrientationType type, CGSize size) {
            return size.width;
        })
        .LeeActionSheetBackgroundColor(UIColor.whiteColor)
        .LeeShow();
}

@end
