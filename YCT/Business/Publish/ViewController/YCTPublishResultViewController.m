//
//  YCTPublishResultViewController.m
//  YCT
//
//  Created by hua-cloud on 2022/1/8.
//

#import "YCTPublishResultViewController.h"
#import "YCTRootViewController.h"
@interface YCTPublishResultViewController ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subTitle;
@property (weak, nonatomic) IBOutlet UIButton *homeButton;

@end

@implementation YCTPublishResultViewController

//"publish.backHome" = "返回首页";
//"publish.submitSuccess" = "提交成功";
//"publish.submitSubTitleSuccess" = "您提交的问题已收到，请等待回馈~";
- (void)viewDidLoad {
    [super viewDidLoad];

}
-(void)onBack:(UIButton *)sender{
    [[YCTRootViewController sharedInstance] backToHome];
}
- (NSString *)title{
    return YCTLocalizedTableString(@"publish.submitSuccess", @"Publish");
}

- (void)setupView{
    NSLog(@"草稿：%@",self.caogao?@"是":@"否");
    self.titleLabel.text = YCTLocalizedTableString(@"publish.submitSuccess", @"Publish");
    if(self.caogao){
        self.subTitle.text = YCTLocalizedTableString(@"publish.submitSubTitleSuccessCaogao", @"Publish");
    }else{
        self.subTitle.text = YCTLocalizedTableString(@"publish.submitSubTitleSuccess", @"Publish");
    }
   
    [self.homeButton setTitle:YCTLocalizedTableString(@"publish.backHome", @"Publish") forState:UIControlStateNormal];
    self.homeButton.layer.cornerRadius = 25;
}

- (void)bindViewModel{
    @weakify(self);
    [[self.homeButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        [[YCTRootViewController sharedInstance] backToHome];
        
    }];
}


@end
