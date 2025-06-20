//
//  TUIBaseChatViewController.m
//  UIKit
//
//  Created by annidyfeng on 2019/5/21.
//

#import "TUIBaseChatViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>
#import "ReactiveObjC/ReactiveObjC.h"
#import "TUIMessageController.h"
#import "TUIImageMessageCellData.h"
#import "TUIVideoMessageCellData.h"
#import "TUIFileMessageCellData.h"
#import "TUIVoiceMessageCellData.h"
#import "TUIDefine.h"
#import "TUIMessageMultiChooseView.h"
#import "TUIMessageSearchController.h"
#import "TUIChatDataProvider.h"
#import "TUIMessageDataProvider.h"
#import "TUICameraViewController.h"
#import "TUITool.h"
#import "TUICore.h"
#import "TUIDefine.h"
#import "NSDictionary+TUISafe.h"
#import "NSString+emoji.h"

@interface TUIBaseChatViewController () <TUIMessageControllerDelegate, TInputControllerDelegate, UIImagePickerControllerDelegate, UIDocumentPickerDelegate, UINavigationControllerDelegate, TUIMessageMultiChooseViewDelegate, TUIChatDataProviderForwardDelegate, TUICameraViewControllerDelegate, TUINotificationProtocol>
@property (nonatomic, strong) TUIMessageMultiChooseView *multiChooseView;
@property (nonatomic, assign) BOOL responseKeyboard;
// @{@"serviceID" : serviceID, @"title" : @"视频通话", @"image" : image}
@property (nonatomic, strong) NSMutableArray<NSDictionary *> *resgisterParam;
@property (nonatomic, strong) TUIChatDataProvider *dataProvider;

@property (nonatomic, weak) UIViewController *forwardConversationSelectVC;
@property (nonatomic) NSArray<TUIMessageCellData *> *forwardSelectUIMsgs;
@property (nonatomic) BOOL isMergeForward;

@property (nonatomic, assign) BOOL firstAppear;

@end

@implementation TUIBaseChatViewController

#pragma mark - Life Cycle
- (instancetype)init {
    self = [super init];
    if (self) {
        [TUIBaseChatViewController createCachePath];

        if (NSClassFromString(@"TUIKitLive")) {
            self.isEnableLive = YES;
        }
        self.isEnableVideoCall= YES;
        self.isEnableAudioCall= YES;
        self.isEnableLink = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.firstAppear = YES;
    self.view.backgroundColor = [UIColor d_colorWithColorLight:TController_Background_Color dark:TController_Background_Color_Dark];

    //message
//    if (self.locateMessage) {
        TUIMessageSearchController *vc = [[TUIMessageSearchController alloc] init];
        vc.hightlightKeyword = self.highlightKeyword;
        vc.locateMessage = self.locateMessage;
        _messageController = vc;
        
//    }else {
//        _messageController = [[TUIMessageController alloc] init];
//    }
    _messageController.delegate = self;
    [_messageController setConversation:self.conversationData];
    _messageController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - TTextView_Height - Bottom_SafeHeight);
    [self addChildViewController:_messageController];
    [self.view addSubview:_messageController.view];

    //input
    _inputController = [[TUIInputController alloc] init];
    _inputController.delegate = self;
    @weakify(self)
    [RACObserve(self, moreMenus) subscribeNext:^(NSArray *x) {
        @strongify(self)
        [self.inputController.moreView setData:x];
    }];
    _inputController.view.frame = CGRectMake(0, self.view.frame.size.height - TTextView_Height - Bottom_SafeHeight, self.view.frame.size.width, TTextView_Height + Bottom_SafeHeight);
    _inputController.view.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    [self addChildViewController:_inputController];
    [self.view addSubview:_inputController.view];
    
    // data provider
    self.dataProvider = [[TUIChatDataProvider alloc] init];
    self.dataProvider.forwardDelegate = self;
    
    // 注册会话选择完成监听
    [TUICore registerEvent:TUICore_TUIConversationNotify subKey:TUICore_TUIConversationNotify_SelectConversationSubKey object:self];
}

- (void)dealloc {    
    [TUICore unRegisterEventByObject:self];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.responseKeyboard = YES;
    if (self.firstAppear) {
        [self loadDraft];
        self.firstAppear = NO;
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.responseKeyboard = NO;
    [self openMultiChooseBoard:NO];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    if (self.inputController.status == Input_Status_Input ||
        self.inputController.status == Input_Status_Input_Keyboard) {
        // 在后台默默关闭键盘 + 调整 tableview 的尺寸为全屏
        CGPoint offset = self.messageController.tableView.contentOffset;
        __weak typeof(self) weakSelf = self;
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.responseKeyboard = YES;
            [UIApplication.sharedApplication.keyWindow endEditing:YES];
            [weakSelf inputController:weakSelf.inputController didChangeHeight:CGRectGetMaxY(weakSelf.inputController.inputBar.frame) + Bottom_SafeHeight];
            [weakSelf.messageController.tableView setContentOffset:offset];
        });
    }
}

- (void)willMoveToParentViewController:(UIViewController *)parent
{
    if (parent == nil) {
        [self saveDraft];
    }
}

