//
//  YCTCommentViewController.m
//  YCT
//
//  Created by hua-cloud on 2021/12/18.
//

#import "YCTCommentViewController.h"
#import "YCTCommentCell.h"
#import "YCTCommentHeaderView.h"
#import "YCTCommentFooterView.h"
#import "YCTCommentViewModel.h"
#import "YCTDragPresentView.h"
#import "YCTFeedBackViewController.h"
#import <IQKeyboardManager.h>
#import "UIScrollView+YCTEmptyView.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import "YCTCommentPopView.h"

@interface YCTCommentViewController ()<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>
@property (nonatomic, copy) NSString * videoId;
@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) UITextField * commentTextField;
@property (nonatomic, strong) UIButton * emojiButton;
@property (nonatomic, strong) UIButton * closeButton;
@property (nonatomic, strong) UILabel * commentCount;
@property (nonatomic, strong) UIView * bottomView;

@property (nonatomic, strong) YCTCommentViewModel * viewModel;
@end

@implementation YCTCommentViewController
- (instancetype)initWithVideoId:(NSString *)videoId commentCount:(NSInteger)commentCount;
{
    self = [super init];
    if (self) {
        self.videoId = videoId;
        self.viewModel = [[YCTCommentViewModel alloc] initWithVideoId:self.videoId commentCount:commentCount];
        self.modalPresentationStyle = UIModalPresentationOverFullScreen;
        self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor clearColor];
    //增加监听，当键盘出现或改变时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillShow:)
                                                     name:UIKeyboardWillShowNotification
                                                   object:nil];
    
        //增加监听，当键退出时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillHide:)
                                                     name:UIKeyboardWillHideNotification
                                                   object:nil];
}


- (void)setupView{
    UIView * tableContainer = [UIView new];
    tableContainer.backgroundColor = UIColor.whiteColor;
    tableContainer.layer.cornerRadius = 20;
    
    [tableContainer addSubview:self.tableView];
    [tableContainer addSubview:self.closeButton];
    [tableContainer addSubview:self.commentCount];
    [self.view addSubview:tableContainer];
    [self.view addSubview:self.bottomView];
    
    [tableContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_offset(0.f);
    }];
    
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(55);
        make.left.right.offset(0);
        make.bottom.mas_equalTo(- [UIApplication sharedApplication].delegate.window.safeBottom);
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(55);
        make.left.right.mas_offset(0);
        make.bottom.mas_offset(-55 - [UIApplication sharedApplication].delegate.window.safeBottom);
    }];
    
    [self.commentCount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(tableContainer);
        make.top.mas_offset(18);
    }];
    
    [self.closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_offset(-1);
        make.top.mas_offset(1);
        make.size.mas_equalTo(CGSizeMake(44, 44));
    }];
}

