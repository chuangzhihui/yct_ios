//
//  YCTPostCreationView.m
//  YCT
//
//  Created by 木木木 on 2021/12/14.
//

#import "YCTPostCreationView.h"
#import "YCTVerticalButton.h"

@interface YCTPostCreationView ()

@property (strong, nonatomic) YCTVerticalButton *supplyButton;
@property (strong, nonatomic) YCTVerticalButton *demandButton;

@end

@implementation YCTPostCreationView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViews];
    }
    return self;
}

- (void)dealloc {
    NSLog(@"%s", __FUNCTION__);
}

- (void)setupViews {
    @weakify(self);
    self.supplyButton = ({
        YCTVerticalButton *view = [YCTVerticalButton buttonWithType:(UIButtonTypeSystem)];
        view.titleLabel.font = [UIFont PingFangSCMedium:12];
        view.spacing = 12;
        [view configTitle:YCTLocalizedTableString(@"post.addSupply", @"Post") imageName:@"post_add_supply"];
        [view setTitleColor:UIColor.mainTextColor forState:(UIControlStateNormal)];
        view;
    });
    [self addSubview:self.supplyButton];
    [[self.supplyButton rac_signalForControlEvents:(UIControlEventTouchUpInside)] subscribeNext:^(id x) {
        @strongify(self);
        [self buttonClickAtIndex:1];
    }];
    
    self.demandButton = ({
        YCTVerticalButton *view = [YCTVerticalButton buttonWithType:(UIButtonTypeSystem)];
        view.titleLabel.font = [UIFont PingFangSCMedium:12];
        view.spacing = 12;
        [view configTitle:YCTLocalizedTableString(@"post.addDemand", @"Post") imageName:@"post_add_demand"];
        [view setTitleColor:UIColor.mainTextColor forState:(UIControlStateNormal)];
        view;
    });
    [self addSubview:self.demandButton];
    [[self.demandButton rac_signalForControlEvents:(UIControlEventTouchUpInside)] subscribeNext:^(id x) {
        @strongify(self);
        [self buttonClickAtIndex:2];
    }];
    
    CGFloat margin = ceil((Iphone_Width - 60 * 2 - 30) / 3.0);
    self.supplyButton.frame = CGRectMake(margin, 34, 120, 90);
    self.demandButton.frame = CGRectMake(margin + 60 + margin + 30, 34, 120, 90);
    
    self.bounds = (CGRect){0, 0, Iphone_Width, 150};
}

- (void)buttonClickAtIndex:(int)index {
    [self yct_closeWithCompletion:^{
        if (self.clickBlock) {
            self.clickBlock(index);
        }
    }];
}

@end
