//
//  YCTLanguageManager.m
//  YCT
//
//  Created by 木木木 on 2022/1/11.
//

#import "YCTLanguageManager.h"

@implementation YCTLanguageManager

+ (void)setLanguage:(NSString *)language {
    [MJRefreshConfig defaultConfig].languageCode = language;
    [YCTSanboxTool setLanguage:language];
}

@end