- (void)bindViewModel{
    @weakify(self);
    self.tableView.mj_footer = [YCTRefreshFooter footerWithRefreshingBlock:^{
        [self.viewModel loadMore];
    }];

    [[[RACObserve(self.viewModel, commentViewModel) map:^id _Nullable(YCTCommentItemViewModel *  _Nullable value) {
        return [RACObserve(value, subComment) skip:1];
    }] switchToLatest] subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        NSInteger sectionIndex = [self.viewModel.commentViewModels indexOfObject:self.viewModel.commentViewModel];
        [UIView performWithoutAnimation:^{
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationNone];
        }];
    }];
    
    [RACObserve(self.viewModel, commentViewModels) subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        [self.tableView reloadData];
        
        if (self.commentTextField.isFirstResponder) {
            self.commentTextField.text = @"";
            [self.commentTextField endEditing:YES];
        }
    }];
    
    RAC(self.emojiButton, enabled) = [[RACSignal merge:@[RACObserve(self.commentTextField, text),self.commentTextField.rac_textSignal]] map:^id _Nullable(id  _Nullable value) {
        @strongify(self);
        return @(self.commentTextField.text.length);
    }];;
    
    [RACObserve(self.emojiButton, enabled) subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        [self.emojiButton setTitleColor:[x boolValue] ? UIColor.mainTextColor : UIColor.mainGrayTextColor forState:UIControlStateNormal];
    }];
    
    RAC(self.commentCount, text) = [RACObserve(self.viewModel, commentCount) map:^id _Nullable(id  _Nullable value) {
        return [NSString stringWithFormat:YCTLocalizedTableString(@"comment.numberOfComments", @"Home"),[value integerValue]];
    }];
    
    [RACObserve(self.viewModel, commentCount) subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        !self.commentCountCallback ? : self.commentCountCallback(self.viewModel.commentCount);
    }];
    
    [self.viewModel.endFooterRefreshSubject subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        [x boolValue] ? [self.tableView.mj_footer endRefreshingWithNoMoreData] : [self.tableView.mj_footer endRefreshing];
    }];
    
    [[RACObserve(self.viewModel, commentViewModels) map:^id _Nullable(id  _Nullable value) {
        return @(!YCT_IS_VALID_ARRAY(value));
    }] subscribeNext:^(NSNumber *  _Nullable x) {
        @strongify(self);
        self.tableView.mj_footer.hidden = x.boolValue;
        if ([x boolValue]) {
            [self.tableView showEmptyViewWithImage:[UIImage imageNamed:@"comment_nodata"] emptyInfo:YCTLocalizedString(@"comment.nocomment")];
        }else{
            self.tableView.backgroundView = nil;
        }
    }] ;
    
    [self.viewModel.loadingSubject subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        [x boolValue] ? [self.tableView.superview showLoadingHud] : [self.tableView.superview hideHud];
        
    }];
    
    [self.viewModel.toastSubject subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        [self.tableView.superview showToastHud:x];
    }];
    
    [[self.closeButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        [[YCTDragPresentView sharePresentView] dismissWithCompletion:nil];
    }];
    
    [[self.emojiButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        [self.viewModel requestForPublishCommentWithContent:self.commentTextField.text];
        self.commentTextField.text = @"";
        [self.commentTextField endEditing:YES];
    }];
    
    [self.tableView setDismissOnClick];
}

#pragma mark - keyboard
- (void)keyboardWillShow:(NSNotification *)aNotification {
    //获取键盘的高度
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    int height = keyboardRect.size.height;   //height 就是键盘的高度
    [self.bottomView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_offset(- height);
    }];
    [UIView animateWithDuration:0.25 animations:^{
        [self.view layoutIfNeeded];
    }];
}
 
