//
//  TUIVideoViewController+Hook.m
//  YCT
//
//  Created by 木木木 on 2021/12/20.
//

#import "TUIVideoViewController+Hook.h"
#import "NSObject+Utils.h"

@implementation TUIVideoViewController (Hook)

//+ (void)load {
//    [NSObject methodSwizzleWithClass:self.class origSEL:@selector(viewWillAppear:) overrideSEL:@selector(yct_viewWillAppear:)];
//    [NSObject methodSwizzleWithClass:self.class origSEL:@selector(viewDidAppear:) overrideSEL:@selector(yct_viewDidAppear:)];
//    [NSObject methodSwizzleWithClass:self.class origSEL:@selector(viewWillDisappear:) overrideSEL:@selector(yct_viewWillDisappear:)];
//}
//
//- (void)yct_viewWillAppear:(BOOL)animated{
//    [super viewWillAppear:animated];
//    self.navigationController.delegate = self;
//    [self changeNavigationBarColor:UIColor.clearColor titleColor:UIColor.whiteColor];
//}
//
//- (void)yct_viewDidAppear:(BOOL)animated{
//    [super viewDidAppear:animated];
//    self.navigationController.interactivePopGestureRecognizer.delegate = self;
//    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
//}
//
//- (void)yct_viewWillDisappear:(BOOL)animated {
//    [super viewWillDisappear:animated];
//    [self changeNavigationBarColor:UIColor.whiteColor titleColor:UIColor.navigationBarTitleColor];
//}

@end
