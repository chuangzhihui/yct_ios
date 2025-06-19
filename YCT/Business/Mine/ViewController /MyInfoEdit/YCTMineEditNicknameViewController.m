//
//  YCTMineEditNicknameViewController.m
//  YCT
//
//  Created by 木木木 on 2021/12/25.
//

#import "YCTMineEditNicknameViewController.h"
#import "YCTApiUpdateUserInfo.h"
#import "YCTUserDataManager+Update.h"

@interface YCTMineEditNicknameViewController ()
@end

@implementation YCTMineEditNicknameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = YCTLocalizedTableString(@"mine.title.modifyNickname", @"Mine");
    self.infoLabel.text = YCTLocalizedTableString(@"mine.modify.nickname", @"Mine");
}

- (void)saveClick {
    [self.view endEditing:YES];
    
    NSString *newValue = self.textField.text;
    YCTApiUpdateUserInfo *api = [[YCTApiUpdateUserInfo alloc] initWithType:(YCTApiUpdateUserInfoNickName) value:newValue];
    [[YCTHud sharedInstance] showLoadingHud];
    [api startWithCompletionBlockWithSuccess:^(__kindof YCTBaseRequest * _Nonnull request) {
        [[YCTUserDataManager sharedInstance] updateNickName:newValue];
        [[YCTHud sharedInstance] hideHud];
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(__kindof YCTBaseRequest * _Nonnull request) {
        [[YCTHud sharedInstance] showDetailToastHud:request.getError];
    }];
}

- (NSUInteger)maxInputLength {
    return 20;
}

@end
