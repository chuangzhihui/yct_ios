//
//  YCTApiSupplyDemandList.m
//  YCT
//
//  Created by 木木木 on 2022/1/14.
//

#import "YCTApiSupplyDemandList.h"

@implementation YCTApiSupplyDemandList {
   
}



- (NSString *)requestUrl {
    return @"/index/home/gxList";
}

- (Class)dataModelClass {
    return YCTSupplyDemandItemModel.class;
}

- (NSDictionary *)yct_requestArgument {
    NSMutableDictionary *argument = [NSMutableDictionary dictionaryWithDictionary:[super yct_requestArgument]];
    [argument setValue:@(self.type) forKey:@"type"];
    [argument setValue:self.locationId forKey:@"locationId"];
    [argument setValue:self.keywords forKey:@"keywords"];
    return argument.copy;
}

@end
