//
//  YCTDefaltValue.m
//  YCT
//
//  Created by hua-cloud on 2022/1/8.
//

#import "YCTDefaltValue.h"


BOOL YCTBool(id value, BOOL defaultValue)
{
    if ([value isKindOfClass:[NSNumber class]]) {
        return [(NSNumber *)value boolValue];
    }
    if ([value isKindOfClass:[NSString class]]) {
        return [(NSString *)value boolValue];
    }

    return defaultValue;
}

NSInteger YCTInteger(id value, NSInteger defaultValue)
{
    if ([value isKindOfClass:[NSNumber class]]) {
        return [(NSNumber *)value integerValue];
    }
    if ([value isKindOfClass:[NSString class]]) {
        return [(NSString *)value integerValue];
    }

    return defaultValue;
}

double YCTDouble(id value, double defaultValue)
{
    if ([value isKindOfClass:[NSNumber class]]) {
        return [(NSNumber *)value doubleValue];
    }
    if ([value isKindOfClass:[NSString class]]) {
        return [(NSString *)value doubleValue];
    }

    return defaultValue;
}

NSString * YCTString(id value, NSString * _Nullable defaultValue)
{
    if ([value isKindOfClass:[NSString class]]) {
        return (NSString *)value;
    }
    if ([value isKindOfClass:[NSNumber class]]) {
        return [(NSNumber *)value stringValue];
    }
    if ([value isKindOfClass:[NSNull class]]) {
        return defaultValue;
    }

    return defaultValue;
}

NSArray * YCTArray(id value, NSArray * _Nullable defaultValue)
{
    if ([value isKindOfClass:[NSArray class]]) {
        return (NSArray *)value;
    }

    return defaultValue;
}

NSDictionary * YCTDictionary(id value, NSDictionary * _Nullable defaultValue)
{
    if ([value isKindOfClass:[NSDictionary class]]) {
        return (NSDictionary *)value;
    }

    return defaultValue;
}