//当键退出时调用
- (void)keyboardWillHide:(NSNotification *)aNotification {
    [self.bottomView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_offset(- [UIApplication sharedApplication].delegate.window.safeBottom);
    }];
    [UIView animateWithDuration:0.25 animations:^{
        [self.view layoutIfNeeded];
    }];

    self.commentTextField.placeholder = YCTLocalizedTableString(@"comment.LeaveAComment", @"Home");
}
#pragma mark - UITextfiledDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.viewModel requestForPublishCommentWithContent:textField.text];
    textField.text = @"";
    [textField endEditing:YES];
    return YES;
}
#pragma mark - UITableViewDeleagate&dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.viewModel.commentViewModels.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    YCTCommentItemViewModel * item = self.viewModel.commentViewModels[section];
    return item.subComment.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    YCTCommentItemViewModel * item = self.viewModel.commentViewModels[section];
    return [YCTCommentHeaderView heightWithContentText:item.content];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    YCTCommentItemViewModel * item = self.viewModel.commentViewModels[section];
    return item.fold ? 34.f : CGFLOAT_MIN;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    YCTCommentItemViewModel * item = self.viewModel.commentViewModels[section];
    YCTCommentHeaderView * comment = [tableView dequeueReusableHeaderFooterViewWithIdentifier:NSStringFromClass([YCTCommentHeaderView class])];

    [comment.avatar sd_setImageWithURL:[NSURL URLWithString:item.avatarUrl]];
    comment.nickName.text = item.nikeName;
    comment.content.text = item.content;
    comment.timeLabel.text = item.publishTime;
    comment.likeButton.selected = item.isZan;
    comment.markTag.text = item.markTag;
    comment.markTag.backgroundColor = item.markTagColor;
    comment.likeCount.text = item.zanCount;
    comment.isZaning.hidden = !item.isZaning;
    comment.likeContainer.hidden = item.isZaning;
    RAC(comment.isZaning, hidden) = [[RACObserve(item, isZaning) takeUntil:comment.rac_prepareForReuseSignal] map:^id _Nullable(id  _Nullable value) {
        return @(!item.isZaning);
    }];
    
    RAC(comment.likeContainer, hidden) = [RACObserve(item, isZaning) takeUntil:comment.rac_prepareForReuseSignal];
    RAC(comment.likeCount, text) = [RACObserve(item, zanCount) takeUntil:comment.rac_prepareForReuseSignal];
    RAC(comment.likeButton, selected) = [RACObserve(item, isZan) takeUntil:comment.rac_prepareForReuseSignal];
    [RACObserve(item, isZaning) subscribeNext:^(id  _Nullable x) {
        if ([x boolValue]) {
            [comment.isZaning startAnimating];
        }else{
            [comment.isZaning stopAnimating];
        }
    }];
    @weakify(self);
    [comment setTapGesHandler:^{
        @strongify(self);
        self.viewModel.commentViewModel = item;
        self.commentTextField.placeholder = [NSString stringWithFormat:YCTLocalizedTableString(@"comment.replyTo", @"Home"),item.nikeName];
        [self.commentTextField becomeFirstResponder];
    }];
    [comment setAvatarTapGesHandler:^{
        NSLog(@"userId:%@",item.commentModel.userId);
        [[YCTDragPresentView sharePresentView] dismissWithCompletion:nil];
        self.onGoUser(item.commentModel.userId);

    }];
    [[[comment.likeButton rac_signalForControlEvents:UIControlEventTouchUpInside] takeUntil:comment.rac_prepareForReuseSignal] subscribeNext:^(__kindof UIControl * _Nullable x) {
        [item requestForZan];
    }];
    
    [comment setLongGesHandler:^{
        YCTCommentPopView * pop = [YCTCommentPopView new];
        @weakify(self);
        [pop setHandlerClick:^(YCTCommentPopViewSelectedType type) {
            @strongify(self);
            if (type == YCTCommentPopViewSelectedTypeReply) {
                self.viewModel.commentViewModel = item;
                self.commentTextField.placeholder = [NSString stringWithFormat:YCTLocalizedTableString(@"comment.replyTo", @"Home"),item.nikeName];
                [self.commentTextField becomeFirstResponder];
            }else if (type == YCTCommentPopViewSelectedTypeCopy){
                UIPasteboard * pastboard = [UIPasteboard generalPasteboard];
                pastboard.string = item.content;
                [self.view showSuccessHud:YCTLocalizedString(@"alert.paste")];
            }else if (type == YCTCommentPopViewSelectedTypeReport){
                YCTFeedBackViewController * report = [[YCTFeedBackViewController alloc] initWithReportType:YCTReportTypeVideo reportId:item.commentModel.id];
                UINavigationController * nav = [[UINavigationController alloc] initWithRootViewController:report];
                nav.modalPresentationStyle = UIModalPresentationFullScreen;
                [self presentViewController:nav animated:YES completion:nil];
            }else{
                [UIView showAlertSheetWith:YCTLocalizedString(@"alert.addBlacklist") clickAction:^{
                    [item requestForBlackList];
                }];
            }
        }];
        [pop yct_showAlertStyle];
    }];
    
    [[item.loadingSubject takeUntil:comment.rac_prepareForReuseSignal] subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        [x boolValue] ? [self.view showLoadingHud] : [self.view hideHud];
    }];
    
    [[item.toastSubject takeUntil:comment.rac_prepareForReuseSignal] subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        [self.view showToastHud:x];
    }];
    return comment;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    YCTCommentItemViewModel * item = self.viewModel.commentViewModels[section];
    YCTCommentFooterView * unfold = [tableView dequeueReusableHeaderFooterViewWithIdentifier:NSStringFromClass([YCTCommentFooterView class])];
    unfold.contentView.hidden = !item.fold;
    
    @weakify(item,self);
    [unfold responseForTap:^{
        @strongify(item,self);
        self.viewModel.commentViewModel = item;
        [item requestForSubComment];
    }];
    return unfold;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YCTCommentItemViewModel * commentItem = self.viewModel.commentViewModels[indexPath.section];
    YCTCommentItemViewModel * subCommentItem = commentItem.subComment[indexPath.row];
    YCTCommentCell * cell = [tableView dequeueReusableCellWithIdentifier:YCTCommentCell.cellReuseIdentifier forIndexPath:indexPath];
    [cell.avatar sd_setImageWithURL:[NSURL URLWithString:subCommentItem.avatarUrl]];
    cell.nickName.text = subCommentItem.nikeName;
    cell.content.text = subCommentItem.content;
    cell.time.text = subCommentItem.publishTime;
    cell.replyIcon.hidden = subCommentItem.replyNickName.length <= 0;
    cell.replyNickName.text = subCommentItem.replyNickName;
    cell.isZaning.hidden = !subCommentItem.isZaning;
    cell.likeContainer.hidden = subCommentItem.isZaning;
    RAC(cell.isZaning, hidden) = [[RACObserve(subCommentItem, isZaning) takeUntil:cell.rac_prepareForReuseSignal] map:^id _Nullable(id  _Nullable value) {
        return @(!subCommentItem.isZaning);
    }];
    
    RAC(cell.likeContainer, hidden) = [RACObserve(subCommentItem, isZaning) takeUntil:cell.rac_prepareForReuseSignal];
    RAC(cell.likeCount, text) = [RACObserve(subCommentItem, zanCount) takeUntil:cell.rac_prepareForReuseSignal];
    RAC(cell.likeButton, selected) = [RACObserve(subCommentItem, isZan) takeUntil:cell.rac_prepareForReuseSignal];
    
    [RACObserve(subCommentItem, isZaning) subscribeNext:^(id  _Nullable x) {
        if ([x boolValue]) {
            [cell.isZaning startAnimating];
        }else{
            [cell.isZaning stopAnimating];
        }
    }];
    
    @weakify(self);
    [cell setTapGesHandler:^{
        @strongify(self);
        self.viewModel.commentViewModel = commentItem;
        self.viewModel.subCommentViewModel = subCommentItem;
        self.commentTextField.placeholder = [NSString stringWithFormat:YCTLocalizedTableString(@"comment.replyTo", @"Home"),subCommentItem.nikeName];
        [self.commentTextField becomeFirstResponder];
    }];
    [cell setAvatarTapGesHandler:^{
        NSLog(@"点击了头像");
    }];
    [[[cell.likeButton rac_signalForControlEvents:UIControlEventTouchUpInside] takeUntil:cell.rac_prepareForReuseSignal] subscribeNext:^(__kindof UIControl * _Nullable x) {
        [subCommentItem requestForZan];
    }];
    [cell setAvatarTapGesHandler:^{
        NSLog(@"222222");
    }];
    [cell setLongGesHandler:^{
        YCTCommentPopView * pop = [YCTCommentPopView new];
        @weakify(self);
        [pop setHandlerClick:^(YCTCommentPopViewSelectedType type) {
            @strongify(self);
            if (type == YCTCommentPopViewSelectedTypeReply) {
                self.viewModel.commentViewModel = commentItem;
                self.viewModel.subCommentViewModel = subCommentItem;
                self.commentTextField.placeholder = [NSString stringWithFormat:YCTLocalizedTableString(@"comment.replyTo", @"Home"),subCommentItem.nikeName];
                [self.commentTextField becomeFirstResponder];
            }else if (type == YCTCommentPopViewSelectedTypeCopy){
                UIPasteboard * pastboard = [UIPasteboard generalPasteboard];
                pastboard.string = subCommentItem.content;
                [self.view showToastHud:YCTLocalizedString(@"alert.paste")];
            }else if (type == YCTCommentPopViewSelectedTypeReport){
                YCTFeedBackViewController * report = [[YCTFeedBackViewController alloc] initWithReportType:YCTReportTypeVideo reportId:subCommentItem.commentModel.id];
                UINavigationController * nav = [[UINavigationController alloc] initWithRootViewController:report];
                nav.modalPresentationStyle = UIModalPresentationFullScreen;
                [self presentViewController:nav animated:YES completion:nil];
            }else{
                [UIView showAlertSheetWith:YCTLocalizedString(@"alert.addBlacklist") clickAction:^{
                    [subCommentItem requestForBlackList];
                }];
            }
        }];
        [pop yct_showAlertStyle];
    }];
    
    [[subCommentItem.loadingSubject takeUntil:cell.rac_prepareForReuseSignal] subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        [x boolValue] ? [self.view showLoadingHud] : [self.view hideHud];
    }];
    
    [[subCommentItem.toastSubject takeUntil:cell.rac_prepareForReuseSignal] subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        [self.view showToastHud:x];
    }];
    
    cell.avatar.userInteractionEnabled=YES;
    cell.avatar.tag=indexPath.row;
    [cell.avatar addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goUserInfo:)]];
    
    
    return cell;
}
-(void)goUserInfo:(id)sender{
    NSLog(@"12122");
}




