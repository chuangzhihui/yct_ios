//
//  YCTTextView.m
//  YCT
//
//  Created by 木木木 on 2021/12/25.
//

#import "YCTTextView.h"
#import "UITextView+Common.h"
#import "NSString+Common.h"
#import "UITextView+YCT_RAC.h"

#define kMargin 15
#define kMarginTopBottom 12

@interface YCTTextView ()

@property (strong, nonatomic, readwrite) IQTextView *textView;

@end

@implementation YCTTextView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViews];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    self.margin = kMargin;
    self.marginTop = kMarginTopBottom;
    
    self.backgroundColor = UIColor.tableBackgroundColor;
    self.layer.cornerRadius = 6;
    
    self.textView = ({
        IQTextView *view = [[IQTextView alloc] init];
        view.textColor = UIColor.mainTextColor;
        view.placeholderTextColor = UIColor.mainGrayTextColor;
        view.font = [UIFont PingFangSCMedium:15];
        view.backgroundColor = UIColor.clearColor;
        view.textContainerInset = UIEdgeInsetsZero;
        view.textContainer.lineFragmentPadding = 0;
        view;
    });
    [self addSubview:self.textView];
    
    self.countLimitLabel = ({
        UILabel *view = [[UILabel alloc] init];
        view.textAlignment = NSTextAlignmentRight;
        view.textColor = UIColor.mainGrayTextColor;
        view.font = [UIFont PingFangSCMedium:12];
        view;
    });
    [self addSubview:self.countLimitLabel];
    
    
    @weakify(self);
    
    RAC(self.textView, text) = [[[RACObserve(self, limitLength) distinctUntilChanged] map:^id _Nullable(NSNumber *  _Nullable value) {
        @strongify(self);
        NSUInteger limitLength = value.unsignedIntegerValue;
        return [self.textView.rac_inputTextSignal map:^id _Nullable(NSString * _Nullable value) {
            return limitLength == 0 ? value : [NSString handledText:value limitCharLength:limitLength];
        }];
    }] switchToLatest];
    
    RAC(self.countLimitLabel, text) = [[[RACObserve(self, limitLength) distinctUntilChanged] map:^id _Nullable(NSNumber *  _Nullable value) {
        @strongify(self);
        NSUInteger limitLength = value.unsignedIntegerValue;
        if (limitLength == 0) {
            return [RACSignal return:@""];
        } else {
            return [[RACObserve(self.textView, text) distinctUntilChanged] map:^id _Nullable(NSString * _Nullable value) {
                return [NSString stringWithFormat:@"%@/%@", @([value characterLength]), @(limitLength)];
            }];
        }
    }] switchToLatest];
//
//
//    [[RACSignal combineLatest:@[self.textView.rac_textSignal, [RACObserve(self, limitLength) distinctUntilChanged]]] map:^id _Nullable(RACTuple * _Nullable value) {
//        @strongify(self);
//
//        NSNumber *limitLength = value.second;
//
//        if (limitLength.unsignedIntegerValue == 0) {
//            return @"";
//        }
//
//        UITextPosition *position = [self.textView positionFromPosition:self.textView.markedTextRange.start offset:0];
//        if (!position) {
//            @weakify(self);
//            [self.textView executeValueChangedTransactionKeepingCursorPosition:^{
//                @strongify(self);
//                [NSString handleText:self.textView.text limitCharLength:limitLength.unsignedIntegerValue completion:^(BOOL isBeyondLength, NSString * _Nullable result) {
//                    if (isBeyondLength) {
//                        self.textView.text = result;
//                    }
//                }];
//            }];
//        }
//        return [NSString stringWithFormat:@"%@/%@", @([self.textView.text characterLength]), @(limitLength.unsignedIntegerValue)];
//    }];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
#define kLabelWidth 100
#define kLabelHeight 22
    
    self.textView.frame = (CGRect){
        self.margin,
        self.marginTop,
        self.bounds.size.width - self.margin - self.margin,
        self.bounds.size.height - self.marginTop - (self.limitLength == 0 ? kMarginTopBottom : kLabelHeight + kMarginTopBottom),
    };
    
    self.countLimitLabel.frame = (CGRect){
        self.bounds.size.width - kLabelWidth - self.margin,
        CGRectGetMaxY(self.textView.frame),
        (self.limitLength != 0 ? kLabelWidth : 0),
        (self.limitLength != 0 ? kLabelHeight : 0),
    };
}

- (void)setLimitLength:(NSUInteger)limitLength {
    if (_limitLength != limitLength) {
        _limitLength = limitLength;
        [self layoutIfNeeded];
    }
}

- (void)setMargin:(CGFloat)margin {
    if (_margin != margin) {
        _margin = margin;
        [self layoutIfNeeded];
    }
}

- (void)setMarginTop:(CGFloat)marginTop {
    if (_marginTop != marginTop) {
        _marginTop = marginTop;
        [self layoutIfNeeded];
    }
}

@end
