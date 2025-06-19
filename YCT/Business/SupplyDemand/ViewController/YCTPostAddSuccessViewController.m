//
//  YCTPostAddSuccessViewController.m
//  YCT
//
//  Created by 木木木 on 2021/12/28.
//

#import "YCTPostAddSuccessViewController.h"
#import "YCTRootViewController.h"
@interface YCTPostAddSuccessViewController ()

@end

@implementation YCTPostAddSuccessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = YCTLocalizedTableString(@"post.title.success", @"Post");
}

- (void)setupView {
    UIImageView *imageView = ({
        UIImageView *view = [[UIImageView alloc] init];
        view.image = [UIImage imageNamed:@"success_124"];
        view;
    });
    [self.view addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(kNavigationBarHeight + 58);
        make.width.height.mas_equalTo(124);
        make.centerX.mas_equalTo(0);
    }];
    
    UILabel *successLabel = ({
        UILabel *view = [[UILabel alloc] init];
        view.text = YCTLocalizedTableString(@"post.title.success", @"Post");
        view.font = [UIFont PingFangSCBold:16];
        view.textColor = UIColor.mainTextColor;
        view;
    });
    [self.view addSubview:successLabel];
    [successLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(imageView.mas_bottom).mas_offset(10);
        make.centerX.mas_equalTo(0);
    }];
    
    UILabel *infoLabel = ({
        UILabel *view = [[UILabel alloc] init];
        view.numberOfLines = 0;
        view.text = self.desc ? self.desc : YCTLocalizedTableString(@"post.success.info", @"Post");
        view.font = [UIFont PingFangSCBold:16];
        view.textColor = UIColor.mainTextColor;
        view.textAlignment = NSTextAlignmentCenter;
        view;
    });
    [self.view addSubview:infoLabel];
    [infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(successLabel.mas_bottom).mas_offset(10);
        make.centerX.mas_equalTo(0);
        make.left.mas_equalTo(62);
        make.right.mas_equalTo(-62);
    }];
    
    UIButton *backButton = ({
        UIButton *view = [UIButton buttonWithType:(UIButtonTypeSystem)];
        [view setMainThemeStyleWithTitle:YCTLocalizedTableString(@"post.success.back", @"Post") fontSize:16 cornerRadius:25 imageName:nil];
        @weakify(self);
        [[view rac_signalForControlEvents:(UIControlEventTouchUpInside)] subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self);
            [self _onBack];
        }];
        view;
    });
    [self.view addSubview:backButton];
    [backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(infoLabel.mas_bottom).mas_offset(30);
        make.centerX.mas_equalTo(0);
        make.width.mas_equalTo(150);
        make.height.mas_equalTo(50);
    }];
}

- (void)onBack:(UIButton *)sender{
    [self _onBack];
}

- (void)_onBack {
    if (self.presentingViewController) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

@end
