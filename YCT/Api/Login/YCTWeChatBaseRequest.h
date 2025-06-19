//
//  YCTWeChatBaseRequest.h
//  YCT
//
//  Created by 木木木 on 2022/1/24.
//

#import <YTKNetwork/YTKNetwork.h>

NS_ASSUME_NONNULL_BEGIN

@interface YCTWeChatBaseRequest : YTKBaseRequest

@property (nonatomic, strong, readonly, nullable) id responseDataModel;

- (Class)dataModelClass;

@end

NS_ASSUME_NONNULL_END
