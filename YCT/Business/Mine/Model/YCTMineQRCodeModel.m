//
//  YCTMineQRCodeModel.m
//  YCT
//
//  Created by 木木木 on 2022/1/19.
//

#import "YCTMineQRCodeModel.h"

@implementation YCTQRCodeUserInfoModel
@end

@implementation YCTMineQRCodeModel

+ (NSArray<NSString *> *)modelPropertyBlacklist {
    return @[@"user"];
}

- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic {
    NSString *json = [self.qrcode stringByReplacingOccurrencesOfString:@"(\\w+)\\s*:([A-Za-z0-9_])" withString:@"\"$1\":$2" options:NSRegularExpressionSearch range:(NSRange){0, self.qrcode.length}];
    self.user = [YCTQRCodeUserInfoModel yy_modelWithJSON:json];
    return YES;
}

@end
