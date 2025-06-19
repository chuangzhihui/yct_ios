//
//  YCTKeyValueStorage.h
//  SamClub
//
//  Created by zoyagzhou on 2019/12/16.
//  Copyright © 2019 tencent. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YCTKeyValueStorage : NSObject

+ (instancetype)defaultStorage;

// create sub stroage by append postfix to keyPrefix
- (instancetype)subStorage:(NSString *)postfix;

- (void)setObject:(id _Nullable)object
           forKey:(NSString *)key;

- (id _Nullable)objectForKey:(NSString *)key ofClass:(Class)classObject;

@end

NS_ASSUME_NONNULL_END
