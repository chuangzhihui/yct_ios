//
//  YCTApiPayPalDoPay.m
//  YCT
//
//  Created by 张大爷的 on 2024/6/23.
//

#import "YCTApiPayPalDoPay.h"

@implementation YCTApiPayPalDoPay
- (NSString *)requestUrl {
    return @"/index/home/payorder";
}
- (NSDictionary *)yct_requestArgument {
    NSMutableDictionary *argument = @{}.mutableCopy;
    [argument setValue:self.order_sn forKey:@"order_sn"];
    return argument.copy;
}
@end
