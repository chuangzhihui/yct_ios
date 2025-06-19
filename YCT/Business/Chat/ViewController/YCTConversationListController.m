//
//  YCTConversationListController.m
//  YCT
//
//  Created by 木木木 on 2021/12/21.
//

#import "YCTConversationListController.h"
#import "YCTConversationCellData.h"
#import "YCTConversationCell.h"
#import "TUICore.h"
#import "TUIDefine.h"
#import "YCTChatUIDefine.h"
#import "TUISearchViewController.h"
#import "TUICommonModel.h"
#import "YCTSearchView.h"
#import "YCTApiBasicMsg.h"
#import "YCTAddFriendsViewController.h"
#import "YCTRootViewController.h"

static NSString *kConversationCell_ReuseId = @"TConversationCell";

@interface YCTConversationListController () <UIGestureRecognizerDelegate, UITableViewDelegate, UITableViewDataSource, TUIConversationListDataProviderDelegate, TUINotificationProtocol, UITextFieldDelegate>

@property (nonatomic, strong) YCTSearchView *searchView;

@property (nonatomic, strong) YCTConversationCellData *interactionMsgsData;
@property (nonatomic, strong) YCTConversationCellData *fansMsgsData;
@property (nonatomic, strong) YCTConversationCellData *systemMsgsData;

@property (nonatomic, weak) YCTApiBasicMsg *apiBasicMsg;

@property (nonatomic, strong) NSArray<TUIConversationCellData *> *dataList;//聊天列表数据
@end

@implementation YCTConversationListController

- (instancetype)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupViews];
    
    self.interactionMsgsData = [[YCTConversationCellData alloc] init];
    self.interactionMsgsData.imageName = @"chat_conversation_interaction";
    self.interactionMsgsData.title = YCTLocalizedTableString(@"chat.main.interactiveMessage", @"Chat");
    self.interactionMsgsData.timeString = @"";
    self.interactionMsgsData.subTitleString = @"";
    self.interactionMsgsData.cselector = @selector(didSelectInteractionMsg:);
    self.interactionMsgsData.isOnTop = NO;
    
    self.fansMsgsData = [[YCTConversationCellData alloc] init];
    self.fansMsgsData.imageName = @"chat_conversation_fans";
    self.fansMsgsData.title = YCTLocalizedTableString(@"chat.main.fans", @"Chat");
    self.fansMsgsData.timeString = @"";
    self.fansMsgsData.subTitleString = @"";
    self.fansMsgsData.cselector = @selector(didSelectFansMsg:);
    self.fansMsgsData.isOnTop = NO;
    
    self.systemMsgsData = [[YCTConversationCellData alloc] init];
    self.systemMsgsData.imageName = @"chat_conversation_system";
    self.systemMsgsData.title = YCTLocalizedTableString(@"chat.main.systomNotification", @"Chat");
    self.systemMsgsData.timeString = @"";
    self.systemMsgsData.subTitleString = @"";
    self.systemMsgsData.cselector = @selector(didSelectSystemMsg:);
    self.systemMsgsData.isOnTop = NO;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    NSLog(@"这里啊");
    [self.apiBasicMsg stop];
    [self requestBasicMsg];
    if(_dataProvider){
        NSLog(@"重载聊天列表!");
        [self.dataProvider reloadData];
    }
}

