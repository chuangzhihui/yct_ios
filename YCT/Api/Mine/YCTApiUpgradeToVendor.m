//
//  YCTApiUpgradeToVendor.m
//  YCT
//
//  Created by 木木木 on 2022/3/1.
//

#import "YCTApiUpgradeToVendor.h"

@implementation YCTApiUpgradeToVendor

- (NSString *)requestUrl {
    return @"/index/user/updateUser";
}

- (NSDictionary *)yct_requestArgument {
    NSMutableDictionary *argument = @{}.mutableCopy;
    [argument setValue:self.companyName forKey:@"companyName"];
    [argument setValue:self.introduce forKey:@"introduce"];
    [argument setValue:self.companyAddress forKey:@"companyAddress"];
    [argument setValue:self.companyPhone forKey:@"companyPhone"];
    
    [argument setValue:self.companyContact forKey:@"companyContact"];
    
    [argument setValue:self.locationaddress forKey:@"locationaddress"];
    
    [argument setValue:self.companyEmail forKey:@"companyEmail"];
    
    [argument setValue:self.companytype forKey:@"companytype"];
    
    [argument setValue:self.companyWebSite forKey:@"companyWebSite"];
    [argument setValue:self.goodstypef forKey:@"goodstypef"];
    [argument setValue:self.goodstypes forKey:@"goodstypes"];
    [argument setValue:self.goodstypet forKey:@"goodstypet"];
    [argument setValue:self.goodstypesid forKey:@"goodstypesid"];
    [argument setValue:self.goodstypefid forKey:@"goodstypefid"];
    [argument setValue:self.companydetail forKey:@"companydetail"];
    [argument setValue:self.socialcode forKey:@"socialcode"];
    
    [argument setValue:self.businessstart forKey:@"businessstart"];
    [argument setValue:self.registeredcapital forKey:@"registeredcapital"];
    [argument setValue:self.legalname forKey:@"legalname"];
    [argument setValue:self.direction forKey:@"direction"];
    [argument setValue:self.businessLicense forKey:@"businessLicense"];
    [argument setValue:self.doorHeadPic forKey:@"doorHeadPic"];
    [argument setValue:self.locationId forKey:@"locationId"];
    NSLog(@"%@",argument);
    return argument.copy;
}

@end
