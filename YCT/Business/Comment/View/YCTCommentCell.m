//
//  YCTCommentCell.m
//  YCT
//
//  Created by hua-cloud on 2021/12/19.
//

#import "YCTCommentCell.h"
#import "UIDevice+Common.h"
@interface YCTCommentCell ()<UIGestureRecognizerDelegate>
@property (nonatomic, strong) UITapGestureRecognizer * tap1;
@property (nonatomic, strong) UITapGestureRecognizer * tap;
@end

@implementation YCTCommentCell

+ (UINib *)nib {
    return [UINib nibWithNibName:[[self class] cellReuseIdentifier] bundle:[NSBundle mainBundle]];
}

+ (NSString *)cellReuseIdentifier {
    return NSStringFromClass([self class]);
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.avatar.layer.cornerRadius = 10;
    self.avatar.layer.masksToBounds = YES;
    UILongPressGestureRecognizer * ges = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longGes:)];
    ges.minimumPressDuration = 0.5;
    ges.delaysTouchesBegan = YES;
    [self.contentView addGestureRecognizer:ges];
    // Initialization code
    
    self.avatar.userInteractionEnabled=YES;
    @weakify(self);
    self.tap1 = [[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
        @strongify(self);
        !self.avatarTapGesHandler ? : self.avatarTapGesHandler();
    }];
    self.tap1.delegate = self;
    [self.avatar addGestureRecognizer:self.tap1];
    
    self.tap = [[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
        @strongify(self);
        !self.tapGesHandler ? : self.tapGesHandler();
    }];
    self.tap.delegate = self;
    [self.contentView addGestureRecognizer:self.tap];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)longGes:(UITapGestureRecognizer *)ges{
    if (ges.state == UIGestureRecognizerStateBegan) {
        [UIDevice launchImpactFeedback];
        !self.longGesHandler ? : self.longGesHandler();
    }
    
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer*)gestureRecognizer shouldReceiveTouch:(UITouch*)touch {
    if ([touch.view isDescendantOfView:self.avatar]) {
        if([gestureRecognizer isEqual:self.tap]){
            return NO;
        }
    }
    return YES;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
}
@end
