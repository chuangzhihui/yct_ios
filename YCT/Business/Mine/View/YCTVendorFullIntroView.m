//
//  YCTVendorFullIntroView.m
//  YCT
//
//  Created by 木木木 on 2022/3/3.
//

#import "YCTVendorFullIntroView.h"

@interface YCTVendorFullIntroView ()

@property (nonatomic, copy) NSString *text;

@end

@implementation YCTVendorFullIntroView

- (instancetype)initWithText:(NSString *)text {
    if (self = [super init]) {
        self.text = text;
        [self setup];
    }
    return self;
}

- (void)setup {
    YYTextView *textView = [[YYTextView alloc] initWithFrame:(CGRect){0, 0, Iphone_Width, 100}];
    textView.textContainerInset = UIEdgeInsetsMake(25, 25, 36, 25);
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 5;
    textView.attributedText = [[NSAttributedString alloc] initWithString:self.text attributes:@{
        NSFontAttributeName:[UIFont PingFangSCMedium:15],
        NSParagraphStyleAttributeName: ({
            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
            paragraphStyle.lineSpacing = 5;
            paragraphStyle;
        }),
        NSForegroundColorAttributeName: UIColor.mainTextColor
    }];
    [self addSubview:textView];
    
    CGFloat maxHeight = Iphone_Height * 0.6 - 120;
    
    if (textView.contentSize.height > maxHeight) {
        self.frame =  CGRectMake(0, 0, Iphone_Width, maxHeight);
    } else {
        self.frame =  CGRectMake(0, 0, Iphone_Width, textView.contentSize.height);
    }
    textView.frame = self.frame;
}

@end
