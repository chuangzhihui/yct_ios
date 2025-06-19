//
//  AppDelegate.h
//  YCT
//
//  Created by 木木木 on 2021/12/8.
//

#import <UIKit/UIKit.h>


@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

- (void)initRootVC;
- (void)switchToNewRootVC;

@end

