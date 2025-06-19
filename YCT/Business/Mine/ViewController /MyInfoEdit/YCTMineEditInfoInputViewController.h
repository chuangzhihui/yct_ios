//
//  YCTMineEditInfoInputViewController.h
//  YCT
//
//  Created by 木木木 on 2021/12/25.
//

#import "YCTBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface YCTMineEditInfoInputViewController : YCTBaseViewController

@property (nonatomic, copy, readonly) NSString *textValue;

@property (nonatomic, copy) NSString *originalValue;

@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UILabel *infoLabel;
@property (nonatomic, strong) UIBarButtonItem *saveItem;

- (void)textFieldFormat;
- (void)saveClick;

- (NSUInteger)maxInputLength;
- (NSUInteger)minInputLength;

@end

NS_ASSUME_NONNULL_END
