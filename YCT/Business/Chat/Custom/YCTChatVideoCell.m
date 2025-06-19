//
//  YCTChatVideoCell.m
//  YCT
//
//  Created by 木木木 on 2022/1/8.
//

#import "YCTChatVideoCell.h"
#import "TUIDefine.h"

#define kVideoMessageCell_Play_Size CGSizeMake(35, 35)

@interface YCTChatVideoCell ()
@property (nonatomic, strong) UIImageView *thumb;
@property (nonatomic, strong) UIImageView *play;
@end

@implementation YCTChatVideoCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.thumb = [[UIImageView alloc] init];
        self.thumb.layer.cornerRadius = 5.0;
        [self.thumb.layer setMasksToBounds:YES];
        self.thumb.contentMode = UIViewContentModeScaleAspectFill;
        self.thumb.backgroundColor = [UIColor whiteColor];
        [self.container addSubview:self.thumb];
        self.thumb.mm_fill();
        self.thumb.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

        self.play = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kVideoMessageCell_Play_Size.width, kVideoMessageCell_Play_Size.height)];
        self.play.contentMode = UIViewContentModeScaleAspectFit;
        self.play.image = [UIImage imageNamed:@"chat_play"];
        [self.container addSubview:self.play];
    }
    return self;
}

- (void)fillWithData:(YCTChatVideoCellData *)data {
    [super fillWithData:data];
    self.customData = data;
    [self.thumb loadImageGraduallyWithURL:[NSURL URLWithString:data.thumbUrl]];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.play.mm_width(kVideoMessageCell_Play_Size.width).mm_height(kVideoMessageCell_Play_Size.height).mm_center();
}

@end
