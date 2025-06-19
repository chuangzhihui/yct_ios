//
//  YCTSearchUserCell.m
//  YCT
//
//  Created by hua-cloud on 2021/12/23.
//

#import "YCTSearchUserCell.h"
#import "NSString+Common.h"
#import "YCTUserFollowHelper.h"

@interface YCTSearchUserCell ()
@property (nonatomic, strong) YCTSearchUserModel * model;
@end

@implementation YCTSearchUserCell
+ (NSString *)cellReuseIdentifier{
    return NSStringFromClass([self class]);
}

+ (CGSize)cellSize{
    return CGSizeMake(Iphone_Width, 50);
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.focusButton.layer.cornerRadius = 14.5;
    self.avatar.layer.cornerRadius = 25;
    self.avatar.layer.masksToBounds = YES;
    [self.focusButton setTitle:YCTLocalizedTableString(@"others.follow", @"Mine") forState:UIControlStateNormal];
    [self.focusButton setTitle:YCTLocalizedTableString(@"others.followed", @"Mine") forState:UIControlStateSelected];
  
    RAC(self.focusButton, backgroundColor) = [RACObserve(self.focusButton, selected) map:^id _Nullable(id  _Nullable value) {
        return [value boolValue] ?  UIColor.placeholderColor : UIColor.mainThemeColor;
    }];
    
    @weakify(self);
    [[self.focusButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        [[YCTUserFollowHelper sharedInstance] handleFollowStateWithUser:self.model];
    }];
}

- (void)prepareForShowWithModel:(YCTSearchUserModel *)model{
    self.model = model;
    [self.avatar loadImageGraduallyWithURL:[NSURL URLWithString:model.avatar] placeholderImageName:kDefaultAvatarImageName];
    self.userName.text = model.nickName;
    self.fans.text = [NSString stringWithFormat:@"%@:%@",YCTLocalizedTableString(@"mine.fansCount", @"Mine"),[NSString handledCountNumberIfMoreThanTenThousand:[model.fansNum integerValue]]];
    RAC(self.focusButton, selected) = [RACObserve(model, isFollow) takeUntil:self.rac_prepareForReuseSignal];
    
}
@end
