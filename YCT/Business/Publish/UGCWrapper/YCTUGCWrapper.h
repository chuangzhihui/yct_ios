//
//  YCTUGCWrapper.h
//  YCT
//
//  Created by hua-cloud on 2022/1/5.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YCTUGCWrapper : NSObject

@property (nonatomic, copy) void (^onButtonClick)(void);
@property (nonatomic, copy) void (^onVideoRoPhotoClick)(NSInteger touchType);


- (NSString *)getEditingBgmId;

- (void)setEdtingBgmId:(NSString *)bgmId;

- (void)recordPublish;

- (void)videoPublish;
- (void)videoPublish:(UIViewController *)suprVc;

- (void)picturePublish;
-(void)picturePublish:(UIViewController *)suprVc;

- (void)createLive;
-(void)createLive:(UIViewController *)suprVc;

YCT_SINGLETON_DEF
@end

NS_ASSUME_NONNULL_END
