//
//  YCTApiUploadUserRegId.m
//  YCT
//
//  Created by 张大爷的 on 2024/6/23.
//

#import "YCTApiUploadUserRegId.h"

@implementation YCTApiUploadUserRegId
- (NSString *)requestUrl {
    return @"/index/user/updateUserRegId";
}
- (NSDictionary *)yct_requestArgument {
    NSMutableDictionary *argument = @{}.mutableCopy;
    [argument setValue:self.reg_id forKey:@"reg_id"];
    [argument setValue:@"2" forKey:@"type"];
    return argument.copy;
}
@end