- (void)setupViews {
    self.view.backgroundColor = UIColor.whiteColor;
    
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    _tableView.tableFooterView = [[UIView alloc] init];
    _tableView.backgroundColor = self.view.backgroundColor;
    _tableView.contentInset = UIEdgeInsetsMake(0, 0, 8, 0);
    _tableView.separatorInset = UIEdgeInsetsMake(0, 80, 0, 0);
    [_tableView registerClass:[YCTConversationCell class] forCellReuseIdentifier:kConversationCell_ReuseId];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.estimatedRowHeight = YCTConversationCell_Height;
    _tableView.rowHeight = YCTConversationCell_Height;
    _tableView.mj_insetB = [YCTRootViewController sharedInstance].tabBar.frame.size.height;
    
    _searchView = [[YCTSearchView alloc] init];
    _searchView.textField.delegate = self;
    UIView *headerView = [[UIView alloc] init];
    [headerView addSubview:_searchView];
    _searchView.frame = CGRectMake(15, 20, self.view.bounds.size.width - 15 * 2, 40);
    headerView.backgroundColor = UIColor.whiteColor;
    [headerView setFrame: CGRectMake(0, 0, self.view.bounds.size.width, 62)];
    _tableView.tableHeaderView = headerView;
    
    _tableView.delaysContentTouches = NO;
    [self.view addSubview:_tableView];

    @weakify(self)
    [RACObserve(self.dataProvider, dataList) subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        NSLog(@"重载聊天列表回调!长度:%ld",self.dataProvider.dataList.count);
        [self buildDataList];
       
    }];
}
-(void)buildDataList{
    NSString *search=self.searchView.textField.text;
    if(![search isEqual:@""]){
        NSMutableArray<TUIConversationCellData *> *datas=[NSMutableArray array];
        for(int i=0;i<self.dataProvider.dataList.count;i++){
            TUIConversationCellData *data=self.dataProvider.dataList[i];
            NSString *string = data.title;
            if([string rangeOfString:search].location != NSNotFound){
                //标题包含搜索的内容
                [datas addObject:data];
            }
        }
        self.dataList=datas;
    }else{
        self.dataList=self.dataProvider.dataList;
    }
    [self.tableView reloadData];
}
- (void)dealloc {
    [TUICore unRegisterEventByObject:self];
}

- (TUIConversationListDataProvider *)dataProvider {
    if (!_dataProvider) {
        _dataProvider = [TUIConversationListDataProvider new];
        _dataProvider.delegate = self;
        [_dataProvider loadConversation];
    }
    return _dataProvider;
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
//    [self showSearchVC];
   
    return YES;
}
- (void)textFieldDidChangeSelection:(UITextField *)textField{
    NSLog(@"text:%@",textField.text);
    [self buildDataList];
//    [self.tableView reloadData];
}
#pragma mark - Private

- (void)showSearchVC {
//    TUISearchViewController *vc = [[TUISearchViewController alloc] init];
//    TUINavigationController *nav = [[TUINavigationController alloc] initWithRootViewController:(UIViewController *)vc];
//    nav.modalPresentationStyle = UIModalPresentationFullScreen;
//    [self.parentViewController presentViewController:nav animated:NO completion:nil];
    
    YCTAddFriendsViewController *vc = [[YCTAddFriendsViewController alloc] init];
    [self.parentViewController.navigationController pushViewController:vc animated:YES];
}

- (void)requestBasicMsg {
    YCTApiBasicMsg *api = [[YCTApiBasicMsg alloc] init];
    [api startWithCompletionBlockWithSuccess:^(__kindof YCTBaseRequest * _Nonnull request) {
        YCTBasicMsgModel *model = request.responseDataModel;
        
        self.interactionMsgsData.subTitleString = model.interactionMsg;
        self.interactionMsgsData.timeString = @"";
        self.interactionMsgsData.unreadCount = model.isReadInteractionMsg ? 1 : 0;
        
        self.fansMsgsData.subTitleString = model.fansMsg;
        self.fansMsgsData.timeString = @"";
        self.fansMsgsData.unreadCount = 0;
        
        self.systemMsgsData.subTitleString = model.noticeMsg;
        self.systemMsgsData.timeString = @"";
        self.systemMsgsData.unreadCount = model.isReadNoticeMsg ? 1 : 0;
        
    } failure:NULL];
    self.apiBasicMsg = api;
}

#pragma mark - TUIConversationListDataProviderDelegate

- (NSString *)getConversationDisplayString:(V2TIMConversation *)conversation {
    if (self.delegate && [self.delegate respondsToSelector:@selector(getConversationDisplayString:)]) {
        return [self.delegate getConversationDisplayString:conversation];
    }
    return nil;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if(![self.searchView.textField.text isEqual:@""]){
        return 1;
    }
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0 && [self.searchView.textField.text isEqual:@""]) {
        return 3;
    }
    return self.dataList.count;
