//
//  YCTApiBasicMsg.m
//  YCT
//
//  Created by 木木木 on 2021/12/28.
//

#import "YCTApiBasicMsg.h"

@implementation YCTApiBasicMsg

- (NSString *)requestUrl {
    return @"/index/msg/basicMsg";
}

- (Class)dataModelClass {
    return YCTBasicMsgModel.class;
}

@end
