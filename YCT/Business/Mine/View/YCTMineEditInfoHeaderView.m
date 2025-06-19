//
//  YCTMineEditInfoHeaderView.m
//  YCT
//
//  Created by 木木木 on 2021/12/24.
//

#import "YCTMineEditInfoHeaderView.h"

@interface YCTMineEditInfoHeaderView ()

@end

@implementation YCTMineEditInfoHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    self.avatarImageView = ({
        UIImageView *view = [[UIImageView alloc] init];
        view.contentMode = UIViewContentModeScaleAspectFill;
        view.mj_size = CGSizeMake(90, 90);
        view.layer.cornerRadius = 45;
        view.layer.masksToBounds = YES;
        view;
    });
    [self addSubview:self.avatarImageView];
    
    self.changeAvatarButton = ({
        UIButton *view = [UIButton buttonWithType:(UIButtonTypeCustom)];
        view.backgroundColor = [UIColor.blackColor colorWithAlphaComponent:0.6];
        view.layer.cornerRadius = 45;
        view.layer.masksToBounds = YES;
        [view setImage:[UIImage imageNamed:@"mine_photo"] forState:(UIControlStateNormal)];
        view;
    });
    [self addSubview:self.changeAvatarButton];
    
    UILabel *clickLabel = ({
        UILabel *view = [[UILabel alloc] init];
        view.text = YCTLocalizedTableString(@"mine.edit.clickChangeImage", @"Mine");
        view.font = [UIFont PingFangSCBold:15];
        view.textColor = UIColor.mainTextColor;
        view.textAlignment = NSTextAlignmentCenter;
        view.tag = 2;
        view;
    });
    [self addSubview:clickLabel];
    
    self.maleButton = ({
        UIButton *view = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [view setImage:[UIImage imageNamed:@"mine_male_normal"] forState:UIControlStateNormal];
        [view setImage:[UIImage imageNamed:@"mine_male_selected"] forState:UIControlStateSelected];
        
        [view setTitle:YCTLocalizedTableString(@"mine.edit.male", @"Mine") forState:UIControlStateNormal];

        [view setTitleColor:UIColor.mainGrayTextColor forState:UIControlStateNormal];
        [view setTitleColor:UIColor.whiteColor forState:UIControlStateSelected];
        view.titleLabel.font = [UIFont PingFangSCMedium:14];
        
        view.backgroundColor = UIColor.grayButtonBgColor;
        
        view.layer.cornerRadius = 15;
        view.imageEdgeInsets = UIEdgeInsetsMake(0, -4, 0, 0);
        view.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -4);
        view;
    });
    [self addSubview:self.maleButton];
    
    self.femaleButton = ({
        UIButton *view = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [view setImage:[UIImage imageNamed:@"mine_female_normal"] forState:UIControlStateNormal];
        [view setImage:[UIImage imageNamed:@"mine_female_selected"] forState:UIControlStateSelected];
        
        [view setTitle:YCTLocalizedTableString(@"mine.edit.female", @"Mine") forState:UIControlStateNormal];

        [view setTitleColor:UIColor.mainGrayTextColor forState:UIControlStateNormal];
        [view setTitleColor:UIColor.whiteColor forState:UIControlStateSelected];
        view.titleLabel.font = [UIFont PingFangSCMedium:14];
        
        view.backgroundColor = UIColor.grayButtonBgColor;
        
        view.layer.cornerRadius = 15;
        view.imageEdgeInsets = UIEdgeInsetsMake(0, -4, 0, 0);
        view.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -4);
        view;
    });
    [self addSubview:self.femaleButton];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.avatarImageView.center = CGPointMake(self.bounds.size.width / 2, 0);
    self.avatarImageView.mj_y = 30;
    
    self.changeAvatarButton.frame = self.avatarImageView.frame;
    
    UIView *clickLabel = [self viewWithTag:2];
    clickLabel.frame = (CGRect){
        0,
        CGRectGetMaxY(self.avatarImageView.frame),
        self.bounds.size.width,
        39
    };
    
#define kSpacing 32
#define kButtonSize (CGSize){80, 30}
    
    self.maleButton.frame = (CGRect){
        ceil((self.bounds.size.width - kButtonSize.width * 2 - kSpacing) / 2),
        CGRectGetMaxY(clickLabel.frame) + 18,
        kButtonSize
    };
    
    self.femaleButton.frame = (CGRect){
        CGRectGetMaxX(self.maleButton.frame) + kSpacing,
        CGRectGetMinY(self.maleButton.frame),
        kButtonSize
    };
}

- (void)setSex:(int)sex {
    BOOL maleSelect = sex == 1;
    BOOL femaleSelect = sex == 2;
    
    self.maleButton.selected = maleSelect;
    self.femaleButton.selected = femaleSelect;
    
    self.maleButton.backgroundColor = maleSelect ? UIColor.mainThemeColor : UIColor.grayButtonBgColor;
    self.femaleButton.backgroundColor = femaleSelect ? UIColor.mainThemeColor : UIColor.grayButtonBgColor;
}

@end
