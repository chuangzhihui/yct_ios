//
//  YCTApiUpdateGX.m
//  YCT
//
//  Created by 木木木 on 2022/1/11.
//

#import "YCTApiUpdateGX.h"

@implementation YCTApiDeleteGX {
    NSString *_id;
}

- (instancetype)initWithGXId:(NSString *)gxId {
    self = [super init];
    if (self) {
        _id = gxId;
    }
    return self;
}

- (NSString *)requestUrl {
    return @"/index/user/shanchuGX";
}

- (NSDictionary *)yct_requestArgument {
    NSMutableDictionary *argument = @{}.mutableCopy;
    [argument setValue:_id forKey:@"id"];
    return argument.copy;
}

@end

@implementation YCTApiOffshelfGX {
    NSString *_id;
}

- (instancetype)initWithGXId:(NSString *)gxId {
    self = [super init];
    if (self) {
        _id = gxId;
    }
    return self;
}

- (NSString *)requestUrl {
    return @"/index/user/xiajiaGX";
}

- (NSDictionary *)yct_requestArgument {
    NSMutableDictionary *argument = @{}.mutableCopy;
    [argument setValue:_id forKey:@"id"];
    return argument.copy;
}

@end

@implementation YCTApiUpdateGX {
    NSString *_id;
    NSString *_title;
    NSArray *_imgs;
    NSString *_mobile;
    NSString *_address;
    NSArray *_tagTexts;
    NSString *_locationId;
    NSString *_goodstype;
}

- (instancetype)initWithGXId:(NSString *)gxId
                       title:(NSString *)title
                        imgs:(NSArray *)imgs
                      mobile:(NSString *)mobile
                     address:(NSString *)address
                  locationId:(NSString *)locationId
                   goodstype:(NSString *)goodstype
                    tagTexts:(NSArray *)tagTexts {
    self = [super init];
    if (self) {
        _id = gxId;
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
    return @"/index/user/editGX";
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
    [argument setValue:_id forKey:@"id"];
    [argument setValue:_goodstype forKey:@"goodstype"];
    [argument setValue:_locationId forKey:@"locationId"];
    [argument setValue:_title forKey:@"title"];
    [argument setValue:[_imgs componentsJoinedByString:@","] forKey:@"imgs"];
    [argument setValue:_mobile forKey:@"mobile"];
    [argument setValue:_address forKey:@"address"];
    [argument setValue:[tags componentsJoinedByString:@","] forKey:@"tagTexts"];
    return argument.copy;
}

@end
