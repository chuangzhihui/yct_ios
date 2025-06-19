//
//  NSObject+Utils.m
//  YCT
//
//  Created by 木木木 on 2021/12/14.
//

#import "NSObject+Utils.h"
#import <objc/runtime.h>

@implementation NSObject (Utils)

+ (void)methodSwizzleWithClass:(Class)class origSEL:(SEL)origSEL overrideSEL:(SEL)overrideSEL {
    Method originalMethod = class_getInstanceMethod(class, origSEL);
    Method swizzledMethod = class_getInstanceMethod(class, overrideSEL);
    
    BOOL didAddMethod = class_addMethod(class, origSEL, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
    
    if (didAddMethod) {
        class_replaceMethod(class, overrideSEL, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

@end
