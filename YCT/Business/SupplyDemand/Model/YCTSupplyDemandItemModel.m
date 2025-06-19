//
//  YCTSupplyDemandItemModel.m
//  YCT
//
//  Created by 木木木 on 2022/1/14.
//

#import "YCTSupplyDemandItemModel.h"
#import "NSMutableAttributedString+TagList.h"

@implementation YCTSupplyDemandItemModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
        @"isFollow" : @[@"isFllow", @"isFloow"],
        @"itemId" : @"id",
    };
}

- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic {
    self.tagTexts = YCTArray(self.tagTexts, @[]);
    
    NSString *time = @"";
    if (self.atime > 0) {
        NSInteger days = [[NSDate date] apartDaysWithDate:[NSDate dateWithTimeIntervalSince1970:self.atime]];
        if (days == 0) {
            time = [NSDate dateToStringWithTimeInterval:self.atime formate:@"HH:mm"];
            time = [NSString stringWithFormat:@"%@%@", time, YCTLocalizedTableString(@"post.time.suffix", @"Post")];
        } else if (days == 1) {
            time = YCTLocalizedTableString(@"post.time.yesterday", @"Post");
        } else {
            time = [NSDate dateToStringWithTimeInterval:self.atime formate:@"MM-dd"];
            time = [NSString stringWithFormat:@"%@%@", time, YCTLocalizedTableString(@"post.time.suffix", @"Post")];
        }
    }
    
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