#pragma mark - Public Methods

- (void)sendMessage:(V2TIMMessage *)message
{
    [self.messageController sendMessage:message];
}

- (void)saveDraft
{
    NSString *content = self.inputController.inputBar.inputTextView.text;
    if (self.inputController.replyData) {
        NSDictionary *dict = @{
            @"content" : content?:@"",
            @"messageReply" : @{
                    @"messageID"       : self.inputController.replyData.msgID?:@"",
                    @"messageAbstract" : [self.inputController.replyData.msgAbstract?:@"" getInternationalStringWithfaceContent],
                    @"messageSender"   : self.inputController.replyData.sender?:@"",
                    @"messageType"     : @(self.inputController.replyData.type),
                    @"version"         : @(kDraftMessageReplyVersion)
            }
        };
        NSError *error = nil;
        NSData *data = [NSJSONSerialization dataWithJSONObject:dict options:0 error:&error];
        if (error == nil) {
            content = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        }
    }
    [TUIChatDataProvider saveDraftWithConversationID:self.conversationData.conversationID Text:content];
}

- (void)loadDraft
{
    NSString *draft = self.conversationData.draftText;
    if (draft.length == 0) {
        return;
    }
    
    NSError *error = nil;
    NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:[draft dataUsingEncoding:NSUTF8StringEncoding] options:0 error:&error];
    if (error || jsonDict == nil) {
        self.inputController.inputBar.inputTextView.text = draft;
        return;
    }
    
    // 显示草稿
    NSString *draftContent = [jsonDict.allKeys containsObject:@"content"] ? jsonDict[@"content"] : @"";
    self.inputController.inputBar.inputTextView.text = draftContent;
    
    // 显示消息回复预览
    if ([jsonDict isKindOfClass:NSDictionary.class] && [jsonDict.allKeys containsObject:@"messageReply"]) {
        NSDictionary *reply = jsonDict[@"messageReply"];
        if ([reply isKindOfClass:NSDictionary.class] &&
            [reply.allKeys containsObject:@"messageID"] &&
            [reply.allKeys containsObject:@"messageAbstract"] &&
            [reply.allKeys containsObject:@"messageSender"] &&
            [reply.allKeys containsObject:@"messageType"] &&
            [reply.allKeys containsObject:@"version"]) {
            NSInteger version = [reply[@"version"] integerValue];
            if (version <= kDraftMessageReplyVersion) {
                TUIReplyPreviewData *replyData = [[TUIReplyPreviewData alloc] init];
                replyData.msgID       = reply[@"messageID"];
                replyData.msgAbstract = reply[@"messageAbstract"];
                replyData.sender      = reply[@"messageSender"];
                replyData.type        = [reply[@"messageType"] integerValue];
                [self.inputController showReplyPreview:replyData];
            }
        }
    }
}

#pragma mark - Getters & Setters

- (void)setConversationData:(TUIChatConversationModel *)conversationData {
    _conversationData = conversationData;
    self.resgisterParam = [NSMutableArray array];
    _moreMenus = ({
        // TUIKit 组件内部自定义按钮
        NSMutableArray<TUIInputMoreCellData *> *moreMenus = [TUIChatDataProvider moreMenuCellDataArray:conversationData.groupID userID:conversationData.userID isNeedVideoCall:self.isEnableVideoCall isNeedAudioCall:self.isEnableAudioCall isNeedGroupLive:self.isEnableLive isNeedLink:self.isEnableLink];
        
        NSMutableArray *highMenus = [NSMutableArray array];
        NSMutableArray *nomalMenus = [NSMutableArray array];
        NSMutableArray *lowMenus = [NSMutableArray array];
        NSMutableArray *lowestMenus = [NSMutableArray array];
        
        // 获取 TUIKit 组件外部注册的 more cell
        if (self.delegate && [self.delegate respondsToSelector:@selector(chatController:onRegisterMoreCell:)]) {
            MoreCellPriority priority;
            NSArray <TUIInputMoreCellData *> *dataList = [self.delegate chatController:self onRegisterMoreCell:&priority];
            if (dataList.count > 0) {
                if (priority == MoreCellPriority_High) {
                    [highMenus addObjectsFromArray:dataList];
                } else if (priority == MoreCellPriority_Nomal) {
                    [nomalMenus addObjectsFromArray:dataList];
                } else if (priority == MoreCellPriority_Low) {
                    [lowMenus addObjectsFromArray:dataList];
                }  else if (priority == MoreCellPriority_Lowest) {
                    [lowestMenus addObjectsFromArray:dataList];
                }
            }
        }
        
        [moreMenus addObjectsFromArray:highMenus];
        [moreMenus addObjectsFromArray:nomalMenus];
        [moreMenus addObjectsFromArray:lowMenus];
        [moreMenus addObjectsFromArray:lowestMenus];
        moreMenus;
    });
    
}

#pragma mark - TUICore

