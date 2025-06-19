//
//  YCTApiAuthPay.m
//  YCT
//
//  Created by 张大爷的 on 2024/6/22.
//

#import "YCTApiAuthPay.h"
#import "YCTAuthPayModel.h"
@implementation YCTApiAuthPay

- (instancetype)initWithType:(NSString *)type{
    self = [super init];
    if (self) {
        self.type = type;
    }
    return self;
}
- (instancetype)initWithType:(NSString *)cate usrType:(ApiAuthPayType)usrType price:(NSString *)price aiID:(NSInteger)aiID {
    self = [super init];
    if (self) {
        self.type = cate;
        self.usrType = usrType;
        self.price = price;
        self.aiID = aiID;
        self.lookType = 2;
    }
    return self;
}
- (instancetype)initWithUsrType:(ApiAuthPayType)usrType aiID:(NSInteger)aiID {
    self = [super init];
    if (self) {
        self.usrType = usrType;
        self.aiID = aiID;
        self.lookType = 1;
    }
    return self;
}
- (NSString *)requestUrl {
    if (_usrType == ApiAuthPayTypeAiOther) {
        return @"/index/user/aiPay";
    } else {
        return @"/index/user/authpay"; // Live URL
    //    return @"/index/user/payment"; // Local URL
    }
}
- (NSDictionary *)yct_requestArgument {
    NSMutableDictionary *argument = @{}.mutableCopy;
    if (_usrType == ApiAuthPayTypeAiOther) {
        if (_lookType == 2) {
            [argument setValue:self.type forKey:@"cate"];
//            [argument setValue:self.price forKey:@"price"];
//            [argument setValue:@(self.aiID) forKey:@"aiID"];
        }
        [argument setValue:@(self.lookType) forKey:@"type"];
        return argument.copy;
    } else {
        [argument setValue:self.type forKey:@"type"];
        return argument.copy;
    }
}
- (Class)dataModelClass {
    return YCTAuthPayModel.class;
}
@end