//    return self.dataProvider.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && [self.searchView.textField.text isEqual:@""]) {
        YCTConversationCell *cell = [tableView dequeueReusableCellWithIdentifier:kConversationCell_ReuseId forIndexPath:indexPath];
        if (indexPath.row == 0) {
            [cell fillWithYctData:self.interactionMsgsData];
        }
        else if (indexPath.row == 1) {
            [cell fillWithYctData:self.fansMsgsData];
        }
        else if (indexPath.row == 2) {
            [cell fillWithYctData:self.systemMsgsData];
        }
        cell.changeColorWhenTouched = NO;
        
        return cell;
    }
    else {
        YCTConversationCell *cell = [tableView dequeueReusableCellWithIdentifier:kConversationCell_ReuseId forIndexPath:indexPath];
        TUIConversationCellData *data = [self.dataList objectAtIndex:indexPath.row];
        if (!data.cselector) {
            data.cselector = @selector(didSelectConversation:);
        }
        [cell fillWithData:data];
        cell.changeColorWhenTouched = NO;
        return cell;
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && [self.searchView.textField.text isEqual:@""]) {
        return NO;
    }
    return YES;
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (@available(iOS 11.0, *)) {
        return nil;
    }
    
    NSMutableArray *rowActions = [NSMutableArray array];
    TUIConversationCellData *cellData = self.dataProvider.dataList[indexPath.row];
    __weak typeof(self) weakSelf = self;
    
    {
        UITableViewRowAction *action = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:YCTLocalizedTableString(@"chat.deleteChat", @"Chat") handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
            
            
            [UIAlertController showAlertInViewController:weakSelf withTitle:nil message:YCTLocalizedTableString(@"chat.deleteChatTips", @"Chat") cancelButtonTitle:YCTLocalizedString(@"action.cancel") destructiveButtonTitle:nil otherButtonTitles:@[YCTLocalizedString(@"action.confirm")] tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
                if (buttonIndex != controller.cancelButtonIndex) {
                    [tableView beginUpdates];
                    [weakSelf.dataProvider removeData:cellData];
                    [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationNone];
                    [tableView endUpdates];
                }
            }];
        }];
        action.backgroundColor = RGB(242, 77, 76);
        [rowActions addObject:action];
    }
    
    {
        UITableViewRowAction *action = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:cellData.isOnTop ? YCTLocalizedTableString(@"chat.cancelStickOnTop", @"Chat") : YCTLocalizedTableString(@"chat.stickOnTop", @"Chat") handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
            if (cellData.isOnTop) {
                [TUIConversationPin.sharedInstance removeTopConversation:cellData.conversationID callback:nil];
            } else {
                [TUIConversationPin.sharedInstance addTopConversation:cellData.conversationID callback:nil];
            }
        }];
        action.backgroundColor = RGB(242, 147, 64);
        [rowActions addObject:action];
    }
    
    {
        UITableViewRowAction *action = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:YCTLocalizedTableString(@"chat.clearChat", @"Chat") handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
    
            [UIAlertController showAlertInViewController:weakSelf withTitle:nil message:YCTLocalizedTableString(@"chat.clearAllChatHistoryTips", @"Chat") cancelButtonTitle:YCTLocalizedString(@"action.cancel") destructiveButtonTitle:nil otherButtonTitles:@[YCTLocalizedString(@"action.confirm")] tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
                if (buttonIndex != controller.cancelButtonIndex) {
                    if (cellData.groupID.length) {
                        [weakSelf.dataProvider clearGroupHistoryMessage:cellData.groupID];
                    } else {
                        [weakSelf.dataProvider clearC2CHistoryMessage:cellData.userID];
                    }
                }
            }];
        }];
        action.backgroundColor = RGB(32, 124, 231);
        [rowActions addObject:action];
    }
    return rowActions;
}

