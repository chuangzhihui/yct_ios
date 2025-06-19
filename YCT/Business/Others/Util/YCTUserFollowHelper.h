//
//  YCTUserFollowHelper.h
//  YCT
//
//  Created by 木木木 on 2022/1/13.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol YCTUserFollowProtocol <NSObject>
@property (nonatomic, assign, readwrite) BOOL isFollow;
- (NSString *)userId;
@end

@protocol YCTUserMutualProtocol <NSObject>
@property (nonatomic, assign, readwrite) BOOL isMutual;
- (NSString *)userId;
@end

@interface YCTUserFollowHelper : NSObject

YCT_SINGLETON_DEF

- (void)handleFollowStateWithUser:(id<YCTUserFollowProtocol>)user;

- (void)handleMutualStateWithUser:(id<YCTUserMutualProtocol>)user;

@end

NS_ASSUME_NONNULL_END
