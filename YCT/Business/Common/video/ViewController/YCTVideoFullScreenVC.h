//
//  YCTVideoFullScreenVC.h
//  YCT
//
//  Created by hua-cloud on 2022/5/10.
//

#import <UIKit/UIKit.h>
#import <SJVideoPlayer.h>
NS_ASSUME_NONNULL_BEGIN

@interface YCTVideoFullScreenVC : UIViewController

@property (nonatomic, strong) SJVideoPlayer *player;
@property (nonatomic, strong) void(^dismissCallBack)(NSTimeInterval currentTime);
@end

NS_ASSUME_NONNULL_END
