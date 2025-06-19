//
//  TUIMessageController+Hook.m
//  YCT
//
//  Created by 木木木 on 2021/12/20.
//

#import "TUIMessageController+Hook.h"
#import "NSObject+Utils.h"

@implementation TUIMessageController (Hook)

+ (void)load {
    [NSObject methodSwizzleWithClass:self.class origSEL:@selector(viewDidLoad) overrideSEL:@selector(yct_viewDidLoad)];
}

- (void)yct_viewDidLoad {
    [self yct_viewDidLoad];
    
    self.tableView.backgroundColor = UIColor.whiteColor;
    self.view.backgroundColor = UIColor.whiteColor;
}

@end
