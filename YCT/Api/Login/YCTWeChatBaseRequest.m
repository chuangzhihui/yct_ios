//
//  YCTWeChatBaseRequest.m
//  YCT
//
//  Created by 木木木 on 2022/1/24.
//

#import "YCTWeChatBaseRequest.h"
#import <YYModel/YYModel.h>

@interface YCTWeChatBaseRequest()
@property (nonatomic, strong, readwrite, nullable) id responseDataModel;
@end

@implementation YCTWeChatBaseRequest

- (YTKRequestSerializerType)requestSerializerType {
    return YTKRequestSerializerTypeHTTP;
}

- (YTKResponseSerializerType)responseSerializerType {
    return YTKResponseSerializerTypeHTTP;
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGET;
}

- (Class)dataModelClass {
    return nil;
}

- (void)requestCompletePreprocessor {
    [self JSONConvertModel];
}

- (void)JSONConvertModel {
    Class modelClass = [self dataModelClass];
    if (!modelClass) {
        return;
    }

    NSError *jsonError = nil;
    
    id jsonResponse = [NSJSONSerialization JSONObjectWithData:self.responseData options:NSJSONReadingMutableContainers error:&jsonError];
    
    if ([jsonResponse isKindOfClass:[NSDictionary class]]) {
        
        self.responseDataModel = [modelClass yy_modelWithJSON:jsonResponse];
    }
    
    else if ([jsonResponse isKindOfClass:[NSArray class]]) {
        
        self.responseDataModel = [NSArray yy_modelArrayWithClass:modelClass json:jsonResponse];
    }
}

- (NSString *)baseUrl {
    return @"https://api.weixin.qq.com";
}

@end
