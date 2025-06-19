//
//  YCTApiSystemMsg.m
//  YCT
//
//  Created by 木木木 on 2021/12/29.
//

#import "YCTApiSystemMsg.h"

@implementation YCTApiSystemMsg

- (NSString *)requestUrl {
    return @"/index/msg/systemMsgList";
}

- (Class)dataModelClass {
    return YCTSystemMsgModel.class;
}

@end
