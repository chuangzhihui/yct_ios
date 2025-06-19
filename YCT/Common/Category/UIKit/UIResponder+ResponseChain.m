//
//  UIResponder+SCCategory.m
//  SamClub
//
//  Created by 李佳宏 on 2020/2/18.
//  Copyright © 2020 tencent. All rights reserved.
//

#import "UIResponder+ResponseChain.h"


@implementation UIResponder (ResponseChain)

- (void)responseChainWithEventName:(NSString *)eventName userInfo:(NSDictionary *)userInfo {
    if (self.nextResponder) {
        [[self nextResponder] responseChainWithEventName:eventName userInfo:userInfo];
    }
}

@end
