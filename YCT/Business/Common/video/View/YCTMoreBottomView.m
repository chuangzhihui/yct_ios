//
//  YCTMoreBottomView.m
//  YCT
//
//  Created by hua-cloud on 2022/1/10.
//

#import "YCTMoreBottomView.h"
#import "YCTVerticalButton.h"

#define kButtonWidth 50
#define kButtonHeight 70
@interface YCTMoreBottomView ()

@property (assign, nonatomic) BOOL isCollection;
@property (strong, nonatomic) YCTVerticalButton *delete;
@property (strong, nonatomic) YCTVerticalButton *collection;
@property (strong, nonatomic) YCTVerticalButton *save;
@end

@implementation YCTMoreBottomView
- (instancetype)initWithIsColletion:(BOOL)isColletion{
    self = [super init];
    if (self) {
        self.isCollection = isColletion;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    @weakify(self);
    self.delete = [self buttonWithTitle:@"share.delete" imageName:@"share_delete"];;
    [self addSubview:self.delete];
    [[self.delete rac_signalForControlEvents:(UIControlEventTouchUpInside)] subscribeNext:^(id x) {
        @strongify(self);
        [self buttonClickAtIndex:0];
    }];
    
    self.collection = self.isCollection ? [self buttonWithTitle:@"share.collected" imageName:@"share_collected"] : [self buttonWithTitle:@"share.collect" imageName:@"share_collect"];
    [self addSubview:self.collection];
    [[self.collection rac_signalForControlEvents:(UIControlEventTouchUpInside)] subscribeNext:^(id x) {
        @strongify(self);
        [self buttonClickAtIndex:1];
    }];
    
    self.save = [self buttonWithTitle:@"share.save" imageName:@"share_download"];
    [self addSubview:self.save];
    [[self.save rac_signalForControlEvents:(UIControlEventTouchUpInside)] subscribeNext:^(id x) {
        @strongify(self);
        [self buttonClickAtIndex:2];
    }];
    
    CGFloat top = 39;
    
    CGFloat margin = ceil((Iphone_Width - kButtonWidth * 3 - 8 * 2) / 4.0) + 8;
    self.delete.frame = CGRectMake(margin, top, kButtonWidth, kButtonHeight);
    self.collection.frame = CGRectMake(CGRectGetMaxX(self.delete.frame) + margin - 8, top, kButtonWidth, kButtonHeight);
    self.save.frame = CGRectMake(CGRectGetMaxX(self.collection.frame) + margin - 8, top, kButtonWidth, kButtonHeight);
    
    self.bounds = (CGRect){0, 0, Iphone_Width, 150};
}

- (void)buttonClickAtIndex:(int)index {
    [self yct_closeWithCompletion:^{
        if (self.clickBlock) {
            self.clickBlock(index);
        }
    }];
}

#pragma mark - Getter
- (YCTVerticalButton *)buttonWithTitle:(NSString *)title imageName:(NSString *)imageName {
    YCTVerticalButton *view = [YCTVerticalButton buttonWithType:(UIButtonTypeSystem)];
    view.titleLabel.font = [UIFont PingFangSCMedium:12];
    [view setTitleColor:UIColor.mainTextColor forState:(UIControlStateNormal)];
    [view configTitle:YCTLocalizedString(title) imageName:imageName];
    view.spacing = 10;
    return view;
}


@end