- (void)onNotifyEvent:(NSString *)key subKey:(NSString *)subKey object:(id)anObject param:(NSDictionary *)param {
    if ([key isEqualToString:TUICore_TUIConversationNotify]
        && [subKey isEqualToString:TUICore_TUIConversationNotify_SelectConversationSubKey]
        && self.forwardConversationSelectVC == anObject) {
        NSArray<NSDictionary *> *selectList = param[TUICore_TUIConversationNotify_SelectConversationSubKey_ConversationListKey];
        
        NSMutableArray<TUIChatConversationModel *> *targetList = [NSMutableArray arrayWithCapacity:selectList.count];
        for (NSDictionary *selectItem in selectList) {
            TUIChatConversationModel *model = [TUIChatConversationModel new];
            model.title = selectItem[TUICore_TUIConversationNotify_SelectConversationSubKey_ItemTitleKey];
            model.userID = selectItem[TUICore_TUIConversationNotify_SelectConversationSubKey_ItemUserIDKey];
            model.groupID = selectItem[TUICore_TUIConversationNotify_SelectConversationSubKey_ItemGroupIDKey];
            model.conversationID = selectItem[TUICore_TUIConversationNotify_SelectConversationSubKey_ItemConversationIDKey];
            [targetList addObject:model];
        }
        
        [self forwardMessages:self.forwardSelectUIMsgs toTargets:targetList merge:self.isMergeForward];
        self.forwardSelectUIMsgs = nil;
    }
}

#pragma mark - TInputControllerDelegate
- (void)inputController:(TUIInputController *)inputController didChangeHeight:(CGFloat)height
{
    if (!self.responseKeyboard) {
        return;
    }
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        CGRect msgFrame = self.messageController.view.frame;
        msgFrame.size.height = self.view.frame.size.height - height;
        self.messageController.view.frame = msgFrame;

        CGRect inputFrame = self.inputController.view.frame;
        inputFrame.origin.y = msgFrame.origin.y + msgFrame.size.height;
        inputFrame.size.height = height;
        self.inputController.view.frame = inputFrame;
        [self.messageController scrollToBottom:NO];
    } completion:nil];
}

- (void)inputController:(TUIInputController *)inputController didSendMessage:(V2TIMMessage *)msg
{
    [self.messageController sendMessage:msg];
    if (self.delegate && [self.delegate respondsToSelector:@selector(chatController:didSendMessage:)]) {
        [self.delegate chatController:self didSendMessage:msg];
    }
}

- (void)inputControllerDidInputAt:(TUIInputController *)inputController
{
    // 交给 GroupChatVC 去处理
}

- (void)inputController:(TUIInputController *)inputController didDeleteAt:(NSString *)atText
{
    // 交给 GroupChatVC 去处理
}

- (void)inputController:(TUIInputController *)inputController didSelectMoreCell:(TUIInputMoreCell *)cell
{
    cell.disableDefaultSelectAction = NO;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(chatController:onSelectMoreCell:)]) {
        [self.delegate chatController:self onSelectMoreCell:cell];
    }
    
    if (cell.disableDefaultSelectAction) {
        return;
    }
    if (cell.data == [TUIInputMoreCellData photoData]) {
        [self selectPhotoForSend];
    }
    else if (cell.data == [TUIInputMoreCellData videoData]) {
        [self takeVideoForSend];
    }
    else if (cell.data == [TUIInputMoreCellData fileData]) {
        [self selectFileForSend];
    }
    else if (cell.data == [TUIInputMoreCellData pictureData]) {
        [self takePictureForSend];
    }
}

#pragma mark - TUIMessageControllerDelegate
- (void)didTapInMessageController:(TUIMessageController *)controller
{
    [self.inputController reset];
}

- (BOOL)messageController:(TUIMessageController *)controller willShowMenuInCell:(TUIMessageCell *)cell
{
    if([self.inputController.inputBar.inputTextView isFirstResponder]){
        self.inputController.inputBar.inputTextView.overrideNextResponder = cell;
        return YES;
    }
    return NO;
}

- (TUIMessageCellData *)messageController:(TUIMessageController *)controller onNewMessage:(V2TIMMessage *)message
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(chatController:onNewMessage:)]) {
        return [self.delegate chatController:self onNewMessage:message];
    }
    return nil;
}

- (TUIMessageCell *)messageController:(TUIMessageController *)controller onShowMessageData:(TUIMessageCellData *)data
{
    if ([self.delegate respondsToSelector:@selector(chatController:onShowMessageData:)]) {
        return [self.delegate chatController:self onShowMessageData:data];
    }
    return nil;
}

- (void)messageController:(TUIMessageController *)controller willDisplayCell:(TUIMessageCell *)cell withData:(TUIMessageCellData *)cellData {
    if ([self.delegate respondsToSelector:@selector(chatController:willDisplayCell:withData:)]) {
        [self.delegate chatController:self willDisplayCell:cell withData:cellData];
    }
}

- (void)messageController:(TUIMessageController *)controller onSelectMessageAvatar:(TUIMessageCell *)cell
{
    if (cell.messageData.identifier == nil)
        return;
    if (self.delegate && [self.delegate respondsToSelector:@selector(chatController:onSelectMessageAvatar:)]) {
        [self.delegate chatController:self onSelectMessageAvatar:cell];
    }
}

