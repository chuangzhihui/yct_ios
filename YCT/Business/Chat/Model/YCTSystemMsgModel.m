//
//  YCTSystemMsgModel.m
//  YCT
//
//  Created by 木木木 on 2021/12/29.
//

#import "YCTSystemMsgModel.h"

#define bubbleInsets UIEdgeInsetsMake(0, 15, 15, 15)
#define contentInsets UIEdgeInsetsMake(14, 20, 24, 20)
#define titleTimeSpacing 8
#define timeContentSpacing 24

@implementation YCTSystemMsgContentModel
@end

@implementation YCTSystemMsgModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"content" : [YCTSystemMsgContentModel class]
    };
}

+ (nullable NSArray<NSString *> *)modelPropertyBlacklist {
    return @[
        @"contents",
        @"timeStr",
        @"bubbleFrame",
        @"titleFrame",
        @"timeFrame",
        @"contentFrame",
        @"height",
    ];
}

- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic {
    NSMutableString *contents = [NSMutableString string];
    NSArray<YCTSystemMsgContentModel *> *contentModels = self.content;
    if (YCT_IS_ARRAY(contentModels)) {
        [contentModels enumerateObjectsUsingBlock:^(YCTSystemMsgContentModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (obj.title && obj.content) {
                [contents appendString:obj.title];
                [contents appendString:@"："];
                [contents appendString:obj.content];
                if (idx < contentModels.count - 1) {
                    [contents appendString:@"\n"];
                }
            }
        }];
    }
    self.contents = contents.copy;
    
    self.timeStr = [NSDate dateToStringWithTimeInterval:self.atime formate:@"yyyy-MM-dd HH:mm:ss"];
    
    [self calculateHeight];
    return YES;
}

- (void)calculateHeight {
    CGFloat height = 0;
    height += bubbleInsets.top + contentInsets.top;
    if (self.title.length > 0) {
        CGRect rect = [self.title boundingRectWithSize:(CGSize){
            Iphone_Width - bubbleInsets.left - bubbleInsets.right - contentInsets.left - contentInsets.right,
            MAXFLOAT
        } options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{
            NSFontAttributeName : [UIFont PingFangSCBold:17]
        } context:nil];
        CGSize size = CGSizeMake(ceil(rect.size.width), ceil(rect.size.height));
        self.titleFrame = (CGRect){
            contentInsets.left,
            contentInsets.top,
            size
        };
        height += size.height + titleTimeSpacing;
    } else {
        self.titleFrame = CGRectZero;
    }
    
    if (self.timeStr.length > 0) {
        CGRect rect = [self.timeStr boundingRectWithSize:(CGSize){
            Iphone_Width - bubbleInsets.left - bubbleInsets.right - contentInsets.left - contentInsets.right,
            MAXFLOAT
        } options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{
            NSFontAttributeName : [UIFont PingFangSCMedium:12]
        } context:nil];
        CGSize size = CGSizeMake(ceil(rect.size.width), ceil(rect.size.height));
        self.timeFrame = (CGRect){
            contentInsets.left,
            height,
            size
        };
        height += size.height + timeContentSpacing;
    } else {
        self.timeFrame = CGRectZero;
        height -= titleTimeSpacing;
    }
    
    if (self.contents.length > 0) {
        NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
        paragraphStyle.lineSpacing = 8;
        NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
        [attributes setObject:paragraphStyle forKey:NSParagraphStyleAttributeName];
        [attributes setObject:[UIFont PingFangSCMedium:14] forKey:NSFontAttributeName];
        [attributes setObject:UIColor.mainTextColor forKey:NSForegroundColorAttributeName];
        
        self.contentString = [[NSAttributedString alloc] initWithString:self.contents attributes:attributes];
        CGRect rect = [self.contentString boundingRectWithSize:(CGSize){
            Iphone_Width - bubbleInsets.left - bubbleInsets.right - contentInsets.left - contentInsets.right,
            MAXFLOAT
        } options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil];
        CGSize size = CGSizeMake(ceil(rect.size.width), ceil(rect.size.height));
        self.contentFrame = (CGRect){
            contentInsets.left,
            height,
            size
        };
        height += size.height;
    } else {
        self.contentFrame = CGRectZero;
        height -= timeContentSpacing;
    }
    
    height += bubbleInsets.bottom + contentInsets.bottom;
    self.height = height;
    
    self.bubbleFrame = (CGRect){
        bubbleInsets.left,
        bubbleInsets.top,
        Iphone_Width - bubbleInsets.left - bubbleInsets.right,
        height - bubbleInsets.bottom
    };
}

@end
