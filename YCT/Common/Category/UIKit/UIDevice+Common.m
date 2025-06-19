//
//  UIDevice+Common.m
//  YCT
//
//  Created by 木木木 on 2022/1/9.
//

#import "UIDevice+Common.h"

@implementation UIDevice (Common)

+ (void)launchImpactFeedback {
    if (@available(iOS 10.0, *)) {
        UIImpactFeedbackGenerator *impactFeedBack = [[UIImpactFeedbackGenerator alloc] initWithStyle:UIImpactFeedbackStyleHeavy];
        [impactFeedBack prepare];
        [impactFeedBack impactOccurred];
    }
}

@end
