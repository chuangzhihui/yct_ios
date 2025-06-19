//
//  YCTMineEditMainProductViewController.m
//  YCT
//
//  Created by 木木木 on 2022/3/16.
//

#import "YCTMineEditMainProductViewController.h"
#import "YCTApiUpdateUserInfo.h"
#import "YCTUserDataManager+Update.h"

@interface YCTMineEditMainProductViewController ()

@end

@implementation YCTMineEditMainProductViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = YCTLocalizedTableString(@"mine.title.modifyDirection", @"Mine");
    self.infoLabel.text = YCTLocalizedTableString(@"mine.modify.direction", @"Mine");
}

- (void)saveClick {
    [self.view endEditing:YES];
    
    NSString *newDirection = self.textField.text;
    YCTApiUpdateUserInfo *api = [[YCTApiUpdateUserInfo alloc] initWithType:(YCTApiUpdateUserInfoMainProduct) value:newDirection];
    [[YCTHud sharedInstance] showLoadingHud];
    [api startWithCompletionBlockWithSuccess:^(__kindof YCTBaseRequest * _Nonnull request) {
        [[YCTUserDataManager sharedInstance] updateMainProduct:newDirection];
        [[YCTHud sharedInstance] hideHud];
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(__kindof YCTBaseRequest * _Nonnull request) {
        [[YCTHud sharedInstance] showDetailToastHud:request.getError];
    }];
}

- (NSUInteger)maxInputLength {
    return 100;
}

@end
