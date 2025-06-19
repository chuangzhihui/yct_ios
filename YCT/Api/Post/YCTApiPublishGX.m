//
//  YCTApiPublishGX.m
//  YCT
//
//  Created by 木木木 on 2021/12/27.
//

#import "YCTApiPublishGX.h"

@implementation YCTApiPublishGX {
    YCTPostType _type;
    NSString *_title;
    NSArray *_imgs;
    NSString *_mobile;
    NSString *_address;
    NSArray *_tagTexts;
    NSString *_locationId;
    NSString *_goodstype;
}

- (instancetype)initWithType:(YCTPostType)type
                       title:(NSString *)title
                        imgs:(NSArray *)imgs
                      mobile:(NSString *)mobile
                     address:(NSString *)address
                  locationId:(NSString *)locationId
                   goodstype:(NSString *)goodstype
                    tagTexts:(NSArray *)tagTexts {
    self = [super init];
    if (self) {
        _type = type;
        _title = title;
        _imgs = imgs;
        _mobile = mobile;
        _address = address;
        _tagTexts = tagTexts;
        _locationId = locationId;
        _goodstype = goodstype;
    }
    return self;
}

- (NSString *)requestUrl {
    return @"/index/report/publishGX";
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}

- (NSDictionary *)yct_requestArgument {
    NSMutableArray *tags = @[].mutableCopy;
    [_tagTexts enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj hasPrefix:@"#"]) {
            [tags addObject:[obj stringByReplacingCharactersInRange:(NSRange){0, 1} withString:@""]];
        } else {
            [tags addObject:obj];
        }
    }];

    NSMutableDictionary *argument = @{}.mutableCopy;
    [argument setValue:@(_type) forKey:@"type"];
    [argument setValue:_title ?: @"" forKey:@"title"];
    [argument setValue:[_imgs componentsJoinedByString:@","] ?: @"" forKey:@"imgs"];
    [argument setValue:_mobile ?: @"" forKey:@"mobile"];
    [argument setValue:_address ?: @"" forKey:@"address"];
    [argument setValue:[tags componentsJoinedByString:@","] ?: @"" forKey:@"tagTexts"];
    [argument setValue:_locationId ?: @"0" forKey:@"locationId"];
    [argument setValue:_goodstype forKey:@"goodstype"];
    return argument.copy;
}

@end
