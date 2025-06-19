//
//  YCTDragPresentView.m
//  YCT
//
//  Created by 木木木 on 2021/12/19.
//

#import "YCTDragPresentView.h"

@implementation YCTDragPresentConfig

- (instancetype)init {
    self = [super init];
    if (self) {
        self.ignoreViewHeight = YES;
        self.ignoreScrollGestureHandle = NO;
    }
    return self;
}

@end

@interface YCTDragPresentView ()<UIGestureRecognizerDelegate>

@property (nonatomic, strong) YCTDragPresentConfig *config;

@property (nonatomic, weak) UIView *container;
@property (nonatomic, weak) UIViewController *containerController;
@property (nonatomic, weak) UIScrollView *scrollerView;
@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) UIPanGestureRecognizer *panGestureRecognizer;
@property (nonatomic, strong) UITapGestureRecognizer *tapGestureRecognizer;

@property (nonatomic, assign) BOOL isDragScrollView;
@property (nonatomic, assign) CGFloat lastDrapDistance;

@property (nonatomic, strong) UIWindow *window;

@end

@implementation YCTDragPresentView

+ (YCTDragPresentView *)sharePresentView {
    static YCTDragPresentView *dragPresentView;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dragPresentView = [[YCTDragPresentView alloc] init];
    });
    return dragPresentView;
}

- (instancetype)init {
    if (self = [super init]) {
        [self initialize];
    }
    return self;
}

- (void)initialize {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    self.window.backgroundColor = [UIColor clearColor];
    self.window.windowLevel = UIWindowLevelAlert;
    self.window.hidden = YES;
    
    self.bgView = [[UIView alloc] initWithFrame:self.window.bounds];
    self.bgView.backgroundColor = [UIColor.blackColor colorWithAlphaComponent:0.1];
    
    self.tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleGuesture:)];
    self.tapGestureRecognizer.delegate = self;
    [self.bgView addGestureRecognizer:self.tapGestureRecognizer];
    
    self.panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    self.panGestureRecognizer.delegate = self;
}

#pragma mark - Public

- (void)showView:(UIView *)view configMaker:(void (^)(YCTDragPresentConfig *config))configMaker {
    [self _resetContentView:view viewController:nil configMaker:configMaker];
    [self _show];
}

- (void)showViewController:(UIViewController *)viewController configMaker:(void (^)(YCTDragPresentConfig *config))configMaker {
    [self _resetContentView:viewController.view viewController:viewController configMaker:configMaker];
    [self _show];
}

- (void)showView:(UIView *)view {
    [self _resetContentView:view viewController:nil configMaker:NULL];
    [self _show];
}

- (void)showViewController:(UIViewController *)viewController {
    [self _resetContentView:viewController.view viewController:viewController configMaker:NULL];
    [self _show];
}

- (void)dismiss {
    [self dismissWithCompletion:NULL];
}

- (void)dismissWithCompletion:(void (^)(void))completion {
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        CGRect frame = self.container.frame;
        frame.origin.y = frame.origin.y + frame.size.height;
        self.container.frame = frame;
        self.bgView.alpha = 0;
    } completion:^(BOOL finished) {
        [self _clearContent];
        !completion ?: completion();
    }];
}

#pragma mark - Private

- (void)_resetContentView:(UIView *)view
           viewController:(UIViewController *)viewController
              configMaker:(void (^ _Nullable)(YCTDragPresentConfig *config))configMaker {
    [self _clearContent];
    
    self.config = [YCTDragPresentConfig new];
    if (configMaker) {
        configMaker(self.config);
    }
    
    self.container = view;
    [self.container addGestureRecognizer:self.panGestureRecognizer];
    
    self.isDragScrollView = NO;
    self.lastDrapDistance = 0;
    
    self.window.rootViewController = [[UIViewController alloc] init];
    self.window.rootViewController.view.backgroundColor = [UIColor clearColor];
    [self.window.rootViewController.view addSubview:self.bgView];
    self.bgView.alpha = 0;
    
    if (viewController) {
        self.containerController = viewController;
        [self.window.rootViewController addChildViewController:viewController];
    }
    
    self.container.frame = (CGRect){
        0,
        self.window.bounds.size.height,
        self.window.bounds.size.width,
        self.config.ignoreViewHeight ? ceil(self.window.bounds.size.height * 3 / 4) : (self.config.viewHeight > 0 ? self.config.viewHeight : view.bounds.size.height)
    };
    
    [self.window.rootViewController.view addSubview:self.container];
    if (viewController) {
        [viewController didMoveToParentViewController:self.window.rootViewController];
    }
}