- (UISwipeActionsConfiguration *)tableView:(UITableView *)tableView trailingSwipeActionsConfigurationForRowAtIndexPath:(NSIndexPath *)indexPath API_AVAILABLE(ios(11.0)) {
    __weak typeof(self) weakSelf = self;
    TUIConversationCellData *cellData = self.dataProvider.dataList[indexPath.row];
    NSMutableArray *arrayM = [NSMutableArray array];
    [arrayM addObject:({
        UIContextualAction *action = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleDestructive title:YCTLocalizedTableString(@"chat.deleteChat", @"Chat") handler:^(UIContextualAction * _Nonnull action, __kindof UIView * _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)) {
            
            [UIAlertController showAlertInViewController:weakSelf withTitle:nil message:YCTLocalizedTableString(@"chat.deleteChatTips", @"Chat") cancelButtonTitle:YCTLocalizedString(@"action.cancel") destructiveButtonTitle:nil otherButtonTitles:@[YCTLocalizedString(@"action.confirm")] tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
                if (buttonIndex != controller.cancelButtonIndex) {
                    [tableView beginUpdates];
                    [weakSelf.dataProvider removeData:cellData];
                    [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationNone];
                    [tableView endUpdates];
                }
            }];
        }];
        action.backgroundColor = RGB(242, 77, 76);
        action;
    })];
    
    [arrayM addObject:({
        UIContextualAction *action = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleNormal title:cellData.isOnTop ? YCTLocalizedTableString(@"chat.cancelStickOnTop", @"Chat") : YCTLocalizedTableString(@"chat.stickOnTop", @"Chat") handler:^(UIContextualAction * _Nonnull action, __kindof UIView * _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)) {
            if (cellData.isOnTop) {
                [TUIConversationPin.sharedInstance removeTopConversation:cellData.conversationID callback:nil];
            } else {
                [TUIConversationPin.sharedInstance addTopConversation:cellData.conversationID callback:nil];
            }
        }];
        action.backgroundColor = RGB(242, 147, 64);
        action;
    })];
    
    [arrayM addObject:({
        UIContextualAction *action = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleNormal title:YCTLocalizedTableString(@"chat.clearChat", @"Chat") handler:^(UIContextualAction * _Nonnull action, __kindof UIView * _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)) {
            
            [UIAlertController showAlertInViewController:weakSelf withTitle:nil message:YCTLocalizedTableString(@"chat.clearAllChatHistoryTips", @"Chat") cancelButtonTitle:YCTLocalizedString(@"action.cancel") destructiveButtonTitle:nil otherButtonTitles:@[YCTLocalizedString(@"action.confirm")] tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
                if (buttonIndex != controller.cancelButtonIndex) {
                    if (cellData.groupID.length) {
                        [weakSelf.dataProvider clearGroupHistoryMessage:cellData.groupID];
                    } else {
                        [weakSelf.dataProvider clearC2CHistoryMessage:cellData.userID];
                    }
                }
            }];
        }];
        action.backgroundColor = RGB(32, 124, 231);
        action;
    })];
    
    UISwipeActionsConfiguration *configuration = [UISwipeActionsConfiguration configurationWithActions:[NSArray arrayWithArray:arrayM]];
    configuration.performsFirstActionWithFullSwipe = NO;
    return configuration;
}

- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

- (void)didSelectConversation:(YCTConversationCell *)cell {
    if (self.delegate && [self.delegate respondsToSelector:@selector(conversationListController:didSelectConversation:)]) {
        [self.delegate conversationListController:self didSelectConversation:cell];
    }
}

- (void)didSelectInteractionMsg:(YCTConversationCell *)cell {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectInteractiveMsgs)]) {
        [self.delegate didSelectInteractiveMsgs];
    }
}

- (void)didSelectFansMsg:(YCTConversationCell *)cell {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectFansMsgs)]) {
        [self.delegate didSelectFansMsgs];
    }
}

- (void)didSelectSystemMsg:(YCTConversationCell *)cell {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectSystemNoticationMsgs)]) {
        [self.delegate didSelectSystemNoticationMsgs];
    }
}

- (UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller {
    return UIModalPresentationNone;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self.dataProvider loadConversation];
}

@end

