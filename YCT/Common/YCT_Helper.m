//
//  YCT_Helper.m
//  YCT
//
//  Created by 张大爷的 on 2022/7/4.
//

#import "YCT_Helper.h"
#import "UIViewControllerCJHelper.h"
#import "JXBWebViewController.h"
@implementation YCT_Helper
+(void)showWebView:(NSString *)url title:(NSString *)title{
    UIViewController *rootView = [UIViewControllerCJHelper findCurrentShowingViewController];
    JXBWebViewController *vc=[[JXBWebViewController alloc] initWithURL:[NSURL URLWithString:url]];
    vc.backItem.title=@"返回";
    vc.closeItem.title=@"关闭";
    vc.title=title;
    UINavigationController *nav=[[UINavigationController alloc] initWithRootViewController:vc];
    nav.modalPresentationStyle=UIModalPresentationFullScreen;
    [rootView presentViewController:nav animated:YES completion:nil];
}
+(void)setBorderWithView:(UIView *)view top:(BOOL)top left:(BOOL)left bottom:(BOOL)bottom right:(BOOL)right borderColor:(UIColor *)color borderWidth:(CGFloat)width
{
    if (top) {
        CALayer *layer = [CALayer layer];
        layer.frame = CGRectMake(0, 0, view.frame.size.width, width);
        layer.backgroundColor = color.CGColor;
        [view.layer addSublayer:layer];
    }
    if (left) {
        CALayer *layer = [CALayer layer];
        layer.frame = CGRectMake(0, 0, width, view.frame.size.height);
        layer.backgroundColor = color.CGColor;
        [view.layer addSublayer:layer];
    }
    if (bottom) {
        CALayer *layer = [CALayer layer];
        layer.frame = CGRectMake(0, view.frame.size.height - width, view.frame.size.width, width);
        layer.backgroundColor = color.CGColor;
        [view.layer addSublayer:layer];
    }
    if (right) {
        CALayer *layer = [CALayer layer];
        layer.frame = CGRectMake(view.frame.size.width - width, 0, width, view.frame.size.height);
        layer.backgroundColor = color.CGColor;
        [view.layer addSublayer:layer];
    }
}
@end
