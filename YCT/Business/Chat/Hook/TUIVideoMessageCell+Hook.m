//
//  TUIVideoMessageCell+Hook.m
//  YCT
//
//  Created by 木木木 on 2021/12/20.
//

#import "TUIVideoMessageCell+Hook.h"
#import "NSObject+Utils.h"

@implementation TUIVideoMessageCell (Hook)

+ (void)load {
    [NSObject methodSwizzleWithClass:self.class origSEL:@selector(initWithStyle:reuseIdentifier:) overrideSEL:@selector(yct_initWithStyle:reuseIdentifier:)];
}

- (instancetype)yct_initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    [self yct_initWithStyle:style reuseIdentifier:reuseIdentifier];
    self.play.image = [UIImage imageNamed:@"chat_play"];
    return self;
}

@end