- (void)messageController:(TUIMessageController *)controller onSelectMessageContent:(TUIMessageCell *)cell
{
    cell.disableDefaultSelectAction = NO;
    if (self.delegate && [self.delegate respondsToSelector:@selector(chatController:onSelectMessageContent:)]) {
        [self.delegate chatController:self onSelectMessageContent:cell];
    }
    if (cell.disableDefaultSelectAction) {
        return;
    }
}

- (void)messageController:(TUIMessageController *)controller onSelectMessageMenu:(NSInteger)menuType withData:(TUIMessageCellData *)data
{
    [self onSelectMessageMenu:menuType withData:data];
}

- (void)didHideMenuInMessageController:(TUIMessageController *)controller
{
    self.inputController.inputBar.inputTextView.overrideNextResponder = nil;
}

#pragma mark - UIImagePickerController & UIDocumentPickerViewController
- (void)selectPhotoForSend
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        picker.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        picker.delegate = self;
        [self presentViewController:picker animated:YES completion:nil];
    }
}

- (void)takePictureForSend
{
    TUICameraViewController *vc = [[TUICameraViewController alloc] init];
    vc.type = TUICameraMediaTypePhoto;
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)takeVideoForSend
{
    TUICameraViewController *vc = [[TUICameraViewController alloc] init];
    vc.type = TUICameraMediaTypeVideo;
    vc.videoMinimumDuration = 1.5;
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)selectFileForSend
{
    UIDocumentPickerViewController *picker = [[UIDocumentPickerViewController alloc] initWithDocumentTypes:@[(NSString *)kUTTypeData] inMode:UIDocumentPickerModeOpen];
    picker.delegate = self;
    [self presentViewController:picker animated:YES completion:nil];

}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    // 快速点的时候会回调多次
    @weakify(self)
    picker.delegate = nil;
    [picker dismissViewControllerAnimated:YES completion:^{
        @strongify(self)
        NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
        if([mediaType isEqualToString:(NSString *)kUTTypeImage]){
            UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
            UIImageOrientation imageOrientation = image.imageOrientation;
            if(imageOrientation != UIImageOrientationUp)
            {
                CGFloat aspectRatio = MIN ( 1920 / image.size.width, 1920 / image.size.height );
                CGFloat aspectWidth = image.size.width * aspectRatio;
                CGFloat aspectHeight = image.size.height * aspectRatio;

                UIGraphicsBeginImageContext(CGSizeMake(aspectWidth, aspectHeight));
                [image drawInRect:CGRectMake(0, 0, aspectWidth, aspectHeight)];
                image = UIGraphicsGetImageFromCurrentImageContext();
                UIGraphicsEndImageContext();
            }

            NSData *data = UIImageJPEGRepresentation(image, 0.75);
            NSString *path = [TUIKit_Image_Path stringByAppendingString:[TUITool genImageName:nil]];
            [[NSFileManager defaultManager] createFileAtPath:path contents:data attributes:nil];
            
            V2TIMMessage *message = [[V2TIMManager sharedInstance] createImageMessage:path];
            [self sendMessage:message];
            if (self.delegate && [self.delegate respondsToSelector:@selector(chatController:didSendMessage:)]) {
                [self.delegate chatController:self didSendMessage:message];
            }
        }
        else if([mediaType isEqualToString:(NSString *)kUTTypeMovie]){
            NSURL *url = [info objectForKey:UIImagePickerControllerMediaURL];
            if (url) {
                [self transcodeIfNeed:url];
                return;
            }
            
            // 在某些情况下，UIImagePickerControllerMediaURL 可能为空，使用 UIImagePickerControllerPHAsset
            PHAsset *asset = nil;
            if (@available(iOS 11.0, *)) {
                asset = [info objectForKey:UIImagePickerControllerPHAsset];
            }
            if (asset) {
                [self originURLWithAsset:asset completion:^(BOOL success, NSURL *URL) {
                    if (success) {
                        [self transcodeIfNeed:URL];
                        return;
                    }
                }];
                return;
            }
            
            // 在 ios 12 的情况下，UIImagePickerControllerMediaURL 及 UIImagePickerControllerPHAsset 可能为空，需要使用其他方式获取视频文件原始路径
            url = [info objectForKey:UIImagePickerControllerReferenceURL];
            if (url) {
                [self originURLWithRefrenceURL:url completion:^(BOOL success, NSURL *URL) {
                    if (success) {
                        [self transcodeIfNeed:URL];
                    }
                }];
                return;
            }
            
            // 其他，不支持
            [self.view makeToast:@"not support this video"];
        }
    }];
}

