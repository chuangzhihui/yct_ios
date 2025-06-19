//
//  YCTKeyValueStorage.m
//  SamClub
//
//  Created by zoyagzhou on 2019/12/16.
//  Copyright © 2019 tencent. All rights reserved.
//

#import "YCTKeyValueStorage.h"
#import <MMKV.h>

@interface YCTKeyValueStorage ()

@property (nonatomic, copy, readwrite) NSString *keyPrefix;

@end

@implementation YCTKeyValueStorage

+ (instancetype)defaultStorage
{
    return [[self alloc] initWithKeyPrefix:@""];
}

- (instancetype)initWithKeyPrefix:(NSString *)keyPrefix
{
    self = [super init];
    if (self) {
        self.keyPrefix = keyPrefix;
    }
    return self;
}

- (instancetype)copyWithZone:(NSZone * _Nullable)zone
{
    YCTKeyValueStorage *copy = [[[self class] alloc] initWithKeyPrefix:self.keyPrefix];
    return copy;
}

- (instancetype)subStorage:(NSString *)postfix
{
    YCTKeyValueStorage *sub = [self copy];
    sub.keyPrefix = [sub.keyPrefix stringByAppendingString:postfix];
    return sub;
}

- (NSString *)fullKey:(NSString *)key
{
    return [NSString stringWithFormat:@"%@%@", self.keyPrefix, key];
}

- (void)setObject:(id _Nullable)object forKey:(NSString *)key
{
    if (object) {
        [[MMKV defaultMMKV] setObject:object forKey:[self fullKey:key]];
    } else {
        [[MMKV defaultMMKV] removeValueForKey:[self fullKey:key]];
    }
    
    if([object isKindOfClass:[NSString class]]){
        [[NSUserDefaults standardUserDefaults] setObject:object forKey:kUserLanguageKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (BOOL)hasObjectForKey:(NSString *)key
{
    return [[MMKV defaultMMKV] containsKey:[self fullKey:key]];
}

- (id _Nullable)objectForKey:(NSString *)key ofClass:(Class)classObject
{
    id object = [[MMKV defaultMMKV] getObjectOfClass:classObject forKey:[self fullKey:key]];
    if (object && classObject && ![object isKindOfClass:classObject]) {
        return nil;
    }
    return object;
}


@end
