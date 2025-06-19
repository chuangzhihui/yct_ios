//
//  YCTVideoViewModel.m
//  YCT
//
//  Created by hua-cloud on 2021/12/15.
//

#import "YCTVideoViewModel.h"
#import "NSString+Common.h"
#import "YCTApiZanVideo.h"
#import "YCTApiFileDownloader.h"
#import "YCTApiCollectionVideo.h"
#import "YCTApiDelVideo.h"
#import "YCTApiBlacklist.h"
#import "YCTApiWatchVideo.h"
#import <Photos/Photos.h>

@interface YCTVideoCellViewModel ()
@property (nonatomic, copy, readwrite) NSString * coverImageUrl;
@property (nonatomic, assign, readwrite) CGFloat playProgress;
@property (nonatomic, assign, readwrite) CGFloat progressMax;

@property (nonatomic, assign, readwrite) BOOL islike;
@property (nonatomic, assign, readwrite) BOOL isSelf;
@property (nonatomic, assign, readwrite) BOOL isTop;
@property (nonatomic, assign, readwrite) BOOL beFocused;
@property (nonatomic, assign, readwrite) BOOL isPlaying;
@property (nonatomic, assign, readwrite) BOOL isWatched;

@property (nonatomic, copy, readwrite) NSString * avatarUrl;
@property (nonatomic, copy, readwrite) NSString * likeCount;
@property (nonatomic, copy, readwrite) NSString * albumImageUrl;
@property (nonatomic, copy, readwrite) NSString * userName;
@property (nonatomic, copy, readwrite) NSString * content;
@property (nonatomic, copy, readwrite) NSString * musicName;
@property (nonatomic, copy, readwrite) NSString * adress;
@property (nonatomic, copy, readwrite) NSString * videoUrl;
@property (nonatomic, assign, readwrite) BOOL isHengping;

@property (nonatomic, copy) dispatch_block_t responsePauseOrPlay;
@property (nonatomic, copy) void(^responseSeek)(CGFloat seekValue);
@end

@implementation YCTVideoCellViewModel
- (instancetype)initWithVideModel:(YCTVideoModel *)model{
    if (self = [super init]) {
        self.videoModel = model;
        [self bindModel];
    }
    return self;
}

- (void)bindModel{
    self.coverImageUrl = self.videoModel.thumbUrl;
    self.avatarUrl = self.videoModel.avatar;
    self.isTop = self.videoModel.isTop == 1;
    self.isSelf = self.videoModel.isSelf == 1;
    self.isHengping = self.videoModel.hengping == 1;
    self.albumImageUrl = self.videoModel.musicImg;
    self.userName = [NSString stringWithFormat:@"%@",self.videoModel.nickName];
    self.content = self.videoModel.title;
    self.musicName = self.videoModel.musicDesc;
    self.adress = self.videoModel.address;
    self.videoUrl = self.videoModel.videoUrl;
    
//    self.videoModel.videoUrl;
    
    self.beFocused = self.videoModel.isFans == 1;
    
    @weakify(self);
    [RACObserve(self.videoModel, commentNum) subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        self.commentCount = self.videoModel.commentNum > 0 ? [NSString handledCountNumberIfMoreThanTenThousand:self.videoModel.commentNum] : YCTLocalizedString(@"comment.comment");
    }];
    
    [RACObserve(self.videoModel, isZan) subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        self.islike = [x integerValue] == 1;
    }];
    
    [RACObserve(self.videoModel, zanNum) subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        self.likeCount = self.videoModel.zanNum > 0 ? [NSString handledCountNumberIfMoreThanTenThousand:self.videoModel.zanNum] : YCTLocalizedString(@"share.like");
    }];
    
    RAC(self, beFocused) = [RACObserve(self.videoModel, isFans) map:^id _Nullable(id  _Nullable value) {
        return @([value integerValue] == 1);
    }];
}

- (void)handlePauseOrPlay{
    !_responsePauseOrPlay ? : _responsePauseOrPlay();
}