- (void)_show {
    self.window.hidden = NO;
    [self.window makeKeyAndVisible];
    
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        CGRect frame = self.container.frame;
        frame.origin.y = frame.origin.y - frame.size.height;
        self.container.frame = frame;
        self.bgView.alpha = 1;
    } completion:^(BOOL finished) {
        
    }];
}

- (void)_clearContent {
    self.config = nil;
    
    if (self.containerController) {
        [self.containerController willMoveToParentViewController:nil];
    }
    if (self.container) {
        [self.container removeFromSuperview];
        [self.container removeGestureRecognizer:self.panGestureRecognizer];
    }
    if (self.containerController) {
        [self.window.rootViewController removeFromParentViewController];
    }
    self.window.hidden = YES;
    [self.window resignKeyWindow];
    [self.bgView removeFromSuperview];
    self.window.rootViewController = nil;
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if (gestureRecognizer == self.panGestureRecognizer) {
        UIResponder *touchView = touch.view;
        while (touchView != nil) {
            if ([touchView isKindOfClass:[UIScrollView class]] && !self.config.ignoreScrollGestureHandle) {
                self.isDragScrollView = YES;
                self.scrollerView = (UIScrollView *)touchView;
                break;
            } else if (touchView == self.container) {
                self.isDragScrollView = NO;
                break;
            }
            touchView = [touchView nextResponder];
        }
    }
    return YES;
}

- (BOOL)gestureRecognizer:(UIPanGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    if (gestureRecognizer == self.panGestureRecognizer && !self.config.ignoreScrollGestureHandle) {
        if ([otherGestureRecognizer isKindOfClass:NSClassFromString(@"UIScrollViewPanGestureRecognizer")]
            || [otherGestureRecognizer isKindOfClass:NSClassFromString(@"UIPanGestureRecognizer")]) {
            if ([otherGestureRecognizer.view isKindOfClass:[UIScrollView class]]) {
                return YES;
            }
        }
    }
    return NO;
}

- (void)pan:(UIPanGestureRecognizer *)panGestureRecognizer {
    CGPoint transP = [panGestureRecognizer translationInView:self.container];
    if (self.isDragScrollView) {
        if (self.scrollerView.contentOffset.y <= 0) {
            if (transP.y > 0) {
                self.scrollerView.contentOffset = CGPointMake(0, 0 );
                self.scrollerView.panGestureRecognizer.enabled = NO;
                self.scrollerView.panGestureRecognizer.enabled = YES;
                self.isDragScrollView = NO;
                self.container.frame = CGRectMake(self.container.frame.origin.x, self.container.frame.origin.y + transP.y, self.container.frame.size.width, self.container.frame.size.height);
            } else {

            }
        }
    } else {
        if (transP.y > 0) {
            self.container.frame = CGRectMake(self.container.frame.origin.x, self.container.frame.origin.y + transP.y, self.container.frame.size.width, self.container.frame.size.height);
        } else if (transP.y < 0 && self.container.frame.origin.y > (self.window.bounds.size.height - self.container.frame.size.height)) {
            self.container.frame = CGRectMake(self.container.frame.origin.x, (self.container.frame.origin.y + transP.y) > (self.window.bounds.size.height - self.container.frame.size.height) ? (self.container.frame.origin.y + transP.y) : (self.window.bounds.size.height - self.container.frame.size.height), self.container.frame.size.width, self.container.frame.size.height);
        } else {

        }
    }

    [panGestureRecognizer setTranslation:CGPointZero inView:self.container];
    if (panGestureRecognizer.state == UIGestureRecognizerStateEnded) {
        if (self.lastDrapDistance > 10 && self.isDragScrollView == NO) {
            [self dismiss];
        } else {
            if (self.container.frame.origin.y >= [UIScreen mainScreen].bounds.size.height - self.container.frame.size.height / 2) {
                [self dismiss];
            } else {
                [UIView animateWithDuration:0.15 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                    CGRect frame = self.container.frame;
                    frame.origin.y = self.window.bounds.size.height - self.container.frame.size.height;
                    self.container.frame = frame;
                } completion:NULL];
            }
        }
    }
    self.lastDrapDistance = transP.y;
}

- (void)handleGuesture:(UITapGestureRecognizer *)sender {
    [self dismiss];
}

@end
