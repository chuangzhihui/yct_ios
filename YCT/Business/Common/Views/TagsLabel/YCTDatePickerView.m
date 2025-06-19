//
//  YCTDatePickerView.m
//  YCT
//
//  Created by 木木木 on 2021/12/30.
//

#import "YCTDatePickerView.h"

@interface YCTDatePickerView ()

@property (strong, nonatomic) UIDatePicker *picker;

@end

@implementation YCTDatePickerView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    self.frame = CGRectMake(0, 0, Iphone_Width, 300 + YCTSafeBottom);
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    cancelBtn.frame = CGRectMake(0, 0, 100, 40);
    cancelBtn.backgroundColor = [UIColor clearColor];
    cancelBtn.titleLabel.font = [UIFont PingFangSCMedium:16];
    [cancelBtn setTitle:YCTLocalizedString(@"action.cancel") forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(datePickerCancelButtonPress:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:cancelBtn];
    
    UIButton *sureBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    sureBtn.frame = (CGRect){CGRectGetWidth(self.frame) - 100, 0, 100, 40};
    sureBtn.backgroundColor = [UIColor clearColor];
    sureBtn.titleLabel.font = [UIFont PingFangSCMedium:16];
    [sureBtn setTitle:YCTLocalizedString(@"action.confirm") forState:UIControlStateNormal];
    [sureBtn addTarget:self action:@selector(datePickerSureButtonPress:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:sureBtn];
    
    UIDatePicker *picker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 40, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame) - 40)];
    if (@available(iOS 13.4, *)) {
        picker.preferredDatePickerStyle = UIDatePickerStyleWheels;
    }
    picker.maximumDate = [NSDate date];
    picker.datePickerMode = UIDatePickerModeDate;
    [self addSubview:picker];
    [picker mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(40);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(CGRectGetHeight(self.frame) - 40);
    }];
    self.picker = picker;
}

- (void)datePickerSureButtonPress:(UIButton *)sender {
    [self yct_closeWithCompletion:^{
        if (self.confirmClickBlock) {
            self.confirmClickBlock(self.picker.date);
        }
    }];
}

- (void)datePickerCancelButtonPress:(UIButton *)sender {
    [self yct_closeWithCompletion:^{
        
    }];
}


@end
