//
//  TUIMessageCellData+Hook.m
//  YCT
//
//  Created by 木木木 on 2021/12/20.
//

#import "TUIMessageCellData+Hook.h"
#import "NSObject+Utils.h"

@implementation TUIMessageCellData (Hook)

+ (void)load {
    SEL sel = NSSelectorFromString(@"initWithDirection:");
    [NSObject methodSwizzleWithClass:self.class origSEL:sel overrideSEL:@selector(yct_initWithDirection:)];
}

- (instancetype)yct_initWithDirection:(TMsgDirection)direction {
    [self yct_initWithDirection:direction];
    self.showReadReceipt = NO;
    return self;
}

@end
