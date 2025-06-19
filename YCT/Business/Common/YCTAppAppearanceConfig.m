//
//  YTCAppAppearanceConfig.m
//  YCT
//
//  Created by 木木木 on 2021/12/9.
//

#import "YCTAppAppearanceConfig.h"
#import "IQKeyboardManager.h"
#import "TUIConfig.h"
#import "TUIBubbleMessageCellData.h"
#import "TUIMessageCellLayout.h"
#import "TUITextMessageCellData.h"
#import "TUIVoiceMessageCellData.h"
#import <MBProgressHUD/MBProgressHUD.h>

@implementation YCTAppAppearanceConfig

+ (void)config {
    if (@available(iOS 15.0, *)) {
        UINavigationBarAppearance *navigationBarAppearance = [[UINavigationBarAppearance alloc] init];
        [navigationBarAppearance configureWithOpaqueBackground];
        navigationBarAppearance.titleTextAttributes = @{
            NSForegroundColorAttributeName: UIColor.navigationBarTitleColor
        };
        navigationBarAppearance.backgroundColor = UIColor.whiteColor;
        navigationBarAppearance.shadowColor = UIColor.clearColor;
        [UINavigationBar appearance].scrollEdgeAppearance = navigationBarAppearance;
        [UINavigationBar appearance].standardAppearance = navigationBarAppearance;
    } else {
        [[UINavigationBar appearance] setBarTintColor:UIColor.whiteColor];
        [[UINavigationBar appearance] setTitleTextAttributes:
         @{NSForegroundColorAttributeName: UIColor.navigationBarTitleColor}];
        [[UINavigationBar appearance] setShadowImage:[[UIImage alloc] init]];
    }
    
    [[UINavigationBar appearance] setTintColor:UIColor.navigationBarTitleColor];
    
    
//    [SDImageCache sharedImageCache].config.maxMemoryCost = 50 * 1024 * 1024;
    
    [UITableView appearance].estimatedRowHeight = 0;
    [UITableView appearance].estimatedSectionFooterHeight = 0;
    [UITableView appearance].estimatedSectionHeaderHeight = 0;
    
//    if (@available(iOS 13.0, *)) {
//        [UITableView appearance].automaticallyAdjustsScrollIndicatorInsets = NO;
//        [UICollectionView appearance].automaticallyAdjustsScrollIndicatorInsets = NO;
//    }
    
     if (@available(iOS 15.0, *)) {
        [UITableView appearance].sectionHeaderTopPadding = 0;
    }
    
    [[MBRoundProgressView appearanceWhenContainedInInstancesOfClasses:@[[MBProgressHUD class]]] setProgressTintColor:UIColor.mainThemeColor];
    
    TUIConfig *config = [TUIConfig defaultConfig];
    config.avatarType = TAvatarTypeRounded;
    config.defaultAvatarImage = [UIImage imageNamed:kDefaultAvatarImageName];
    
    CGFloat avatarSize = 36;
    UIEdgeInsets avatarInsets = UIEdgeInsetsMake(0, 15, 0, 15);
    UIEdgeInsets messageInsets = UIEdgeInsetsMake(0, 5, 20, 5);
    
    [TUIBubbleMessageCellData setOutgoingBubble:[[UIImage imageNamed:@"chat_bubble_out"] resizableImageWithCapInsets:UIEdgeInsetsMake(6, 6, 6, 6) resizingMode:UIImageResizingModeStretch]];
    [TUIBubbleMessageCellData setOutgoingHighlightedBubble:[[UIImage imageNamed:@"chat_bubble_out"] resizableImageWithCapInsets:UIEdgeInsetsMake(6, 6, 6, 6) resizingMode:UIImageResizingModeStretch]];
    [TUIBubbleMessageCellData setIncommingBubble:[[UIImage imageNamed:@"chat_bubble_in"] resizableImageWithCapInsets:UIEdgeInsetsMake(6, 6, 6, 6) resizingMode:UIImageResizingModeStretch]];
    [TUIBubbleMessageCellData setIncommingHighlightedBubble:[[UIImage imageNamed:@"chat_bubble_in"] resizableImageWithCapInsets:UIEdgeInsetsMake(6, 6, 6, 6) resizingMode:UIImageResizingModeStretch]];
    [TUIBubbleMessageCellData setOutgoingBubbleTop:0];
    [TUIBubbleMessageCellData setIncommingBubbleTop:0];
    
    
    [TUITextMessageCellData setOutgoingTextColor:UIColor.whiteColor];
    [TUITextMessageCellData setIncommingTextColor:UIColor.mainTextColor];
    [TUITextMessageCellData setOutgoingTextFont:[UIFont PingFangSCMedium:16]];
    [TUITextMessageCellData setIncommingTextFont:[UIFont PingFangSCMedium:16]];
    
    [TUIMessageCellLayout outgoingTextMessageLayout].bubbleInsets = (UIEdgeInsets){.top = 8, .bottom = 8, .left = 16, .right = 16};
    [TUIMessageCellLayout incommingTextMessageLayout].bubbleInsets = (UIEdgeInsets){.top = 8, .bottom = 8, .left = 16, .right = 16};
    
    
    [TUIVoiceMessageCellData setOutgoingVoiceTop:8];
    [TUIVoiceMessageCellData setIncommingVoiceTop:8];
    
    [TUIMessageCellLayout outgoingMessageLayout].avatarSize = CGSizeMake(avatarSize, avatarSize);
    [TUIMessageCellLayout incommingMessageLayout].avatarSize = CGSizeMake(avatarSize, avatarSize);
    [TUIMessageCellLayout outgoingTextMessageLayout].avatarSize = CGSizeMake(avatarSize, avatarSize);
    [TUIMessageCellLayout incommingTextMessageLayout].avatarSize = CGSizeMake(avatarSize, avatarSize);
    [TUIMessageCellLayout outgoingVoiceMessageLayout].avatarSize = CGSizeMake(avatarSize, avatarSize);
    [TUIMessageCellLayout incommingVoiceMessageLayout].avatarSize = CGSizeMake(avatarSize, avatarSize);
    
    [TUIMessageCellLayout outgoingMessageLayout].avatarInsets = avatarInsets;
    [TUIMessageCellLayout incommingMessageLayout].avatarInsets = avatarInsets;
    [TUIMessageCellLayout outgoingTextMessageLayout].avatarInsets = avatarInsets;
    [TUIMessageCellLayout incommingTextMessageLayout].avatarInsets = avatarInsets;
    [TUIMessageCellLayout outgoingVoiceMessageLayout].avatarInsets = avatarInsets;
    [TUIMessageCellLayout incommingVoiceMessageLayout].avatarInsets = avatarInsets;
    
    [TUIMessageCellLayout outgoingMessageLayout].messageInsets = messageInsets;
    [TUIMessageCellLayout incommingMessageLayout].messageInsets = messageInsets;
    [TUIMessageCellLayout outgoingTextMessageLayout].messageInsets = messageInsets;
    [TUIMessageCellLayout incommingTextMessageLayout].messageInsets = messageInsets;
    [TUIMessageCellLayout outgoingVoiceMessageLayout].messageInsets = messageInsets;
    [TUIMessageCellLayout incommingVoiceMessageLayout].messageInsets = messageInsets;
    
    [[IQKeyboardManager sharedManager].disabledToolbarClasses addObject:NSClassFromString(@"YCTCommentViewController")];
    [[IQKeyboardManager sharedManager].disabledDistanceHandlingClasses addObject:NSClassFromString(@"YCTCommentViewController")];
    
    Class inputControllerClass = NSClassFromString(@"TUIInputController");
    if (inputControllerClass) {
        [[[IQKeyboardManager sharedManager] disabledToolbarClasses] addObject:inputControllerClass];
    }
}

@end
