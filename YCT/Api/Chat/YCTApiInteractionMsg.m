//
//  YCTApiInteractionMsg.m
//  YCT
//
//  Created by 木木木 on 2021/12/29.
//

#import "YCTApiInteractionMsg.h"

@implementation YCTApiInteractionMsg

- (NSString *)requestUrl {
    return @"/index/msg/interactionMsgList";
}

- (Class)dataModelClass {
    return YCTInteractionMsgModel.class;
}

@end
