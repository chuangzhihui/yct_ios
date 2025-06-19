//
//  YCTMineEditIDViewController.m
//  YCT
//
//  Created by 木木木 on 2021/12/25.
//

#import "YCTMineEditIDViewController.h"
#import "NSString+Regex.h"
#import "YCTApiUpdateUserInfo.h"
#import "YCTUserDataManager+Update.h"

@interface YCTMineEditIDViewController ()
@end

@implementation YCTMineEditIDViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = YCTLocalizedTableString(@"mine.title.modifyId", @"Mine");
    self.infoLabel.text = YCTLocalizedTableString(@"mine.modify.ID", @"Mine");
}

- (void)saveClick {
    [self.view endEditing:YES];
    
    NSString *newId = self.textField.text;
    YCTApiUpdateUserInfo *api = [[YCTApiUpdateUserInfo alloc] initWithType:(YCTApiUpdateUserInfoID) value:newId];
    [[YCTHud sharedInstance] showLoadingHud];
    [api startWithCompletionBlockWithSuccess:^(__kindof YCTBaseRequest * _Nonnull request) {
        [[YCTUserDataManager sharedInstance] updateUserId:newId];
        [[YCTHud sharedInstance] hideHud];
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(__kindof YCTBaseRequest * _Nonnull request) {
        [[YCTHud sharedInstance] showDetailToastHud:request.getError];
    }];
}

- (NSUInteger)maxInputLength {
    return 10;
}

- (NSUInteger)minInputLength {
    return 6;
}

- (void)textFieldFormat {
    NSString *fortmatText = [NSString filterLetterNumber:self.textField.text];
    self.textField.text = fortmatText;
}

@end