// 根据 UIImagePickerControllerReferenceURL 获取原始文件路径
- (void)originURLWithRefrenceURL:(NSURL *)URL completion:(void(^)(BOOL success, NSURL *URL))completion
{
    if (completion == nil) {
        return;
    }
    NSDictionary *queryInfo = [self dictionaryWithURLQuery:URL.query];
    NSString *fileName = @"temp.mp4";
    if ([queryInfo.allKeys containsObject:@"id"] && [queryInfo.allKeys containsObject:@"ext"]) {
        fileName = [NSString stringWithFormat:@"%@.%@", queryInfo[@"id"], [queryInfo[@"ext"] lowercaseString]];
    }
    NSString* tempPath = NSTemporaryDirectory();
    NSString *filePath = [tempPath stringByAppendingPathComponent:fileName];
    if ([NSFileManager.defaultManager isDeletableFileAtPath:filePath]) {
        [NSFileManager.defaultManager removeItemAtPath:filePath error:nil];
    }
    NSURL *newUrl = [NSURL fileURLWithPath:filePath];
    ALAssetsLibrary *assetLibrary= [[ALAssetsLibrary alloc] init];
    [assetLibrary assetForURL:URL resultBlock:^(ALAsset *asset) {
        if (asset == nil) {
            completion(NO, nil);
            return;
        }
        ALAssetRepresentation *rep = [asset defaultRepresentation];
        Byte *buffer = (Byte*)malloc(rep.size);
        NSUInteger buffered = [rep getBytes:buffer fromOffset:0.0 length:rep.size error:nil];
        NSData *data = [NSData dataWithBytesNoCopy:buffer length:buffered freeWhenDone:YES];//this is NSData may be what you want
        BOOL flag = [NSFileManager.defaultManager createFileAtPath:filePath contents:data attributes:nil];
        completion(flag, newUrl);
    } failureBlock:^(NSError *err) {
        completion(NO, nil);
    }];
}

- (void)originURLWithAsset:(PHAsset *)asset completion:(void(^)(BOOL success, NSURL *URL))completion
{
    if (completion == nil) {
        return;
    }
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        if (status != PHAuthorizationStatusAuthorized) {
            completion(NO, nil);
            return;
        }
        
        NSArray<PHAssetResource *> *resources = [PHAssetResource assetResourcesForAsset:asset];
        if (resources.count == 0) {
            completion(NO, nil);
            return;
        }
        
        PHAssetResourceRequestOptions *options = [[PHAssetResourceRequestOptions alloc] init];
        options.networkAccessAllowed = NO;
        __block BOOL invoked = NO;
        [PHAssetResourceManager.defaultManager requestDataForAssetResource:resources.firstObject options:options dataReceivedHandler:^(NSData * _Nonnull data) {
            // 此处会有重复回调的问题
            if (invoked) {
                return;
            }
            invoked = YES;
            if (data == nil) {
                completion(NO, nil);
                return;
            }
            NSString *fileName = @"temp.mp4";
            NSString* tempPath = NSTemporaryDirectory();
            NSString *filePath = [tempPath stringByAppendingPathComponent:fileName];
            if ([NSFileManager.defaultManager isDeletableFileAtPath:filePath]) {
                [NSFileManager.defaultManager removeItemAtPath:filePath error:nil];
            }
            NSURL *newUrl = [NSURL fileURLWithPath:filePath];
            BOOL flag = [NSFileManager.defaultManager createFileAtPath:filePath contents:data attributes:nil];
            completion(flag, newUrl);
        } completionHandler:^(NSError * _Nullable error) {
            completion(NO, nil);
        }];
    }];
}

// 获取 NSURL 查询字符串信息
- (NSDictionary *)dictionaryWithURLQuery:(NSString *)query
{
    NSArray *components = [query componentsSeparatedByString:@"&"];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    for (NSString *item in components) {
        NSArray *subs = [item componentsSeparatedByString:@"="];
        if (subs.count == 2) {
            [dict setObject:subs.lastObject forKey:subs.firstObject];
        }
    }
    return [NSDictionary dictionaryWithDictionary:dict];;
}

// 转码
- (void)transcodeIfNeed:(NSURL *)url
{
    if ([url.pathExtension.lowercaseString isEqualToString:@"mp4"]) {
        // mp4 直接发送
        [self sendVideoWithUrl:url];
    } else {
        // 非 mp4 文件 => mp4 文件
        NSString* tempPath = NSTemporaryDirectory();
        NSURL *urlName = [url URLByDeletingPathExtension];
        NSURL *newUrl = [NSURL URLWithString:[NSString stringWithFormat:@"file://%@%@.mp4", tempPath,[urlName.lastPathComponent stringByRemovingPercentEncoding]]];
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        if ([fileManager fileExistsAtPath:newUrl.path]){
            NSError *error;
            BOOL success = [fileManager removeItemAtPath:newUrl.path error:&error];
            if (!success || error) {
                NSAssert1(NO, @"removeItemFail: %@", error.localizedDescription);
                return;
            }
        }
        // mov to mp4
        AVURLAsset *avAsset = [AVURLAsset URLAssetWithURL:url options:nil];
        AVAssetExportSession *exportSession = [[AVAssetExportSession alloc]initWithAsset:avAsset presetName:AVAssetExportPresetHighestQuality];
        exportSession.outputURL = newUrl;
        exportSession.outputFileType = AVFileTypeMPEG4;
        exportSession.shouldOptimizeForNetworkUse = YES;
        
        [exportSession exportAsynchronouslyWithCompletionHandler:^{
            switch ([exportSession status])
            {
                case AVAssetExportSessionStatusFailed:
                    NSLog(@"Export session failed");
                    break;
                case AVAssetExportSessionStatusCancelled:
                    NSLog(@"Export canceled");
                    break;
                case AVAssetExportSessionStatusCompleted:
                {
                    //Video conversion finished
                    NSLog(@"Successful!");
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self sendVideoWithUrl:newUrl];
                    });
                }
                    break;
                default:
                    break;
            }
        }];
    }
}

