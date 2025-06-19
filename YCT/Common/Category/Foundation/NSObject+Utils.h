//
//  NSObject+Utils.h
//  YCT
//
//  Created by 木木木 on 2021/12/14.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (Utils)

+ (void)methodSwizzleWithClass:(Class)c origSEL:(SEL)origSEL overrideSEL:(SEL)overrideSEL;

@end

NS_ASSUME_NONNULL_END
