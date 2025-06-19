//
//  NSObject+YCTShareData.m
//  YCT
//
//  Created by 木木木 on 2022/1/13.
//

#import "NSObject+YCTShareData.h"
#import "YCTSharedDataManager.h"

@implementation NSObject (YCTShareData)

- (BOOL)canPerformKeyPath:(NSString *)keyPath {
    if ([self conformsToProtocol:@protocol(YCTSharedDataProtocol)] && keyPath.length > 0) {
        id<YCTSharedDataProtocol> cself = (id<YCTSharedDataProtocol>)self;
        if (!cself.dataType) {
            return NO;
        }
        
        NSString *selectorStr = [NSString stringWithFormat:@"set%@%@:", [[keyPath substringWithRange:(NSRange){0, 1}] uppercaseString], [keyPath substringFromIndex:1]];
        if ([self respondsToSelector:NSSelectorFromString(selectorStr)]) {
            return YES;
        }
    }
    return NO;
}

- (void)sendValue:(id)value keyPath:(NSString *)keyPath {
    if ([self conformsToProtocol:@protocol(YCTSharedDataProtocol)]) {
        id<YCTSharedDataProtocol> cself = (id<YCTSharedDataProtocol>)self;
        [[YCTSharedDataManager sharedInstance] sendValue:value keyPath:keyPath type:cself.dataType id:cself.id];
    }
}

@end
