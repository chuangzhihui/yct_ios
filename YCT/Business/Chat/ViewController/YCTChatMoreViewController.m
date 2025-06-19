//
//  YCTChatMoreViewController.m
//  YCT
//
//  Created by 木木木 on 2022/1/3.
//

#import "YCTChatMoreViewController.h"
#import "YCTTableViewCell.h"
#import "YCTTableViewSwitchCell.h"
#import "YCTChatSettingUserCell.h"
#import "YCTWeakProxy.h"
#import "TUIDefine.h"
#import "YCTMineEditInfoInputViewController.h"
#import "YCTApiBlacklist.h"
#import "YCTApiFollowUser.h"

@interface YCTChatMoreViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, copy) NSArray<YCTTableViewCellData *> *dataList;

@end

@implementation YCTChatMoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = YCTLocalizedTableString(@"chat.title.chatDetail", @"Chat");
    [self loadData];
}

- (void)loadData {
    NSMutableArray *dataList = @[].mutableCopy;
    [dataList addObject:({
        YCTCharSettingUserCellData *data = [[YCTCharSettingUserCellData alloc] init];
        data.avatarUrl = [NSURL URLWithString:self.friendProfile.userFullInfo.faceURL];
        data.name = [self.friendProfile.userFullInfo showName];
        data.clickSelector =  @selector(onChangeFollowUser:);
        data.clickTarget = [YCTWeakProxy proxyWithTarget:self];
        data;
    })];
    
    [dataList addObject:({
        YCTTableViewSwitchCellData *data = [[YCTTableViewSwitchCellData alloc] init];
        data.key = YCTLocalizedTableString(@"chat.chatDetail.topChat", @"Chat");
        data.switchSelector = @selector(onTopMostChat:);
        data.switchTarget = [YCTWeakProxy proxyWithTarget:self];
        __weak typeof(self) weakSelf = self;
        [V2TIMManager.sharedInstance getConversation:[NSString stringWithFormat:@"c2c_%@", self.friendProfile.userID] succ:^(V2TIMConversation *conv) {
            data.on = conv.isPinned;
            [weakSelf.tableView reloadData];
        } fail:^(int code, NSString *desc) {
            
        }];
        data;
    })];
    
//    [dataList addObject:({
//        YCTTableViewCellData *data = [[YCTTableViewCellData alloc] init];
//        data.key = YCTLocalizedTableString(@"chat.chatDetail.setAlias", @"Chat");
//        data.value = self.friendProfile.friendRemark;
//        if (data.value.length == 0) {
//            data.value = @"";
//        }
//        data;
//    })];
    
    [dataList addObject:({
        YCTTableViewCellData *data = [[YCTTableViewCellData alloc] init];
        data.key = YCTLocalizedTableString(@"chat.chatDetail.report", @"Chat");
        data.value = @"";
        data;
    })];
    
    [dataList addObject:({
        YCTTableViewSwitchCellData *data = [[YCTTableViewSwitchCellData alloc] init];
        data.key = YCTLocalizedTableString(@"chat.chatDetail.block", @"Chat");
        data.switchSelector =  @selector(onChangeBlackList:);
        data.switchTarget = [YCTWeakProxy proxyWithTarget:self];
        __weak typeof(self) weakSelf = self;
        [[V2TIMManager sharedInstance] getBlackList:^(NSArray<V2TIMFriendInfo *> *infoList) {
            for (V2TIMFriendInfo *friend in infoList) {
                if ([friend.userID isEqualToString:self.friendProfile.userID]) {
                    data.on = true;
                    [weakSelf.tableView reloadData];
                    break;
                }
            }
        } fail:nil];
        data;
    })];
    self.dataList = dataList.copy;
    [self.tableView reloadData];
}

- (void)setupView {
    self.tableView.backgroundColor = self.view.backgroundColor;
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(kNavigationBarHeight);
        make.left.right.bottom.mas_equalTo(0);
    }];
}

#pragma mark - Private

- (void)onTopMostChat:(YCTTableViewSwitchCell *)cell {
    if (cell.switcher.on) {
        [[TUIConversationPin sharedInstance] addTopConversation:[NSString stringWithFormat:@"c2c_%@", self.friendProfile.userID] callback:^(BOOL success, NSString * _Nonnull errorMessage) {
            if (success) {
                return;
            }
            // 操作失败，还原
            cell.switcher.on = !cell.switcher.isOn;
            [[YCTHud sharedInstance] showToastHud:YCTLocalizedTableString(@"chat.chatDetail.topChatTips", @"Chat")];
        }];
    } else {
        [[TUIConversationPin sharedInstance] removeTopConversation:[NSString stringWithFormat:@"c2c_%@", self.friendProfile.userID] callback:^(BOOL success, NSString * _Nonnull errorMessage) {
            if (success) {
                return;
            }
            // 操作失败，还原
            cell.switcher.on = !cell.switcher.isOn;
            [[YCTHud sharedInstance] showToastHud:errorMessage];
        }];
    }
}

