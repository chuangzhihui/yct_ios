//
//  YCTNavigationCoordinator.h
//  YCT
//
//  Created by 木木木 on 2021/12/28.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YCTNavigationCoordinator : NSObject

+ (void)loginIfNeededWithAction:(void(^ _Nullable)(void))action;

+ (void)login;

+ (void)checkIfNeededCompleteVendorInfoWithNav:(UINavigationController *)nav
                                    index:(int) index
                                    user_type:(int) user_type
                                  alertContent:(NSString *)alertContent
                                        action:(void(^ _Nullable)(void))action
                                  profileAction:(void(^ _Nullable)(void))moveToProfileAdd;

+ (BOOL)checkIfMoveToUserProfileWithNav:(UINavigationController *)nav
                           alertContent:(NSString *)alertContent;

@end

NS_ASSUME_NONNULL_END
