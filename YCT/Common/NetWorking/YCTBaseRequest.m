//
//  SCBaseRequest.m
//  SCNetworking
//
//  Created by 李佳宏 on 2020/11/5.
//

#import "YCTBaseRequest.h"
#import "YCTBaseRequestAgent.h"
#import <YYModel/YYModel.h>

NSString * const YCTRequestErrorDomain = @"com.hhkj.yct.error.request";

NSInteger const YCTRequestErrorCode = 123;

@interface YCTBaseRequest()
@property (nonatomic, strong, readwrite, nullable) id responseDataModel;
@end

@implementation YCTBaseRequest

- (instancetype)init {
    self = [super init];
    if (self) {
        self.isShowLoading = YES;
        self.isShowErrorToust = YES;
        self.isShowErrorToust = YES;
    }
    return self;
}

- (NSDictionary<NSString *,NSString *> *)requestHeaderFieldValueDictionary {
    if ([[YCTBaseRequestAgent sharedAgent].config respondsToSelector:@selector(configPublicRequestHeaderDicWithRequest:)]) {
        return [[YCTBaseRequestAgent sharedAgent].config configPublicRequestHeaderDicWithRequest:self];
    } else {
        return @{};
    }
}

- (id)jsonValidator {
    if ([[YCTBaseRequestAgent sharedAgent].config respondsToSelector:@selector(jsonValidatorWithReuqest:)]) {
        return [[YCTBaseRequestAgent sharedAgent].config jsonValidatorWithReuqest:self];
    } else {
        return @{};
    }
}

- (void)startWithCompletionBlockWithSuccess:(YTKRequestCompletionBlock)success failure:(YTKRequestCompletionBlock)failure {
    if ([[YCTBaseRequestAgent sharedAgent].config respondsToSelector:@selector(showLoading)] && self.isShowLoading) {
        [[YCTBaseRequestAgent sharedAgent].config showLoading];
    }
    if ([[YCTBaseRequestAgent sharedAgent].config respondsToSelector:@selector(configPublicRequestUrlArgumentWithArgument:)]) {
        [[YCTBaseRequestAgent sharedAgent] addPublicArgumentWithRequestArgument:[[YCTBaseRequestAgent sharedAgent].config configPublicRequestUrlArgumentWithArgument:[self yct_requestArgument]]];
    }
    [super startWithCompletionBlockWithSuccess:success failure:failure];
}

- (void)requestCompletePreprocessor {
    [self JSONConvertModel];
    if ([[YCTBaseRequestAgent sharedAgent].config respondsToSelector:@selector(showReuqestSuccessMessage:)] && self.isShowSuccessToust) {
        [[YCTBaseRequestAgent sharedAgent].config showReuqestSuccessMessage:self];
    }
}

- (void)requestFailedPreprocessor {
    if ([[YCTBaseRequestAgent sharedAgent].config respondsToSelector:@selector(showErrorMessageWithMessage:)] && self.isShowErrorToust) {
        [[YCTBaseRequestAgent sharedAgent].config showErrorMessageWithMessage:self];
    }
}

- (YTKRequestSerializerType)requestSerializerType {
    return YTKRequestSerializerTypeJSON;
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}
- (NSTimeInterval)requestTimeoutInterval {
    return 120;
}

- (Class)dataModelClass {
    return nil;
}

- (void)JSONConvertModel {
    Class modelClass = [self dataModelClass];
    if (!modelClass) {
        return;
    }

    NSError * error = nil;
    id dataDict = nil;
    if ([[YCTBaseRequestAgent sharedAgent].config respondsToSelector:@selector(getParsedDataWithRequestResultDict:)]) {
        dataDict = [[YCTBaseRequestAgent sharedAgent].config getParsedDataWithRequestResultDict:self.responseJSONObject];
    }
    if ([dataDict isKindOfClass:[NSDictionary class]]) {
        
        self.responseDataModel = [modelClass yy_modelWithJSON:dataDict];
    }
    
    else if ([dataDict isKindOfClass:[NSArray class]]) {
        
        self.responseDataModel = [NSArray yy_modelArrayWithClass:modelClass json:dataDict];
    }
    
    if (error) {
        
    }
}

- (id)requestArgument{
    NSMutableDictionary * arg = @{}.mutableCopy;
    if ([[YCTBaseRequestAgent sharedAgent].config respondsToSelector:@selector(configPublicRequestArgumentWithArgument:)]) {
        [arg addEntriesFromDictionary:[[YCTBaseRequestAgent sharedAgent].config configPublicRequestArgumentWithArgument:[self yct_requestArgument]]];
    }
    [arg addEntriesFromDictionary:[self yct_requestArgument]];
    return arg.copy;
}

- (NSDictionary *)yct_requestArgument{
    return nil;
}

- (NSString *)getMsg {
    if (YCT_IS_DICTIONARY(self.responseObject) && (self.responseObject[@"msg"] != [NSNull null])) {
        return self.responseObject[@"msg"];
    }
    return @"";
}

- (NSString *)getError {
    if (YCT_IS_DICTIONARY(self.responseObject)) {
        return (self.responseObject[@"msg"] == [NSNull null]) ? YCTLocalizedString(@"request.error") : self.responseObject[@"msg"];
    } else if (self.error) {
        return self.error.localizedDescription;
    } else {
        return YCTLocalizedString(@"request.error");
    }
}

@end
