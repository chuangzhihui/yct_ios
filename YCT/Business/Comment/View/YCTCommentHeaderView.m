//
//  YCTCommentHeaderView.m
//  YCT
//
//  Created by hua-cloud on 2021/12/19.
//

#import "YCTCommentHeaderView.h"
#import "UIDevice+Common.h"
@interface YCTCommentHeaderView ()<UIGestureRecognizerDelegate>
@property (nonatomic, strong) UITapGestureRecognizer * tap1;
@property (nonatomic, strong) UITapGestureRecognizer * tap;

@end

@implementation YCTCommentHeaderView

+ (CGFloat)heightWithContentText:(NSString *)contentText{
    UILabel * content = [UILabel new];
    content.font = [UIFont systemFontOfSize:15 weight:UIFontWeightMedium];
    content.textColor = UIColorFromRGB(0x2C2C2C);
    content.numberOfLines = 0;
    content.text = contentText;
    content.frame = CGRectMake(0, 0, Iphone_Width - 58 - 55, 0);
    content.preferredMaxLayoutWidth = Iphone_Width - 58 - 55;
    [content sizeToFit];
    return 15 + 18 + 14 + 20 + content.bounds.size.height;
}

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        [self setupView];
    }
    return self;
}

- (void)setupView{
    self.contentView.backgroundColor = UIColor.whiteColor;
    
    UIStackView * nickNameStack = [[UIStackView alloc] initWithFrame:CGRectZero];
    nickNameStack.distribution = UIStackViewDistributionFill;
    nickNameStack.alignment = UIStackViewAlignmentCenter;
    nickNameStack.axis = UILayoutConstraintAxisHorizontal;
    nickNameStack.spacing = 6;
    
    UIStackView * timeStack = [[UIStackView alloc] initWithFrame:CGRectZero];
    timeStack.distribution = UIStackViewDistributionFill;
    timeStack.alignment = UIStackViewAlignmentCenter;
    timeStack.axis = UILayoutConstraintAxisHorizontal;
    timeStack.spacing = 16;
    
    UIStackView * mainStack = [[UIStackView alloc] initWithFrame:CGRectZero];
    mainStack.distribution = UIStackViewDistributionFill;
    mainStack.alignment = UIStackViewAlignmentLeading;
    mainStack.axis = UILayoutConstraintAxisVertical;
    mainStack.spacing = 9;
    
    UIStackView * likeStack = [[UIStackView alloc] initWithFrame:CGRectZero];
    likeStack.distribution = UIStackViewDistributionFill;
    likeStack.alignment = UIStackViewAlignmentCenter;
    likeStack.axis = UILayoutConstraintAxisVertical;
    likeStack.spacing = 4;
    
    [likeStack addArrangedSubview:self.likeButton];
    [likeStack addArrangedSubview:self.likeCount];
    [nickNameStack addArrangedSubview:self.nickName];
    [nickNameStack addArrangedSubview:self.markTag];
    [timeStack addArrangedSubview:self.timeLabel];
    [timeStack addArrangedSubview:self.reply];
    [mainStack addArrangedSubview:nickNameStack];
    [mainStack addArrangedSubview:self.content];
    [mainStack addArrangedSubview:timeStack];
    [self.contentView addSubview:self.avatar];
    [self.contentView addSubview:mainStack];
    [self.contentView addSubview:likeStack];
    [self.contentView addSubview:self.isZaning];
    
    [self.avatar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.f);
        make.size.mas_equalTo(CGSizeMake(35, 35));
        make.top.mas_equalTo(10);
    }];
    
    [self.markTag mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(40, 14));
    }];
    
    [mainStack mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.avatar.mas_right).offset(8.f);
        make.top.mas_equalTo(10);
        make.right.mas_equalTo(-55);
        make.bottom.mas_offset(-5);
    }];
    
    [likeStack mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_offset(0);
        make.width.mas_offset(55);
        make.top.mas_offset(10);
    }];
    
    [self.isZaning mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(likeStack);
    }];
    
    UILongPressGestureRecognizer * ges = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longGes:)];
    ges.minimumPressDuration = 0.5;
    ges.delaysTouchesBegan = YES;
    [self.contentView addGestureRecognizer:ges];
    
    @weakify(self);
    self.tap1 = [[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
        @strongify(self);
        !self.avatarTapGesHandler ? : self.avatarTapGesHandler();
    }];
    self.tap1.delegate = self;
    [self.avatar addGestureRecognizer:self.tap1];
    self.avatar.userInteractionEnabled = YES;
    
    self.tap = [[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
        @strongify(self);
        !self.tapGesHandler ? : self.tapGesHandler();
    }];
    self.likeContainer = likeStack;
    self.tap.delegate = self;
    [self.contentView addGestureRecognizer:self.tap];
}

