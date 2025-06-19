//
//  BGMTopShowView.m
//  UGCKit
//
//  Created by 林涛 on 2025/3/29.
//  Copyright © 2025 Tencent. All rights reserved.
//

#import "BGMTopShowView.h"

@interface BGMTopShowView ()
@property (weak, nonatomic) IBOutlet UIView *addBgVw;
@property (weak, nonatomic) IBOutlet UIView *addLb;
@property (weak, nonatomic) IBOutlet UIButton *addBtn;

@property (weak, nonatomic) IBOutlet UIView *useBgVw;
@property (weak, nonatomic) IBOutlet UIView *useLb;
@property (weak, nonatomic) IBOutlet UIButton *useBtn;
@property (weak, nonatomic) IBOutlet UIButton *useCloseBtn;
@end

@implementation BGMTopShowView

//- (void)awakeFromNib {
//    [super awakeFromNib];
//}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setUI];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setUI];
    }
    return self;
}

+ (instancetype)loadFromNib {
    UINib *nib = [UINib nibWithNibName:NSStringFromClass([self class]) bundle:[NSBundle mainBundle]];
    return [[nib instantiateWithOwner:self options:nil] firstObject];
}

#pragma mark ------ UI ------
- (void)setUI {
//    [self addSubview:self.bgVw];
//    [self.bgVw addSubview:self.typeImg];
    // 加载 XIB
    UINib *nib = [UINib nibWithNibName:NSStringFromClass([self class]) bundle:[NSBundle mainBundle]];
    NSLog(@"All resources: %@", [[NSBundle mainBundle] pathsForResourcesOfType:@"nib" inDirectory:nil]);
    NSLog(@"Main bundle: %@", [NSBundle mainBundle]);
    NSArray *views = [nib instantiateWithOwner:self options:nil];
    UIView *view = [views firstObject];
    [self addSubview:view];
}

#pragma mark ------ Data ------

#pragma mark ------ method ------

#pragma mark ------ Getters And Setters ------
//- (UIImageView *)typeImg {
//    if (!_typeImg) {
//        UIImageView * view = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@""]];
//        view.contentMode = UIViewContentModeScaleAspectFill;
//        view.layer.cornerRadius = 4;
//        view.layer.masksToBounds = true;
//        view.backgroundColor = UIColor.whiteColor;
//        _typeImg = view;
//    }
//    return _typeImg;
//}

@end