- (void)onChangeBlackList:(YCTTableViewSwitchCell *)cell {
//        [[V2TIMManager sharedInstance] addToBlackList:@[self.friendProfile.userID] succ:nil fail:nil];
//        [[V2TIMManager sharedInstance] deleteFromBlackList:@[self.friendProfile.userID] succ:nil fail:nil];
    
    NSString *userID = [YCTChatUtil unwrappedImID:self.friendProfile.userID];
    
    if (cell.switcher.on) {
        YCTApiHandleBlacklist *api = [[YCTApiHandleBlacklist alloc] initWithType:(YCTHandleBlacklistTypeAdd) userId:userID];
        [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
            
        } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
            cell.switcher.on = !cell.switcher.isOn;
        }];
    } else {
        YCTApiHandleBlacklist *api = [[YCTApiHandleBlacklist alloc] initWithType:(YCTHandleBlacklistTypeRemove) userId:userID];
        [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
            
        } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
            cell.switcher.on = !cell.switcher.isOn;
        }];
    }
}

- (void)changeAlias {
    YCTMineEditInfoInputViewController *vc = [[YCTMineEditInfoInputViewController alloc] init];
    vc.originalValue = self.friendProfile.friendRemark;
    vc.title = YCTLocalizedTableString(@"chat.title.setAlias", @"Chat");
    [self.navigationController pushViewController:vc animated:YES];
    
    @weakify(self);
    [[RACObserve(vc, textValue) skip:1] subscribeNext:^(NSString *value) {
        @strongify(self);
        self.friendProfile.friendRemark = value;
        [[V2TIMManager sharedInstance] setFriendInfo:self.friendProfile succ:^{
            [self loadData];
            [NSNotificationCenter.defaultCenter postNotificationName:@"FriendInfoChangedNotification" object:self.friendProfile];
        } fail:^(int code, NSString *desc) {
//            NSLog(@"");
        }];
    }];
}

- (void)onChangeFollowUser:(YCTChatSettingUserCell *)cell {
//    BOOL isFollowed = YES;
//    NSString *userID = [YCTChatUtil parsingImID:self.friendProfile.userID];
//    if (isFollowed) {
//        YCTApiFollowUser *api = [[YCTApiFollowUser alloc] initWithType:(YCTApiFollowUserTypeCancel) userId:userID];
//        [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
//
//        } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
//
//        }];
//    } else {
//        YCTApiFollowUser *api = [[YCTApiFollowUser alloc] initWithType:(YCTApiFollowUserTypeFollow) userId:userID];
//        [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
//
//        } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
//
//        }];
//    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YCTTableViewCellData *data = self.dataList[indexPath.row];
    if ([data isKindOfClass:YCTCharSettingUserCellData.class]) {
        YCTChatSettingUserCell *cell = [tableView dequeueReusableCellWithIdentifier:YCTChatSettingUserCell.cellReuseIdentifier forIndexPath:indexPath];
        [cell fillWithData:(YCTCharSettingUserCellData *)data];
        return cell;
    } else if ([data isKindOfClass:YCTTableViewSwitchCellData.class]) {
        YCTTableViewSwitchCell *cell = [tableView dequeueReusableCellWithIdentifier:YCTTableViewSwitchCell.cellReuseIdentifier forIndexPath:indexPath];
        cell.textLabel.font = [UIFont PingFangSCMedium:15];
        [cell fillWithData:(YCTTableViewSwitchCellData *)data];
        return cell;
    } else {
        YCTTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:YCTTableViewCell.cellReuseIdentifier forIndexPath:indexPath];
        [cell fillWithData:data];
        cell.textLabel.font = [UIFont PingFangSCMedium:15];
        cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arraw_gray_12_12"]];
        return cell;
    }
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    if (indexPath.row == 2) {
//        [self changeAlias];
//    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 100;
    } else {
        return 50;
    }
}

#pragma mark - Getter

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:(UITableViewStylePlain)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
        _tableView.estimatedRowHeight = 0;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = self.view.backgroundColor;
        [_tableView registerClass:YCTTableViewCell.class
           forCellReuseIdentifier:YCTTableViewCell.cellReuseIdentifier];
        [_tableView registerClass:YCTTableViewSwitchCell.class
           forCellReuseIdentifier:YCTTableViewSwitchCell.cellReuseIdentifier];
        [_tableView registerClass:YCTChatSettingUserCell.class
           forCellReuseIdentifier:YCTChatSettingUserCell.cellReuseIdentifier];
    }
    return _tableView;
}

@end