- (void)hanldeToSeekWithValue:(CGFloat)value{
    !_responseSeek ? : _responseSeek(value);
}

- (void)requeustForZanVideo{
    YCTApiZanVideo * api = [[YCTApiZanVideo alloc] initWithVideoId:self.videoModel.id];
    @weakify(self);
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        @strongify(self);
        self.videoModel.isZan = self.videoModel.isZan == 1 ? 0 : 1;
        self.videoModel.zanNum = MAX(0, (self.videoModel.zanNum  + (self.islike ? 1 : -1)));
    } failure:nil];
}

- (void)requeustForFollowUser{
    
    YCTApiFollowUser * api = [[YCTApiFollowUser alloc] initWithType:YCTApiFollowUserTypeFollow userId:self.videoModel.userId];
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        self.videoModel.isFans = 1;
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
            
    }];
}

- (void)requestFordeleteWithCompletion:(dispatch_block_t)completion{
    YCTApiDelVideo * api = [[YCTApiDelVideo alloc] initWithVideoId:self.videoModel.id];
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        !completion ? : completion();
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
            
    }];
}

- (void)requestForCollection{
    YCTApiCollectionVideo * api = [[YCTApiCollectionVideo alloc] initWithVideoId:self.videoModel.id];
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        self.videoModel.isCollection = !self.videoModel.isCollection;
        [[YCTHud sharedInstance] showSuccessHud:YCTLocalizedString(self.videoModel.isCollection ? @"video.collection" : @"video.cancelCollection")];
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
            
    }];
}

- (void)requestForBlackList{
    [[YCTHud sharedInstance] showLoadingHud];
    YCTApiHandleBlacklist * api = [[YCTApiHandleBlacklist alloc] initWithType:YCTHandleBlacklistTypeAdd userId:self.videoModel.userId];
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        [[YCTHud sharedInstance] showToastHud:YCTLocalizedString(@"share.blacklistSuccess")];
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        [[YCTHud sharedInstance] showFailedHud:[api getError]];
    }];
}
- (void)downloadAndSave{
    [YCTApiFileDownloader startDownloadWithFileUrl:[NSURL URLWithString:self.videoModel.videoUrl] downloadProgressHandler:^(CGFloat downloadProgress) {
        [[YCTHud sharedInstance] showProgress:downloadProgress];
    }  downloadCompletionHandler:^(NSError * _Nullable error, NSURL * _Nullable resultUrl) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!error) {
                    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
                        if (status == PHAuthorizationStatusAuthorized) {    //确认有权限
                            [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
                                PHAssetCreationRequest* request = [PHAssetCreationRequest creationRequestForAsset];
                                PHAssetResourceCreationOptions* option = PHAssetResourceCreationOptions.new;
                                option.shouldMoveFile = YES;
                                [request addResourceWithType:PHAssetResourceTypeVideo fileURL:resultUrl options:option];
                            } completionHandler:^(BOOL success, NSError *_Nullable error) {
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    if (error) {
                                        [[YCTHud sharedInstance] showFailedHud:YCTLocalizedTableString(@"video.saveFail", @"Home")];
                                    }else{
                                        [[YCTHud sharedInstance] showSuccessHud:YCTLocalizedTableString(@"video.saveSuccess", @"Home")];
                                    }
                                });
                            }];
                        }
                    }];
               
            }else{
                [[YCTHud sharedInstance] showFailedHud:YCTLocalizedTableString(@"video.saveFail", @"Home")];
            }
        });
    }];
}

- (void)requestForWatchReport{
    if (self.isWatched) {
        return;
    }
    YCTApiWatchVideo * api = [[YCTApiWatchVideo alloc] initWithVideoId:self.videoModel.id];
    [api startWithCompletionBlockWithSuccess:nil failure:nil];
    self.isWatched = YES;
}
@end



@interface YCTVodPlayerModel ()<TXVodPlayListener>

@property (nonatomic, weak) YCTVideoCellViewModel * cellViewModel;
@property (nonatomic, assign) BOOL handlePause;
//@property (nonatomic, weak)

