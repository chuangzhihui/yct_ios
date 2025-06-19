//
//  YCTLiveViewController.m
//  YCT
//
//  Created by 张大爷的 on 2025/5/26.
//

#import "YCTLiveViewController.h"
#import "YCT-Swift.h"
@interface YCTLiveViewController ()

@end

@implementation YCTLiveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    LiveEventListViewController *vc = [[LiveEventListViewController alloc] init];

    [self addChildViewController:vc];
    [self.view addSubview:vc.view];
    // Do any additional setup after loading the view.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (UIView *)listView {
    return self.view;
}

@end
