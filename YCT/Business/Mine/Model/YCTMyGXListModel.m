//
//  YCTMyGXListModel.m
//  YCT
//
//  Created by 木木木 on 2021/12/31.
//

#import "YCTMyGXListModel.h"
#import "NSMutableAttributedString+TagList.h"
#import "UIImage+Common.h"

static UIImage * displayImage = nil;
static UIImage * auditingImage = nil;
static UIImage * failedImage = nil;
static UIImage * removedImage = nil;

@implementation YCTMyGXListModel

+ (UIImage *)statusBgImage:(YCTMyGXListType)type {
    switch (type) {
        case YCTMyGXListTypeDisplay: {
            static dispatch_once_t onceToken;
            dispatch_once(&onceToken, ^{
                displayImage = [UIImage RoundedCornerImageWithRadius_TL:12 radius_TR:12 radius_BL:12 radius_BR:0 rectSize:(CGSize){70, 24} fillColor:UIColorFromRGB(0x01CE6E)];
            });
            return displayImage;
        }
            
        case YCTMyGXListTypeAuditing: {
            static dispatch_once_t onceToken;
            dispatch_once(&onceToken, ^{
                auditingImage = [UIImage RoundedCornerImageWithRadius_TL:12 radius_TR:12 radius_BL:12 radius_BR:0 rectSize:(CGSize){70, 24} fillColor:UIColorFromRGB(0xFF7510)];
            });
            return auditingImage;
        }
            
        case YCTMyGXListTypeAuditFailed: {
            static dispatch_once_t onceToken;
            dispatch_once(&onceToken, ^{
                failedImage = [UIImage RoundedCornerImageWithRadius_TL:12 radius_TR:12 radius_BL:12 radius_BR:0 rectSize:(CGSize){70, 24} fillColor:UIColorFromRGB(0xFE2B54)];
            });
            return failedImage;
        }
            
        case YCTMyGXListTypeRemoved: {
            static dispatch_once_t onceToken;
            dispatch_once(&onceToken, ^{
                removedImage = [UIImage RoundedCornerImageWithRadius_TL:12 radius_TR:12 radius_BL:12 radius_BR:0 rectSize:(CGSize){70, 24} fillColor:UIColorFromRGB(0xEFEFEF)];
            });
            return removedImage;
        }
    }
}

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"identifier" : @"id"};
}

- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic {
    self.tagTexts = YCTArray(self.tagTexts, @[]);
    
    NSString *time = [NSDate dateToStringWithTimeInterval:self.atime formate:@"yyyy-MM-dd HH:mm:ss"];
    NSString *type;
    if (self.type == YCTPostTypeSupply) {
        type = YCTLocalizedTableString(@"post.supply", @"Post");
    } else {
        type = YCTLocalizedTableString(@"post.demand", @"Post");
    }
    NSString *releaseText = [NSString stringWithFormat:@"%@ · %@", time, type];
    NSMutableAttributedString *releaseString = [[NSMutableAttributedString alloc] initWithString:releaseText];
    [releaseString setAttributes:@{
        NSFontAttributeName: [UIFont PingFangSCMedium:14],
        NSForegroundColorAttributeName: UIColor.subTextColor
    } range:(NSRange){0, releaseText.length}];
    [releaseString setAttributes:@{
        NSFontAttributeName: [UIFont PingFangSCMedium:14],
        NSForegroundColorAttributeName: UIColor.mainThemeColor
    } range:(NSRange){releaseText.length - type.length, type.length}];
    self.releaseText = releaseString.copy;
    
    switch (self.status) {
        case YCTMyGXListTypeDisplay:
            self.statusText = YCTLocalizedTableString(@"mine.post.display", @"Mine");
            break;
        case YCTMyGXListTypeAuditing:
            self.statusText = YCTLocalizedTableString(@"mine.post.audit", @"Mine");
            break;
        case YCTMyGXListTypeAuditFailed:
            self.statusText = YCTLocalizedTableString(@"mine.post.failed", @"Mine");
            break;
        case YCTMyGXListTypeRemoved:
            self.statusText = YCTLocalizedTableString(@"mine.post.removed", @"Mine");
            break;
    }
    
    if (self.tagTexts.count > 0) {
        NSMutableAttributedString *text = [NSMutableAttributedString new];
        text.append(self.tagTexts, ^(YCTTagListStyleMaker *make) {
            make.textColor = UIColor.mainTextColor;
            make.font = [UIFont PingFangSCBold:12];
            make.fillColor = UIColorFromRGB(0xf8f8f8);
            make.cornerRadius = 100;
            make.insets = UIEdgeInsetsMake(-5, -7, -5, -7);
            make.maxWidth = Iphone_Width - 30;
            make.margin = 10;
            make.lineSpace = 10;
        });
        text.yy_minimumLineHeight = 25;

        YYTextContainer *tagContainer = [YYTextContainer containerWithSize:CGSizeMake(Iphone_Width - 30, 999)];
        YYTextLayout *textLayout = [YYTextLayout layoutWithContainer:tagContainer text:text];
        self.tagsLayout = textLayout;
    }
    
    return YES;
}

@end