- (void)longGes:(UILongPressGestureRecognizer *)ges{
    if (ges.state == UIGestureRecognizerStateBegan) {
        [UIDevice launchImpactFeedback];
        !self.longGesHandler ? : self.longGesHandler();
    }
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer*)gestureRecognizer shouldReceiveTouch:(UITouch*)touch {
    CGPoint point = [touch locationInView:self.avatar];
    BOOL result = [self.avatar.layer containsPoint:point];
    if (result) {
        if([gestureRecognizer isEqual:self.tap]){
            return NO;
        }
    }
    return YES;
}

#pragma mark - getter
- (UIImageView *)avatar{
    if (!_avatar) {
        _avatar = [UIImageView new];
        _avatar.layer.cornerRadius = 17.5;
        _avatar.layer.masksToBounds = YES;
    }
    return _avatar;
}

- (UILabel *)nickName{
    if (!_nickName) {
        _nickName = [UILabel new];
        _nickName.font = [UIFont systemFontOfSize:14 weight:UIFontWeightBold];
        _nickName.textColor = UIColorFromRGB(0x666666);
        _nickName.text = @"用户昵称用户昵称";
    }
    return _nickName;
}

- (UILabel *)markTag{
    if (!_markTag) {
        _markTag = [UILabel new];
        _markTag.font = [UIFont systemFontOfSize:10 weight:UIFontWeightMedium];
        _markTag.textColor = UIColor.whiteColor;
        _markTag.textAlignment = NSTextAlignmentCenter;
        _markTag.layer.cornerRadius = 7;
        _markTag.layer.masksToBounds = YES;
        _markTag.backgroundColor = UIColorFromRGB(0xFE2B54);
        _markTag.text = YCTLocalizedTableString(@"comment.author", @"Home");
    }
    return _markTag;
}

- (UILabel *)content{
    if (!_content) {
        _content = [UILabel new];
        _content.font = [UIFont systemFontOfSize:15 weight:UIFontWeightMedium];
        _content.textColor = UIColorFromRGB(0x2C2C2C);
        _content.numberOfLines = 0;
        _content.text = @"关键那位姐姐，期间分明瞧见了墙头那边的胖子，她却仍是妩媚而笑，一挑眉头。";
    }
    return _content;
}


- (UILabel *)timeLabel{
    if (!_timeLabel) {
        _timeLabel = [UILabel new];
        _timeLabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightMedium];
        _timeLabel.textColor = UIColorFromRGB(0xC1C1C1);
    }
    return _timeLabel;
}

- (UIButton *)reply{
    if (!_reply) {
        _reply = [UIButton buttonWithType:UIButtonTypeSystem];
        [_reply setTitle:YCTLocalizedTableString(@"comment.reply", @"Home") forState:UIControlStateNormal];
        [_reply setTitleColor:UIColorFromRGB(0x999999) forState:UIControlStateNormal];
        [_reply setTintColor:UIColorFromRGB(0x999999)];
        _reply.titleLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
    }
    return _reply;
}


- (UIButton *)likeButton{
    if (!_likeButton) {
        _likeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_likeButton setImage:[UIImage imageNamed:@"comment_unlike"] forState:UIControlStateNormal];
        [_likeButton setImage:[UIImage imageNamed:@"comment_like"] forState:UIControlStateSelected];
    }
    return _likeButton;
}

- (UILabel *)likeCount{
    if (!_likeCount) {
        _likeCount = [UILabel new];
        _likeCount.font = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
        _likeCount.textColor = UIColorFromRGB(0x666666);
        _likeCount.text = @"2.2w";
    }
    return _likeCount;
}

- (UIActivityIndicatorView *)isZaning{
    if (!_isZaning) {
        _isZaning = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    }
    return _isZaning;
}
@end
