//
//  YCTPublistViewController.h
//  YCT
//
//  Created by hua-cloud on 2022/1/3.
//

#import "YCTBaseViewController.h"
#import "YCTVideoModel.h"
#import "YCTPublishVideoModel.h"
#import <UGCKit/UGCKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YCTPublishViewController : YCTBaseViewController

///发布视频
- (instancetype)initWithUGCKitResult:(UGCKitResult *)UGCKitResult;
@property (nonatomic, assign) BOOL isFromVideoView;   // New variable 1 as BOOL
@property (nonatomic, strong) NSString *filePath;

+ (void)publishDraftWithVideoId:(NSInteger)videoId;

@end

NS_ASSUME_NONNULL_END
