//
//  UIAlertController+Common.h
//  PDA1919
//
//  Created by 木木木 on 2021/9/14.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^UIAlertControllerCompletionBlock) (UIAlertController * controller, UIAlertAction * action, NSInteger buttonIndex);
typedef void (^UIAlertControllerInputCompletionBlock) (UIAlertController * controller, NSString *input);

@interface UIAlertController (Common)

+ (instancetype)showInViewController:(UIViewController *)viewController
                           withTitle:(NSString * _Nullable)title
                             message:(NSString *)message
                      preferredStyle:(UIAlertControllerStyle)preferredStyle
                   cancelButtonTitle:(NSString *)cancelButtonTitle
              destructiveButtonTitle:(NSString * _Nullable)destructiveButtonTitle
                   otherButtonTitles:(NSArray * _Nullable)otherButtonTitles
                            tapBlock:(UIAlertControllerCompletionBlock _Nullable)tapBlock;

+ (instancetype)showAlertInViewController:(UIViewController *)viewController
                                withTitle:(NSString * _Nullable)title
                                  message:(NSString *)message
                        cancelButtonTitle:(NSString *)cancelButtonTitle
                   destructiveButtonTitle:(NSString * _Nullable)destructiveButtonTitle
                        otherButtonTitles:(NSArray * _Nullable)otherButtonTitles
                                 tapBlock:(UIAlertControllerCompletionBlock _Nullable)tapBlock;

+ (instancetype)showActionSheetInViewController:(UIViewController *)viewController
                                      withTitle:(NSString * _Nullable)title
                                        message:(NSString *)message
                              cancelButtonTitle:(NSString *)cancelButtonTitle
                         destructiveButtonTitle:(NSString * _Nullable)destructiveButtonTitle
                              otherButtonTitles:(NSArray * _Nullable)otherButtonTitles
                                       tapBlock:(UIAlertControllerCompletionBlock _Nullable)tapBlock;

+ (instancetype)showAlertInViewController:(UIViewController *)viewController
                                withTitle:(NSString * _Nullable)title
                                  message:(NSString *)message
                        cancelButtonTitle:(NSString *)cancelButtonTitle
                        otherButtonTitles:(NSArray * _Nullable)otherButtonTitles
                                 tapBlock:(UIAlertControllerCompletionBlock)tapBlock
                   configurationTextFiled:(void(^)(UITextField * textFiled))configurationTextFiled;

+ (instancetype)alertControllerWithTitle:(NSString * _Nullable)title
                                 message:(NSString *)message
                          preferredStyle:(UIAlertControllerStyle)preferredStyle
                       cancelButtonTitle:(NSString *)cancelButtonTitle
                  destructiveButtonTitle:(NSString * _Nullable)destructiveButtonTitle
                       otherButtonTitles:(NSArray * _Nullable)otherButtonTitles
                                tapBlock:(UIAlertControllerCompletionBlock _Nullable)tapBlock;

@property (readonly, nonatomic) BOOL visible;
@property (readonly, nonatomic) NSInteger cancelButtonIndex;
@property (readonly, nonatomic) NSInteger firstOtherButtonIndex;
@property (readonly, nonatomic) NSInteger destructiveButtonIndex;

@end

@interface UIAlertController (Window)

- (void)show;
- (void)show:(BOOL)animated;

@end


NS_ASSUME_NONNULL_END