@end
@implementation  YCTVodPlayerModel

- (instancetype)initWithPlayer:(TXVodPlayer *)player{
    if (self = [super init]) {
        self.player = player ? player : [[TXVodPlayer alloc] init];
        self.player.isAutoPlay = NO;
        self.player.vodDelegate = self;
        self.isPlayPrepare = NO;
        self.isbegan = NO;
        [self bindModel];
    }
    return self;
}

- (void)bindModel{
    [RACObserve(self, cellViewModel) subscribeNext:^(id  _Nullable x) {
        if (x) {
            @weakify(self);
            self.cellViewModel.isPlaying = YES;
            [self.cellViewModel setResponsePauseOrPlay:^{
                @strongify(self);
                [self handledPauseOrPlay];
            }];
            
            [self.cellViewModel setResponseSeek:^(CGFloat seekValue) {
                @strongify(self);
                [self seekWithValue:seekValue];
            }];
        }
    }];
}

- (void)seekWithValue:(CGFloat)value{
    if(!self.player.isPlaying){
        [self.player resume];
    }
    [self.player seek:value];
}

///暂停并把进度设置成0
- (void)pauseAndSeekPlayer{
    if (self.cellViewModel) {
        [self.player seek:0];
        [self.player pause];
        self.cellViewModel.playProgress = 0;
    }
}

///用户手动点击操作
- (void)handledPauseOrPlay{
    if (self.player.isPlaying) {
        self.handlePause = YES;
        self.cellViewModel.isPlaying = NO;
        [self.player pause];
    }else{
        self.cellViewModel.isPlaying = YES;
        self.handlePause = NO;
        [self.player resume];
    }
}

///恢复播放
- (void)resumePlayer{
    if (!self.isbegan) {
        [self startPlay];
    }
    if (self.isPlayPrepare) {
        [self.player resume];
    }
}

- (void)stopAndRemovePlay{
    [self stopPlay];
    [self.player removeVideoWidget];
}

- (void)stopPlay{
    self.isbegan = NO;
    self.isPlayPrepare = NO;
    [self.player stopPlay];
}

- (void)startPlay{
    if (!self.isbegan) {
        TXVodPlayer *voidPlayer = self.player;
        if(voidPlayer != nil){
            TXVodPlayConfig *cfg = voidPlayer.config;
            if (cfg == nil) {
                cfg = [TXVodPlayConfig new];
            }
            cfg.cacheFolderPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingString:@"/yctCache"];
            cfg.maxCacheItems = 5;
            voidPlayer.config = cfg;
            voidPlayer.isAutoPlay = NO;
            voidPlayer.enableHWAcceleration = YES;
            [voidPlayer setRenderRotation:HOME_ORIENTATION_DOWN];
            [voidPlayer setRenderMode:RENDER_MODE_FILL_EDGE];
            voidPlayer.loop = YES;
            [voidPlayer startPlay:self.cellViewModel.videoUrl];
            [self.cellViewModel.loadingSubject sendNext:@(YES)];
            self.isbegan = YES;
        }
    }
}

