//
//  YCTPaypalViewController.m
//  YCT
//
//  Created by 张大爷的 on 2024/6/23.
//

#import "YCTPaypalViewController.h"
#import <WebKit/WebKit.h>
@interface YCTPaypalViewController ()<WKNavigationDelegate,WKScriptMessageHandler>

@property (strong, nonatomic) WKWebView *webView;
@property (strong, nonatomic) UIButton *closeButton;

@end

@implementation YCTPaypalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Add a back/cross button to the navigation bar
    
    [self.view addSubview:self.webView];
    self.webView.frame = self.view.bounds;
    self.webView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [[_webView configuration].userContentController addScriptMessageHandler:self name:@"getMessage"];
    NSURLRequest *request = [NSURLRequest requestWithURL:self.url];
    [self.webView loadRequest:request];
    // Do any additional setup after loading the view.
    
    [self.view addSubview:self.closeButton];
    self.closeButton.frame = CGRectMake(10, 50, 44, 44);
}

- (void)closeButtonTapped {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    // 根据message.name判断是哪个js方法调用，并处理
    NSLog(@"name:%@",message.name);
    if ([message.name isEqualToString:@"getMessage"]) {
        NSLog(@"Received message from JS: %@", message.body);
        NSString * res=message.body;
        if([res isEqualToString:@"success"]) {
            [[YCTHud sharedInstance] showToastHud:@"授权成功"];
            self.onAuthSuccesss(@"success");
        }
        if([res isEqualToString:@"success_generic"]) {
            [[YCTHud sharedInstance] showToastHud:@"授权成功"];
            self.onAuthGenericSuccess(@"success_generic");
        }
        if([res isEqualToString:@"cancel_generic"]) {
            [[YCTHud sharedInstance] showToastHud:@"授权成功"];
            self.onAuthCancelPayment(@"cancel_generic");
        }
        
        
        [self.navigationController popViewControllerAnimated:YES];
    }
}
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    if (self.title.length == 0) {
        self.title = webView.title;
    }
}

- (WKWebView *)webView {
    if (!_webView) {
        _webView = [[WKWebView alloc] initWithFrame:CGRectZero];
        _webView.backgroundColor = UIColor.whiteColor;
        _webView.navigationDelegate = self;
        [_webView.scrollView.panGestureRecognizer requireGestureRecognizerToFail:self.navigationController.interactivePopGestureRecognizer];
    }
    return _webView;
}

- (UIButton *)closeButton {
    if (!_closeButton) {
        _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeButton setTitle:@"Close" forState:UIControlStateNormal];
        [_closeButton setTitleColor:UIColor.systemBlueColor forState:UIControlStateNormal];
        _closeButton.titleLabel.font = [UIFont systemFontOfSize:16];
        [_closeButton addTarget:self action:@selector(closeButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeButton;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
