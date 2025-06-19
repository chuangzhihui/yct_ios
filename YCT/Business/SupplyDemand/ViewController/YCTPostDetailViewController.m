//
//  YCTPostDetailViewController.m
//  YCT
//
//  Created by 木木木 on 2021/12/11.
//

#import "YCTPostDetailViewController.h"
#import "YCTPostListCell.h"
#import "YCTChatViewController.h"
#import "YCTPhotoBrowser.h"
#import "YCTOtherPeopleHomeViewController.h"

@interface YCTPostDetailViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *callButton;
@property (weak, nonatomic) IBOutlet UIButton *messageButton;
@end

@implementation YCTPostDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = YCTLocalizedTableString(@"post.title.releaseDetail", @"Post");
    
    if (!self.model) {
        self.tableView.hidden = YES;
        self.callButton.hidden = YES;
        self.messageButton.hidden = YES;
    }
}

- (void)bindViewModel {
    @weakify(self);
    [[self.messageButton rac_signalForControlEvents:(UIControlEventTouchUpInside)] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        [YCTChatViewController goToChatWithUserId:self.model.userId title:self.model.nickName from:self.navigationController];
    }];
    
    [[self.callButton rac_signalForControlEvents:(UIControlEventTouchUpInside)] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        if (!self.model.mobile) {
            return;
        }
        [UIAlertController showAlertInViewController:self withTitle:nil message:self.model.mobile cancelButtonTitle:YCTLocalizedString(@"action.cancel") destructiveButtonTitle:nil otherButtonTitles:@[YCTLocalizedString(@"action.confirm")] tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
            if (buttonIndex != controller.cancelButtonIndex) {
                NSString *cleanedString =  [[self.model.mobile componentsSeparatedByCharactersInSet:[[NSCharacterSet characterSetWithCharactersInString:@"0123456789-+()"] invertedSet]] componentsJoinedByString:@""];
                NSString *escapedPhoneNumber = [cleanedString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
                NSString *str = [NSString stringWithFormat:@"tel://%@", escapedPhoneNumber];
                NSURL *phoneNumberURL = [NSURL URLWithString:str];
                [[UIApplication sharedApplication] openURL:phoneNumberURL];
            }
        }];
    }];
}

- (void)setupView {
    self.callButton.backgroundColor = UIColor.mainThemeColor;
    self.callButton.titleLabel.font = [UIFont PingFangSCBold:16];
    [self.callButton setTitleColor:UIColor.whiteColor forState:(UIControlStateNormal)];
    self.callButton.layer.cornerRadius = 22;
    [self.callButton setTitle:YCTLocalizedTableString(@"post.call", @"Post") forState:(UIControlStateNormal)];
    self.callButton.tintColor = UIColor.whiteColor;
    
    self.messageButton.backgroundColor = UIColor.grayButtonBgColor;
    self.messageButton.titleLabel.font = [UIFont PingFangSCBold:16];
    [self.messageButton setTitleColor:UIColor.mainTextColor forState:(UIControlStateNormal)];
    self.messageButton.layer.cornerRadius = 22;
    [self.messageButton setTitle:YCTLocalizedTableString(@"post.message", @"Post") forState:(UIControlStateNormal)];
    self.messageButton.tintColor = UIColor.mainTextColor;
    
    self.tableView.backgroundColor = self.view.backgroundColor;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [UIView new];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 44;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:YCTPostListCell.nib forCellReuseIdentifier:YCTPostListCell.cellReuseIdentifier];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YCTPostListCell *cell = [tableView dequeueReusableCellWithIdentifier:YCTPostListCell.cellReuseIdentifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.goodstypeView.hidden = NO;
    [cell updateWithModel:self.model];
    cell.bottomView.backgroundColor = UIColor.clearColor;
    @weakify(self);
    cell.imageClickBlock = ^(YCTPostListCell *cell, NSInteger index) {
        @strongify(self);
        [YCTPhotoBrowser showPhotoBrowerInVC:self photoCount:cell.model.imgs.count currentIndex:index photoConfig:^(NSUInteger idx, NSURL *__autoreleasing *photoUrl, UIImageView *__autoreleasing *sourceImageView) {
            *photoUrl = [NSURL URLWithString:cell.model.imgs[idx]];
            *sourceImageView = [cell.imagesView imageViewAtIndex:idx];
        }];
    };
    cell.avatarClickBlock = ^(YCTSupplyDemandItemModel *model) {
        @strongify(self);
        YCTOtherPeopleHomeViewController *vc = [YCTOtherPeopleHomeViewController otherPeopleHomeWithUserId:model.userId needGoMinePageIfNeeded:YES];
        if (vc) {
            [self.navigationController pushViewController:vc animated:YES];
        }
    };
    return cell;
}

@end