#pragma mark TXVodPlayListener
-(void)onPlayEvent:(TXVodPlayer *)player event:(int)EvtID withParam:(NSDictionary*)param
{
    NSDictionary* dict = param;
    dispatch_async(dispatch_get_main_queue(), ^{
        self.cellViewModel.isPlaying = [player isPlaying];
        //player 收到准备好事件，记录下状态，下次可以直接resume
        if (EvtID == PLAY_EVT_VOD_PLAY_PREPARED) {
            self.isPlayPrepare = YES;
            if (self.isCurrent){
                [player resume];
            }
            
        }
        //只处理当前播放器的Event事件
        if (!self.isCurrent) return;
        if (EvtID == PLAY_EVT_VOD_PLAY_PREPARED) {
            //收到PREPARED事件的时候 resume播放器
            [self.cellViewModel.loadingSubject sendNext:@(NO)];
            [player resume];
            
        } else if (EvtID == PLAY_EVT_PLAY_BEGIN) {
            
        } else if (EvtID == PLAY_EVT_RCV_FIRST_I_FRAME) {
            [self.cellViewModel.loadingSubject sendNext:@(NO)];
        } else if (EvtID == PLAY_EVT_PLAY_PROGRESS) {
            if (self.cellViewModel.isSeeking) return;
//             避免滑动进度条松开的瞬间可能出现滑动条瞬间跳到上一个位置
            float progress = [dict[EVT_PLAY_PROGRESS] floatValue];
            float duration = [dict[EVT_PLAY_DURATION] floatValue];
            if (progress > 5) [self.cellViewModel requestForWatchReport];
            self.cellViewModel.progressMax = duration;
            self.cellViewModel.playProgress = progress;
        } else if (EvtID == PLAY_ERR_NET_DISCONNECT || EvtID == PLAY_EVT_PLAY_END) {
            [player pause];
        } else if (EvtID == PLAY_EVT_PLAY_LOADING){
            [self.cellViewModel.loadingSubject sendNext:@(YES)];
        } else if (EvtID == EVT_VOD_PLAY_LOADING_END){
            [self.cellViewModel.loadingSubject sendNext:@(NO)];
        }
    });
}

- (void)onNetStatus:(TXVodPlayer *)player withParam:(NSDictionary *)param {
    
}



@end


@interface YCTVideoViewModel ()

@property (nonatomic, copy, readwrite) NSArray<YCTVideoCellViewModel *> * cellModels;

@property (nonatomic, weak) YCTVideoCellViewModel * currentCellViewModel;

@property (nonatomic, copy) NSArray<YCTVodPlayerModel *> * playerList;

@property (nonatomic, readwrite, strong) RACSubject * playSubject;

@property (nonatomic, assign) bool disappear;
@end

@implementation YCTVideoViewModel

- (instancetype)init
{
    self = [super init];
    if (self) {
//        self.appIsInterrupt = NO;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onAppDidEnterBackGround:) name:UIApplicationDidEnterBackgroundNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onAppWillEnterForeground:) name:UIApplicationWillEnterForegroundNotification object:nil];
        self.currentIndex = -1;
        [self bindModel];
    }
    return self;
}

- (void)updateModels:(NSArray<YCTVideoModel *> *)models refresh:(BOOL)refresh{
    [self releasePlayer];
    if (refresh) {
//        self.cellModels = @[];
        self.currentIndex = -1;
    };
    [self updateModels:models];
}

- (void)updateModels:(NSArray<YCTVideoModel *> *)models{
    NSMutableArray * temp = @[].mutableCopy;
    [models enumerateObjectsUsingBlock:^(YCTVideoModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        YCTVideoCellViewModel * cellViewModel = [[YCTVideoCellViewModel alloc] initWithVideModel:obj];
        [temp addObject:cellViewModel];
    }];
    self.cellModels = temp.copy;
}

- (void)bindModel{
    @weakify(self);
    [[[RACObserve(self, currentIndex) distinctUntilChanged] skip:1]  subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        if(!self.cellModels || !self.cellModels.count || self.currentIndex < 0){return;}
        NSInteger lastIndex = self.currentCellViewModel ? [self.cellModels indexOfObject:self.currentCellViewModel] : 0;
        BOOL increase = self.currentIndex >= lastIndex;
        YCTVideoCellViewModel * currentCellViewModel = [self.cellModels objectAtIndex:[x integerValue]];
        ///获取上一个播放器暂停播放
        YCTVodPlayerModel * lastPlayerModel = [self currentPlayerModel];
        lastPlayerModel.handlePause = NO;
        lastPlayerModel.isCurrent = NO;
        [lastPlayerModel pauseAndSeekPlayer];
        ///移动播放器
        [self movePlayer:increase];
        ///获取当前新播放器开始播放
        YCTVodPlayerModel * playerModel = [self currentPlayerModel];
        playerModel.isCurrent = YES;
        playerModel.cellViewModel = currentCellViewModel;
        [playerModel resumePlayer];
        [self.playSubject sendNext:playerModel];
        ///预加载下一个播放器
        [self preloadVideo:increase];
        ///设置当前播放的cellviewModel
        self.currentCellViewModel = currentCellViewModel;
    }];
}

