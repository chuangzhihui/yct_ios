//
//  NSMutableAttributedString+TagList.m
//  YCT
//
//  Created by 木木木 on 2021/12/10.
//

#import "NSMutableAttributedString+TagList.h"
#import "YYText.h"
#import <objc/runtime.h>

@implementation YCTTagListStyleMaker
@end

@implementation NSMutableAttributedString (TagList)

@dynamic append;

- (YCTTagListAttriStringAppend)append {
    return ^NSMutableAttributedString *(NSArray<NSString *> *tags, void(^make)(YCTTagListStyleMaker *)) {
        if (tags.count == 0) return self;
        
        YCTTagListStyleMaker *styleMaker = [YCTTagListStyleMaker new];
        if (make) make(styleMaker);
                
        CGFloat contentHeight = self.contentHeight;
        
        if (contentHeight == 0) {
            [self appendAttributedString:[NSMutableAttributedString emptyAttributeString:fabs(styleMaker.insets.left) WithStyleMaker:styleMaker]];
        }
        
        self.yy_lineSpacing = styleMaker.lineSpace;
        
        for (NSString *tag in tags) {
            NSMutableAttributedString *tagAttri = [self attributedStringWithStyle:styleMaker string:tag needBorder:YES];
            [self appendAttributedString:tagAttri];
            
            YYTextContainer *container = [YYTextContainer new];
            container.size = CGSizeMake(styleMaker.maxWidth, CGFLOAT_MAX);
            YYTextLayout *tagLayout = [YYTextLayout layoutWithContainer:container text:self];
            
            if (styleMaker.maxRowCount != 0) {
                if (tagLayout.rowCount > styleMaker.maxRowCount) {
                    [self deleteCharactersInRange:(NSRange){self.length - tagAttri.length, tagAttri.length}];
                    break;
                }
            }
            
            if (tagLayout.textBoundingSize.height > contentHeight) {
                if (contentHeight > 0) {
                    [self yy_insertString:@"\n" atIndex:self.length - tagAttri.length];
                    tagLayout = [YYTextLayout layoutWithContainer:container text:self];
                    [self insertAttributedString:[NSMutableAttributedString emptyAttributeString:fabs(styleMaker.insets.left) WithStyleMaker:styleMaker] atIndex:self.length - tagAttri.length];
                }
                contentHeight = tagLayout.textBoundingSize.height + 2;
            }
        }
        
        self.contentHeight = contentHeight;
        return self;
    };
}

- (NSMutableAttributedString *)attributedStringWithStyle:(YCTTagListStyleMaker *)styleMaker string:(NSString *)string needBorder:(BOOL)needBorder {
    NSMutableAttributedString *tagAttri = [NSMutableAttributedString new];
    tagAttri.yy_lineSpacing = styleMaker.lineSpace;
    [tagAttri yy_appendString:string];
    tagAttri.yy_font = styleMaker.font;
    tagAttri.yy_color = styleMaker.textColor;
    if (needBorder) {
        [tagAttri yy_setTextBackgroundBorder:[self textBorderWithStyleMaker:styleMaker] range:NSMakeRange(0, tagAttri.length)];
    }
    
    [tagAttri appendAttributedString:[NSMutableAttributedString emptyAttributeString:styleMaker.margin + fabs(styleMaker.insets.left) + fabs(styleMaker.insets.right) WithStyleMaker:styleMaker]];
    return tagAttri;
}

- (YYTextBorder *)textBorderWithStyleMaker:(YCTTagListStyleMaker *)maker {
    YYTextBorder *border = [YYTextBorder new];
    border.strokeWidth = maker.strokeWidth;
    border.strokeColor = maker.strokeColor;
    border.fillColor = maker.fillColor;
    border.cornerRadius = maker.cornerRadius;
    border.insets = maker.insets;
    return border;
}

+ (NSMutableAttributedString *)emptyAttributeString:(CGFloat)width WithStyleMaker:(YCTTagListStyleMaker *)maker {
    NSMutableAttributedString *spaceText = [NSMutableAttributedString yy_attachmentStringWithContent:[[UIImage alloc]init] contentMode:UIViewContentModeScaleToFill attachmentSize:CGSizeMake(width, 1) alignToFont:[UIFont systemFontOfSize:0] alignment:YYTextVerticalAlignmentCenter];
    spaceText.yy_lineSpacing = maker.lineSpace;
    return spaceText;
}

- (void)setContentHeight:(CGFloat)contentHeight {
    objc_setAssociatedObject(self, @selector(contentHeight), @(contentHeight), OBJC_ASSOCIATION_RETAIN);
}

- (CGFloat)contentHeight {
    return [objc_getAssociatedObject(self, @selector(contentHeight)) floatValue];
}

@end

