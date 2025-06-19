//
//  YCTMineEditInfoInputViewController.m
//  YCT
//
//  Created by 木木木 on 2021/12/25.
//

#import "YCTMineEditInfoInputViewController.h"
#import "UITextField+Common.h"
#import "NSString+Common.h"

@interface YCTMineEditInfoInputViewController ()

@property (nonatomic, copy, readwrite) NSString *textValue;
@property (nonatomic, strong) UILabel *countLimitLabel;

@end

@implementation YCTMineEditInfoInputViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)bindViewModel {
    self.textField.text = self.originalValue;
    
    @weakify(self);
    
    RAC(self.saveItem, enabled) = [self.textField.rac_textSignal map:^id _Nullable(NSString * _Nullable value) {
        @strongify(self);
        BOOL enabled = ![value isEqualToString:self.originalValue]
                    && value.length >= [self minInputLength];
        return @(enabled);
    }];
    
    [self.textField.rac_textSignal subscribeNext:^(id x) {
        @strongify(self);
        UITextRange *selectedRange = self.textField.markedTextRange;
        UITextPosition *position = [self.textField positionFromPosition:selectedRange.start offset:0];
        
        if (!position) {
            @weakify(self);
            [self.textField executeValueChangedTransactionKeepingCursorPosition:^{
                @strongify(self);
                [self textFieldFormat];
                [NSString handleText:self.textField.text limitCharLength:[self maxInputLength] completion:^(BOOL isBeyondLength, NSString * _Nullable result) {
                    if (isBeyondLength) {
                        self.textField.text = result;
                    }
                }];
            }];
        }
    }];
    
    RAC(self.countLimitLabel, text) = [self.textField.rac_textSignal map:^id _Nullable(NSString * _Nullable value) {
        @strongify(self);
        return [NSString stringWithFormat:@"%@/%@", @([self.textField.text characterLength]), @([self maxInputLength])];
    }];
}

- (void)setupView {
    UIView *textFieldContainer = ({
        UIView *view = [[UIView alloc] init];
        view.layer.cornerRadius = 25;
        view.backgroundColor = UIColor.tableBackgroundColor;
        view;
    });
    [self.view addSubview:textFieldContainer];
    [textFieldContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(kNavigationBarHeight + 20);
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.height.mas_equalTo(50);
    }];
    
    self.textField = ({
        UITextField *view = [[UITextField alloc] init];
        view.font = [UIFont PingFangSCMedium:16];
        view.textColor = UIColor.mainTextColor;
        view.borderStyle = UITextBorderStyleNone;
        view.clearButtonMode = UITextFieldViewModeAlways;
        view;
    });
    [textFieldContainer addSubview:self.textField];
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(25);
        make.right.mas_equalTo(-15);
        make.centerY.mas_equalTo(0);
    }];
    
    self.countLimitLabel = ({
        UILabel *view = [[UILabel alloc] init];
        view.font = [UIFont PingFangSCMedium:12];
        view.textColor = UIColor.mainGrayTextColor;
        view.textAlignment = NSTextAlignmentRight;
        view.text = @"1/20";
        view;
    });
    [self.view addSubview:self.countLimitLabel];
    [self.countLimitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(textFieldContainer.mas_bottom).mas_offset(8);
        make.right.mas_equalTo(-15);
        make.width.mas_equalTo(50);
    }];
    
    self.infoLabel = ({
        UILabel *view = [[UILabel alloc] init];
        view.font = [UIFont PingFangSCMedium:12];
        view.textColor = UIColor.mainGrayTextColor;
        view;
    });
    [self.view addSubview:self.infoLabel];
    [self.infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.countLimitLabel.mas_top);
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(self.countLimitLabel.mas_left);
    }];
    
    self.navigationItem.rightBarButtonItem = ({
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:YCTLocalizedTableString(@"mine.save", @"Mine") style:(UIBarButtonItemStylePlain) target:self action:@selector(saveClick)];
        [item setTitleTextAttributes:@{
            NSFontAttributeName: [UIFont PingFangSCMedium:16],
            NSForegroundColorAttributeName: UIColor.mainThemeColor
        } forState:UIControlStateNormal];
        [item setTitleTextAttributes:@{
            NSFontAttributeName: [UIFont PingFangSCMedium:16],
            NSForegroundColorAttributeName: UIColor.mainThemeColorLight
        } forState:UIControlStateDisabled];
        self.saveItem = item;
        item;
    });
}

- (void)saveClick {
    self.textValue = self.textField.text;
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)textFieldFormat {
    
}

- (NSUInteger)maxInputLength {
    return 20;
}

- (NSUInteger)minInputLength {
    return 0;
}

@end