- (void)movePlayer:(BOOL)increase{
    NSMutableArray * playerTemp = self.playerList.mutableCopy;
    if (increase) {
        YCTVodPlayerModel * first = playerTemp.firstObject;
        [first stopAndRemovePlay];
        YCTVodPlayerModel * new = [[YCTVodPlayerModel alloc] initWithPlayer:first.player];
        [playerTemp removeObjectAtIndex:0];
        [playerTemp addObject:new];
    }else{
        YCTVodPlayerModel * last = playerTemp.lastObject;
        [last stopAndRemovePlay];
        YCTVodPlayerModel * new = [[YCTVodPlayerModel alloc] initWithPlayer:last.player];
        [playerTemp removeLastObject];
        [playerTemp insertObject:new atIndex:0];
    }
    self.playerList = playerTemp.copy;
}

- (void)preloadVideo:(BOOL)increase{
    if (increase && self.currentIndex + 1 < self.cellModels.count) {
        YCTVodPlayerModel * last = self.playerList.lastObject;
        YCTVideoCellViewModel * next = [self.cellModels objectAtIndex:self.currentIndex + 1];
        last.cellViewModel = next;
        [last startPlay];
    }
    
    if (!increase && self.currentIndex - 1 > 0) {
        YCTVodPlayerModel * first = self.playerList.firstObject;
        YCTVideoCellViewModel * next = [self.cellModels objectAtIndex:self.currentIndex - 1];
        first.cellViewModel = next;
        [first startPlay];
    }
}

- (YCTVodPlayerModel *)currentPlayerModel{
    return self.playerList[1];
}



#pragma mark - notifi
- (void)onAppDidEnterBackGround:(UIApplication*)app {
    if (!self.disappear) {
        [self onPause];
    }
    
}

- (void)onAppWillEnterForeground:(UIApplication*)app {
    if (!self.disappear) {
        [self onResume];
    }
}

- (void)onWilldisappear{
    self.disappear = YES;
    YCTVodPlayerModel * currentPlayerModel = [self currentPlayerModel];
    currentPlayerModel.isCurrent = NO;
    [self onPause];
    
}

- (void)onWillAppear{
    self.disappear = NO;
    YCTVodPlayerModel * currentPlayerModel = [self currentPlayerModel];
    currentPlayerModel.isCurrent = YES;
    [self onResume];
}

- (void)onPause{
    YCTVodPlayerModel * currentPlayerModel = [self currentPlayerModel];
//    if (currentPlayerModel.player.isPlaying) {
        [currentPlayerModel.player pause];
//    }
}

- (void)onResume{
    YCTVodPlayerModel * currentPlayerModel = [self currentPlayerModel];
    if (!currentPlayerModel.player.isPlaying && currentPlayerModel.isbegan && !currentPlayerModel.handlePause) {
        [currentPlayerModel.player resume];
    }
}

- (void)releasePlayer{
    [self.playerList enumerateObjectsUsingBlock:^(YCTVodPlayerModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj.player stopPlay];
        obj.player = nil;
    }];
    self.playerList = nil;
}
#pragma mark -getter
- (NSArray<YCTVodPlayerModel *> *)playerList{
    if (!_playerList) {
        NSMutableArray * array = @[].mutableCopy;
        for (int i = 0; i< 3; i++) {
            YCTVodPlayerModel * playerModel = [[YCTVodPlayerModel alloc] initWithPlayer:nil];
            [array addObject:playerModel];
        }
        _playerList = array.copy;
    }
    return _playerList;
}

- (RACSubject *)playSubject{
    if (!_playSubject) {
        _playSubject = [RACSubject subject];
    }
    return _playSubject;
}
@end


