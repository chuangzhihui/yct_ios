//
//  ViewController.m
//  YCT
//
//  Created by 木木木 on 2021/12/8.
//

#import "ViewController.h"
#import "YCTShareFriendListView.h"
#import "YCTDragPresentView.h"
#import "YCTShareView.h"
#import "YCTResizeImageViewController.h"
#import "YCTImagePickerViewController.h"


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = UIColor.whiteColor;
    
    UIButton *test = [UIButton buttonWithType:(UIButtonTypeSystem)];
    test.titleLabel.font = [UIFont PingFangSCBold:20];
    [test addTarget:self action:@selector(testClick) forControlEvents:(UIControlEventTouchUpInside)];
    [test setTitle:@"Test" forState:(UIControlStateNormal)];
    [self.view addSubview:test];
    [test mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(kNavigationBarHeight + 50);
        make.centerX.mas_equalTo(0);
    }];
    
}

- (void)testClick {
//    YCTShareFriendListView *view = [YCTShareFriendListView new];
//    [[YCTDragPresentView sharePresentView] showView:view];
    
//    TableViewController *vc = [TableViewController new];
//    [[YCTDragPresentView sharePresentView] showViewController:vc];
    
//    YCTShareView *view = [YCTShareView new];
//    [view setShareTypes:[YCTShareItem allTypes] clickBlock:^(YCTShareType shareType) {
//        
//    }];
//    [view yct_show];
    
//    UIImage *image = [UIImage imageNamed:@"test"];
//
//    JPImageresizerConfigure *configure = [JPImageresizerConfigure darkBlurMaskTypeConfigureWithImage:image make:nil];
//
//    YCTResizeImageViewController *vc = [YCTResizeImageViewController new];
//    vc.configure = configure;
//    [self.navigationController pushViewController:vc animated:YES];
    
//    YCTImagePickerViewController *vc1 = [[YCTImagePickerViewController alloc] initWithMaxImagesCount:1 delegate:self];
//    [self presentViewController:vc1 animated:YES completion:NULL];
    
//    [[YCTHud sharedInstance] showSuccessHud:@"哈哈"];
////    [[YCTHud sharedInstance] showLoadingHud];
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [[YCTHud sharedInstance] showSuccessHud:@"nice"];
////        [self.view showSuccessHud:@"哈哈，成功了"];
////        [self.view showToastHud:@"什么鬼"];
//
//
//    });
    
    [[YCTHud sharedInstance] showLoadingHud];
    
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
        
        sleep(2);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [[YCTHud sharedInstance] showProgress:0 text:@"下载中"];
        });
        
        float progress = 0.0f;
        while (progress < 1.0f) {
            progress += 0.01f;
            dispatch_async(dispatch_get_main_queue(), ^{
                [[YCTHud sharedInstance] showProgress:progress];
            });
            usleep(50000);
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [[YCTHud sharedInstance] showSuccessHud:@"下载成功"];
        });
    });
}

@end
