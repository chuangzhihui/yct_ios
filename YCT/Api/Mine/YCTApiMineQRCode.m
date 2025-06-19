//
//  YCTApiMineQRCode.m
//  YCT
//
//  Created by 木木木 on 2022/1/19.
//

#import "YCTApiMineQRCode.h"

@implementation YCTApiMineQRCode

- (NSString *)requestUrl {
    return @"/index/user/getQrcode";
}

- (Class)dataModelClass {
    return YCTMineQRCodeModel.class;
}

@end