#pragma mark - getter

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
        _tableView.backgroundColor = UIColor.tableBackgroundColor;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedRowHeight = 44;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerNib:YCTCommentCell.nib forCellReuseIdentifier:YCTCommentCell.cellReuseIdentifier];
        [_tableView registerClass:[YCTCommentHeaderView class] forHeaderFooterViewReuseIdentifier:NSStringFromClass([YCTCommentHeaderView class])];
        [_tableView registerClass:[YCTCommentFooterView class] forHeaderFooterViewReuseIdentifier:NSStringFromClass([YCTCommentFooterView class])];
    }
    return _tableView;
}

- (UITextField *)commentTextField{
    if (!_commentTextField) {
        _commentTextField = [[UITextField alloc] init];
        CGRect frame = CGRectMake(0, 0, 15, 1);//f表示你的textField的frame
        UIView *leftview = [[UIView alloc] initWithFrame:frame];
        _commentTextField.leftViewMode = UITextFieldViewModeAlways;//设置左边距显示的时机，这个表示一直显示
        _commentTextField.returnKeyType = UIReturnKeySend;
        _commentTextField.leftView = leftview;
        _commentTextField.backgroundColor = UIColorFromRGB(0xF8F8F8);
        _commentTextField.textColor = UIColorFromRGB(0x2C2C2C);
        _commentTextField.borderStyle = UITextBorderStyleNone;
        _commentTextField.placeholder = YCTLocalizedTableString(@"comment.LeaveAComment", @"Home");
        _commentTextField.layer.cornerRadius = 19.5;
        _commentTextField.enablesReturnKeyAutomatically = YES;
        _commentTextField.delegate = self;
    }
    return _commentTextField;
}

