//
//  UIResponder+SCCategory.h
//  SamClub
//
//  Created by 李佳宏 on 2020/2/18.
//  Copyright © 2020 tencent. All rights reserved.
//



#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIResponder (ResponseChain)

- (void)responseChainWithEventName:(NSString *)eventName userInfo:(NSDictionary * _Nullable)userInfo;

@end


NS_ASSUME_NONNULL_END