- (void)sendVideoWithUrl:(NSURL*)url {
    [TUITool dispatchMainAsync:^{
        V2TIMMessage *message = [TUIMessageDataProvider getVideoMessageWithURL:url];
        [self sendMessage:message];
        if (self.delegate && [self.delegate respondsToSelector:@selector(chatController:didSendMessage:)]) {
            [self.delegate chatController:self didSendMessage:message];
        }
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)documentPicker:(UIDocumentPickerViewController *)controller didPickDocumentAtURL:(NSURL *)url
{
    [url startAccessingSecurityScopedResource];
    NSFileCoordinator *coordinator = [[NSFileCoordinator alloc] init];
    NSError *error;
    @weakify(self)
    [coordinator coordinateReadingItemAtURL:url options:0 error:&error byAccessor:^(NSURL *newURL) {
        @strongify(self)
        NSData *fileData = [NSData dataWithContentsOfURL:url];
        NSString *fileName = [url lastPathComponent];
        NSString *filePath = [TUIKit_File_Path stringByAppendingString:fileName];
        if ([NSFileManager.defaultManager fileExistsAtPath:filePath]) {
            // 存在同名文件，对文件名进行递增
            int i = 0;
            NSArray *arrayM = [NSFileManager.defaultManager subpathsAtPath:TUIKit_File_Path];
            for (NSString *sub in arrayM) {
                if ([sub.pathExtension isEqualToString:fileName.pathExtension] &&
                    [sub.stringByDeletingPathExtension containsString:fileName.stringByDeletingPathExtension]) {
                    i++;
                }
            }
            if (i) {
                fileName = [fileName stringByReplacingOccurrencesOfString:fileName.stringByDeletingPathExtension withString:[NSString stringWithFormat:@"%@(%d)", fileName.stringByDeletingPathExtension, i]];
                filePath = [TUIKit_File_Path stringByAppendingString:fileName];
            }
        }
        [[NSFileManager defaultManager] createFileAtPath:filePath contents:fileData attributes:nil];
        if([[NSFileManager defaultManager] fileExistsAtPath:filePath]){
//            unsigned long long fileSize = [[[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:nil] fileSize];
            
            V2TIMMessage *message = [[V2TIMManager sharedInstance] createFileMessage:filePath fileName:fileName];
            [self sendMessage:message];
            if (self.delegate && [self.delegate respondsToSelector:@selector(chatController:didSendMessage:)]) {
                [self.delegate chatController:self didSendMessage:message];
            }
        }
    }];
    [url stopAccessingSecurityScopedResource];
    [controller dismissViewControllerAnimated:YES completion:nil];
}

- (void)documentPickerWasCancelled:(UIDocumentPickerViewController *)controller
{
    [controller dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - TUICameraViewControllerDelegate
- (void)cameraViewController:(TUICameraViewController *)controller didFinishPickingMediaWithVideoURL:(NSURL *)url {
    [self transcodeIfNeed:url];
}

- (void)cameraViewController:(TUICameraViewController *)controller didFinishPickingMediaWithImage:(UIImage *)image {
    NSData *data = UIImageJPEGRepresentation(image, 0.75);
    NSString *path = [TUIKit_Image_Path stringByAppendingString:[TUITool genImageName:nil]];
    [[NSFileManager defaultManager] createFileAtPath:path contents:data attributes:nil];
    
    V2TIMMessage *message = [[V2TIMManager sharedInstance] createImageMessage:path];
    [self sendMessage:message];
    if (self.delegate && [self.delegate respondsToSelector:@selector(chatController:didSendMessage:)]) {
        [self.delegate chatController:self didSendMessage:message];
    }
}

- (void)cameraViewControllerDidCancel:(TUICameraViewController *)controller {
}

#pragma mark - UIImagePickerControllerDelegate

#pragma mark - TUIChatDataProviderForwardDelegate
- (NSString *)dataProvider:(TUIChatDataProvider *)dataProvider mergeForwardTitleWithMyName:(NSString *)name {
    return [self forwardTitleWithMyName:name];
}

- (NSString *)dataProvider:(TUIChatDataProvider *)dataProvider mergeForwardMsgAbstactForMessage:(V2TIMMessage *)message {
    
    NSString *display = @"";
    if (self.delegate && [self.delegate respondsToSelector:@selector(chatController:onGetMessageAbstact:)]) {
        return [self.delegate chatController:self onGetMessageAbstact:message];
    }
    return display;
}

#pragma mark - 消息菜单操作: 多选 & 转发
- (void)onSelectMessageMenu:(NSInteger)menuType withData:(TUIMessageCellData *)data {
    if (menuType == 0) {
        // 多选: 打开多选面板
        [self openMultiChooseBoard:YES];
    } else if (menuType == 1) {
        // 转发
        if (data == nil) {
            return;
        }
        
        NSMutableArray *uiMsgs = [NSMutableArray arrayWithArray:@[data]];
        [self prepareForwardMessages:uiMsgs];
        
    }
}

// 打开、关闭 多选面板
- (void)openMultiChooseBoard:(BOOL)open
{
    [self.view endEditing:YES];
    
    if (_multiChooseView) {
        [_multiChooseView removeFromSuperview];
    }
    
    if (open) {
        _multiChooseView = [[TUIMessageMultiChooseView alloc] init];
        _multiChooseView.frame = self.view.bounds;
        _multiChooseView.delegate = self;
        _multiChooseView.titleLabel.text = self.conversationData.title;
        if (@available(iOS 12.0, *)) {
            if (@available(iOS 13.0, *)) {
                // > ios 12
                [UIApplication.sharedApplication.keyWindow addSubview:_multiChooseView];
            } else {
                // ios = 12
                UIView *view = self.navigationController.view;
                if (view == nil) {
                    view = self.view;
                }
                [view addSubview:_multiChooseView];
            }
        } else {
            // < ios 12
            [UIApplication.sharedApplication.keyWindow addSubview:_multiChooseView];
        }
    } else {
        [self.messageController enableMultiSelectedMode:NO];
    }
}

- (void)messageMultiChooseViewOnCancelClicked:(TUIMessageMultiChooseView *)multiChooseView
{
    [self openMultiChooseBoard:NO];
    [self.messageController enableMultiSelectedMode:NO];
}

- (void)messageMultiChooseViewOnRelayClicked:(TUIMessageMultiChooseView *)multiChooseView
{
    NSArray *uiMsgs = [self.messageController multiSelectedResult:TUIMultiResultOptionAll];
    [self prepareForwardMessages:uiMsgs];
}

- (void)messageMultiChooseViewOnDeleteClicked:(TUIMessageMultiChooseView *)multiChooseView
{
    NSArray *uiMsgs = [self.messageController multiSelectedResult:TUIMultiResultOptionAll];
    if (uiMsgs.count == 0) {
        [TUITool makeToast:TUIKitLocalizableString(TUIKitRelayNoMessageTips)];
        return;
    }
    
    // 删除
    [self.messageController deleteMessages:uiMsgs];
}

// 准备转发消息
- (void)prepareForwardMessages:(NSArray<TUIMessageCellData *> *)uiMsgs
{
    if (uiMsgs.count == 0) {
        [TUITool makeToast:TUIKitLocalizableString(TUIKitRelayNoMessageTips)];
        return;
    }
    
    // 不支持的消息类型
    BOOL hasUnsupportMsg = NO;
    for (TUIMessageCellData *data in uiMsgs) {
        if (data.status != Msg_Status_Succ) {
            hasUnsupportMsg = YES;
            break;
        }
    }
    
    if (hasUnsupportMsg) {
        UIAlertController *vc = [UIAlertController alertControllerWithTitle:TUIKitLocalizableString(TUIKitRelayUnsupportForward) message:nil preferredStyle:UIAlertControllerStyleAlert];
        [vc addAction:[UIAlertAction actionWithTitle:TUIKitLocalizableString(Confirm) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        [self presentViewController:vc animated:YES completion:nil];
        return;
    }
    
    // 转发视图发起
    __weak typeof(self) weakSelf = self;
    void(^chooseTarget)(BOOL) = ^(BOOL mergeForward) {
        UIViewController * vc = (UIViewController *)[TUICore callService:TUICore_TUIConversationService method:TUICore_TUIConversationService_GetConversationSelectControllerMethod param:nil];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:(UIViewController *)vc];
        nav.modalPresentationStyle = UIModalPresentationFullScreen;
        weakSelf.forwardConversationSelectVC = (UIViewController *)vc;
        weakSelf.forwardSelectUIMsgs = uiMsgs;
        weakSelf.isMergeForward = mergeForward;
        [weakSelf presentViewController:nav animated:YES completion:nil];
    };
    
    UIAlertController *tipsVc = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    // 逐条转发
    [tipsVc addAction:[UIAlertAction actionWithTitle:TUIKitLocalizableString(TUIKitRelayOneByOneForward) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (uiMsgs.count <= 30) {
            chooseTarget(NO);
            return;
        }
        // 转发消息过多，暂不支持逐条转发
        UIAlertController *vc = [UIAlertController alertControllerWithTitle:TUIKitLocalizableString(TUIKitRelayOneByOnyOverLimit) message:nil preferredStyle:UIAlertControllerStyleAlert];
        [vc addAction:[UIAlertAction actionWithTitle:TUIKitLocalizableString(Cancel) style:UIAlertActionStyleDefault handler:nil]];
        [vc addAction:[UIAlertAction actionWithTitle:TUIKitLocalizableString(TUIKitRelayCombineForwad) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            chooseTarget(YES);
        }]];
        [weakSelf presentViewController:vc animated:YES completion:nil];
    }]];
    // 合并转发
    [tipsVc addAction:[UIAlertAction actionWithTitle:TUIKitLocalizableString(TUIKitRelayCombineForwad) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        chooseTarget(YES);
    }]];
    [tipsVc addAction:[UIAlertAction actionWithTitle:TUIKitLocalizableString(Cancel) style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:tipsVc animated:YES completion:nil];
}

// 转发消息到目标会话
- (void)forwardMessages:(NSArray<TUIMessageCellData *> *)uiMsgs
              toTargets:(NSArray<TUIChatConversationModel *> *)targets
                  merge:(BOOL)merge
{
    if (uiMsgs.count == 0 || targets.count == 0) {
        return ;
    }
    
    @weakify(self);
    [self.dataProvider getForwardMessageWithCellDatas:uiMsgs
                                            toTargets:targets
                                                Merge:merge
                                          ResultBlock:^(TUIChatConversationModel * _Nonnull targetConversation, NSArray<V2TIMMessage *> * _Nonnull msgs) {
        @strongify(self);
        
        TUIChatConversationModel *convCellData = targetConversation;
        NSTimeInterval timeInterval = convCellData.groupID.length?0.09:0.05;
        
        // 发送到当前聊天窗口
        if ([convCellData.conversationID isEqualToString:self.conversationData.conversationID]) {
            for (V2TIMMessage *imMsg in msgs) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    // 下面的函数涉及到 UI 的刷新，要放在主线程操作
                    [self.messageController sendMessage:imMsg];
                });
                // 此处做延时是因为需要保证批量逐条转发时，能够保证接收端的顺序一致
                [NSThread sleepForTimeInterval:timeInterval];
            }
            return;
        }
        
        // 发送到其他聊天
        for (V2TIMMessage *message in msgs) {
            
            [TUIMessageDataProvider sendMessage:message
                                 toConversation:convCellData
                                 isSendPushInfo:YES
                               isOnlineUserOnly:NO
                                       priority:V2TIM_PRIORITY_NORMAL
                                       Progress:nil
                                      SuccBlock:^{
                // 发送到其他聊天的消息需要广播消息发送状态，方便进入对应聊天后刷新消息状态
                [NSNotificationCenter.defaultCenter postNotificationName:TUIKitNotification_onMessageStatusChanged object:message.msgID];
            } FailBlock:^(int code, NSString *desc) {
                [NSNotificationCenter.defaultCenter postNotificationName:TUIKitNotification_onMessageStatusChanged object:message.msgID];
            }];
            
            // 此处做延时是因为需要保证批量逐条转发时，能够保证接收端的顺序一致
            [NSThread sleepForTimeInterval:timeInterval];
        }
    } fail:^(int code, NSString *desc) {
        NSLog(@"%@", desc);
        NSAssert(NO, desc);
    }];
}