- (UIButton *)emojiButton{
    if (!_emojiButton) {
        _emojiButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _emojiButton.titleLabel.font = [UIFont systemFontOfSize:12.f weight:UIFontWeightMedium];
        [_emojiButton setTitle:YCTLocalizedString(@"comment.pub") forState:UIControlStateNormal];
        [_emojiButton setTitleColor:UIColor.mainTextColor forState:UIControlStateNormal];
    }
    return _emojiButton;
}

- (UIButton *)closeButton{
    if (!_closeButton) {
        _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeButton setImage:[UIImage imageNamed:@"comment_close"] forState:UIControlStateNormal];
    }
    return _closeButton;
}

- (UILabel *)commentCount{
    if (!_commentCount) {
        _commentCount = [UILabel new];
        _commentCount.textColor = UIColor.blackColor;
        _commentCount.font = [UIFont systemFontOfSize:12 weight:UIFontWeightBold];
        _commentCount.text = [NSString stringWithFormat:YCTLocalizedTableString(@"comment.numberOfComments", @"Home"),0];
    }
    return _commentCount;
}

- (UIView *)bottomView{
    if (!_bottomView) {
        _bottomView = [UIView new];
        _bottomView.backgroundColor = UIColor.whiteColor;
        [_bottomView addSubview:self.commentTextField];
        [_bottomView addSubview:self.emojiButton];
        [self.commentTextField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_offset(15);
            make.center.equalTo(_bottomView);
            make.right.equalTo(self.emojiButton.mas_left).mas_offset(-9);
            make.height.mas_equalTo(39);
        }];
        
        [self.emojiButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_offset(-9);
            make.size.mas_equalTo(CGSizeMake(44, 44));
            make.centerY.equalTo(_bottomView);
        }];
    }
    return _bottomView;
}
@end
