//
//  YCTVideoViewModel.h
//  YCT
//
//  Created by hua-cloud on 2021/12/15.
//

#import <Foundation/Foundation.h>
#import <TXLiteAVSDK_UGC/TXLiteAVSDK.h>
#import "YCTVideoModel.h"
#import "YCTApiFollowUser.h"
NS_ASSUME_NONNULL_BEGIN


@interface YCTVideoCellViewModel : YCTBaseViewModel

@property (nonatomic, copy, readonly) NSString * coverImageUrl;
@property (nonatomic, assign, readonly) CGFloat playProgress;
@property (nonatomic, assign, readonly) CGFloat progressMax;

@property (nonatomic, copy, readonly) NSString * avatarUrl;
@property (nonatomic, copy, readonly) NSString * likeCount;
@property (nonatomic, copy) NSString * commentCount;
@property (nonatomic, copy, readonly) NSString * albumImageUrl;
@property (nonatomic, copy, readonly) NSString * userName;
@property (nonatomic, copy, readonly) NSString * content;
@property (nonatomic, copy, readonly) NSString * musicName;
@property (nonatomic, copy, readonly) NSString * adress;
@property (nonatomic, copy, readonly) NSString * videoUrl;

@property (nonatomic, assign, readonly) BOOL islike;
@property (nonatomic, assign, readonly) BOOL isSelf;
@property (nonatomic, assign, readonly) BOOL isTop;
@property (nonatomic, assign, readonly) BOOL beFocused;
@property (nonatomic, assign, readonly) BOOL isPlaying;
@property (nonatomic, assign, readonly) BOOL isHengping;
@property (nonatomic, assign) BOOL isSeeking;

@property (nonatomic, strong) YCTVideoModel * videoModel;


/// 处理暂停播放
- (void)handlePauseOrPlay;
///处理拖动时间
- (void)hanldeToSeekWithValue:(CGFloat)value;
///请求删除视频
- (void)requestFordeleteWithCompletion:(dispatch_block_t)completion;
///请求点赞
- (void)requeustForZanVideo;
///请求关注
- (void)requeustForFollowUser;
///请求收藏
- (void)requestForCollection;
///下载保存到相册
- (void)downloadAndSave;
///加入黑名单
- (void)requestForBlackList;
@end

@interface YCTVodPlayerModel : NSObject

///是否收到准备播放通知
@property (nonatomic, assign) bool isPlayPrepare;
///是否启动播放
@property (nonatomic, assign) bool isbegan;

///是否启动播放
@property (nonatomic, assign) bool isCurrent;

@property (nonatomic, strong) TXVodPlayer * player;



@end


@interface YCTVideoViewModel : YCTBaseViewModel

@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, copy, readonly) NSArray<YCTVideoCellViewModel *> * cellModels;
@property (nonatomic, readonly, strong) RACSubject * playSubject;

- (void)onWilldisappear;

- (void)onWillAppear;

- (void)updateModels:(NSArray<YCTVideoModel *> *)models refresh:(BOOL)refresh;

- (void)releasePlayer;
@end




NS_ASSUME_NONNULL_END