- (NSString *)forwardTitleWithMyName:(NSString *)nameStr
{
    return @"";
}

#pragma mark - 消息回复
- (void)messageController:(TUIMessageController *)controller onRelyMessage:(nonnull TUIMessageCellData *)data
{
    NSString *desc = @"";
    if (data.innerMessage.elemType == V2TIM_ELEM_TYPE_FILE) {
        desc = data.innerMessage.fileElem.filename;
    } else if (data.innerMessage.elemType == V2TIM_ELEM_TYPE_MERGER) {
        desc = data.innerMessage.mergerElem.title;
    } else if (data.innerMessage.elemType == V2TIM_ELEM_TYPE_CUSTOM) {
        desc = [TUIMessageDataProvider getDisplayString:data.innerMessage];
    } else if (data.innerMessage.elemType == V2TIM_ELEM_TYPE_TEXT) {
        desc = data.innerMessage.textElem.text;
    }
    
    TUIReplyPreviewData *replyData = [[TUIReplyPreviewData alloc] init];
    replyData.msgID = data.msgID;
    replyData.msgAbstract = desc;
    replyData.sender = data.name;
    replyData.type = (NSInteger)data.innerMessage.elemType;
    replyData.originMessage = data.innerMessage;
    [self.inputController showReplyPreview:replyData];
}

#pragma mark - Privete Methods
+ (void)createCachePath
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if(![fileManager fileExistsAtPath:TUIKit_Image_Path]){
        [fileManager createDirectoryAtPath:TUIKit_Image_Path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    if(![fileManager fileExistsAtPath:TUIKit_Video_Path]){
        [fileManager createDirectoryAtPath:TUIKit_Video_Path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    if(![fileManager fileExistsAtPath:TUIKit_Voice_Path]){
        [fileManager createDirectoryAtPath:TUIKit_Voice_Path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    if(![fileManager fileExistsAtPath:TUIKit_File_Path]){
        [fileManager createDirectoryAtPath:TUIKit_File_Path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    if(![fileManager fileExistsAtPath:TUIKit_DB_Path]){
        [fileManager createDirectoryAtPath:TUIKit_DB_Path withIntermediateDirectories:YES attributes:nil error:nil];
    }
}

@end
