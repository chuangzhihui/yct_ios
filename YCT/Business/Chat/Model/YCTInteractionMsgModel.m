//
//  YCTInteractionMsgModel.m
//  YCT
//
//  Created by 木木木 on 2021/12/29.
//

#import "YCTInteractionMsgModel.h"

#define kTopMargin 20
#define kMargin 15
#define kTextVerticalSpacing 10

@implementation YCTInteractionMsgModel

+ (nullable NSArray<NSString *> *)modelPropertyBlacklist {
    return @[
        @"timeStr",
        @"identityStr",
        @"thumbFrame",
        @"avatarFrame",
        @"nameFrame",
        @"vipFrame",
        @"identityFrame",
        @"contentFrame",
        @"timeFrame",
        @"height",
    ];
}

- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic {
    self.timeStr = [NSDate dateToStringWithTimeInterval:self.atime formate:@"MM-dd"];
    
    if (self.type == 1) {
        self.timeStr = [NSString stringWithFormat:@"%@ · %@", YCTLocalizedTableString(@"chat.interaction.reply", @"Chat"), self.timeStr];
    } else if (self.type == 2) {
        self.timeStr = [NSString stringWithFormat:@"%@ · %@", YCTLocalizedTableString(@"chat.interaction.comment", @"Chat"), self.timeStr];
    }
    
    [self calculateHeight];
    return YES;
}

- (void)calculateHeight {
    CGFloat height = 0;
    height += kTopMargin;
    
    {
        /// 头像
        self.avatarFrame = CGRectMake(kMargin, kTopMargin, 40, 40);
    }
    
    {
        /// 缩略图
        self.thumbFrame = CGRectMake(Iphone_Width - 60 - kMargin, kTopMargin, 60, 60);
    }
    
    CGFloat textMaxLayoutWidth = Iphone_Width - CGRectGetMaxX(self.avatarFrame) - 8 - 8 - 60 - kMargin;
    CGFloat contentMaxLayoutWidth = textMaxLayoutWidth;
    
    {
        CGSize identitySize;
        /// 身份
        if (self.floowStatus == 1 || self.floowStatus == 2) {
            self.identityStr = (self.floowStatus == 1) ? @"你的关注" : @"朋友";
            self.identityStr=@"";
            CGRect rect = [self.identityStr boundingRectWithSize:(CGSize){MAXFLOAT, MAXFLOAT} options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{
                NSFontAttributeName : [UIFont PingFangSCMedium:10]
            } context:nil];
            identitySize = CGSizeMake(ceil(rect.size.width) + 10, 14);
            
            textMaxLayoutWidth -= identitySize.width + 6;
        } else {
            self.identityStr = @"";
            self.identityFrame = CGRectZero;
            identitySize = CGSizeZero;
        }
        
        BOOL isVip = YES;
        if (isVip) {
            textMaxLayoutWidth -= 14 + 5;
        }
        
        /// 昵称
        CGRect rect = [self.nickName ?: @" " boundingRectWithSize:(CGSize){
            textMaxLayoutWidth,
            MAXFLOAT
        } options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{
            NSFontAttributeName : [UIFont PingFangSCMedium:14]
        } context:nil];
            
        CGSize size = CGSizeMake(ceil(rect.size.width), ceil(rect.size.height));
        self.nameFrame = (CGRect){
            CGRectGetMaxX(self.avatarFrame) + 8,
            kTopMargin,
            size
        };
        height += size.height + kTextVerticalSpacing;
        
        if (isVip) {
            CGFloat yOffset = (CGRectGetHeight(self.nameFrame) - 14) / 2;
            self.vipFrame = CGRectMake(CGRectGetMaxX(self.nameFrame) + 5, kTopMargin + yOffset, 14, 14);
        } else {
            self.vipFrame = CGRectZero;
        }
        
        if (!CGSizeEqualToSize(identitySize, CGSizeZero)) {
            CGFloat yOffset = (CGRectGetHeight(self.nameFrame) - identitySize.height) / 2;
            self.identityFrame = (CGRect){
                (isVip ? CGRectGetMaxX(self.vipFrame) : CGRectGetMaxX(self.nameFrame)) + 6,
                kTopMargin + yOffset,
                identitySize
            };
        }
    }
    
    {
        /// 内容
        CGRect rect = [self.msg ?: @"" boundingRectWithSize:(CGSize){contentMaxLayoutWidth, MAXFLOAT} options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{
            NSFontAttributeName : [UIFont PingFangSCMedium:15]
        } context:nil];
        CGSize size = CGSizeMake(ceil(rect.size.width), ceil(rect.size.height));
        self.contentFrame = (CGRect){
            CGRectGetMinX(self.nameFrame),
            height,
            size
        };
        height += size.height + kTextVerticalSpacing;
    }
    
    {
        /// 时间
        CGRect rect = [self.timeStr boundingRectWithSize:(CGSize){contentMaxLayoutWidth, MAXFLOAT} options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{
            NSFontAttributeName : [UIFont PingFangSCMedium:12]
        } context:nil];
        CGSize size = CGSizeMake(ceil(rect.size.width), ceil(rect.size.height));
        self.timeFrame = (CGRect){
            CGRectGetMinX(self.nameFrame),
            height,
            size
        };
        height += size.height + kTextVerticalSpacing;
    }
    
    self.height = height;
}

@end
