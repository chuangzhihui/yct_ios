//
//  NSAttributedString+YCTAttachment.m
//  YCT
//
//  Created by 木木木 on 2021/12/14.
//

#import "NSAttributedString+YCTAttachment.h"
#import <pthread.h>

@implementation YCTTextImageViewAttachment {
    UIImageView *_imageView;
}

- (void)setBgColor:(UIColor *)bgColor {
    _bgColor = bgColor;
    _imageView.backgroundColor = _bgColor;
}

- (void)setContent:(id)content {
    _imageView = content;
}

- (id)content {
    /// UIImageView 只能在主线程访问
    if (pthread_main_np() == 0) return nil;
    if (!_imageView) {
        /// 第一次获取时 (应该是在文本渲染完成，需要添加附件视图时)，初始化图片视图
        _imageView = [UIImageView new];
        _imageView.clipsToBounds = YES;
        if (_bgColor) {
            _imageView.backgroundColor = _bgColor;
        } else {
            _imageView.backgroundColor = UIColorFromRGB(0xefefef);
        }
    }
    
    _imageView.bounds = CGRectMake(0, 0, _size.width, _size.height);
    if (_imageName) {
        _imageView.image = [UIImage imageNamed:_imageName];
    }
    if (!_bgColor) {
        _imageView.backgroundColor = UIColor.whiteColor;
    }
    return _imageView;
}
@end

@implementation NSAttributedString (YCTAttachment)

+ (NSMutableAttributedString *)yct_yyAttachmentWithFont:(UIFont *)font
                                             attachment:(YCTTextImageViewAttachment *)attachment
                                         attachmentSize:(CGSize)attachmentSize {
    YYTextRunDelegate *delegate = [YYTextRunDelegate new];
    delegate.width = attachmentSize.width;
    CGFloat fontHeight = font.ascender - font.descender;
    CGFloat yOffset = font.ascender - fontHeight * 0.5;
    delegate.ascent = attachmentSize.height * 0.5 + yOffset;
    delegate.descent = attachmentSize.height - delegate.ascent;
    
    NSMutableAttributedString *atr = [[NSMutableAttributedString alloc] initWithString:YYTextAttachmentToken];
    [atr yy_setTextAttachment:attachment range:NSMakeRange(0, atr.length)];
    CTRunDelegateRef ctDelegate = delegate.CTRunDelegate;
    [atr yy_setRunDelegate:ctDelegate range:NSMakeRange(0, atr.length)];
    if (ctDelegate) CFRelease(ctDelegate);
    
    return atr;
}

+ (NSMutableAttributedString *)yct_yyAttachmentWithFont:(UIFont *)font
                                              imageName:(NSString *)imageName
                                              imageSize:(CGSize)imageSize
                                         attachmentSize:(CGSize)attachmentSize {
    YCTTextImageViewAttachment *attachment = [YCTTextImageViewAttachment new];
    attachment.contentMode = UIViewContentModeLeft;
    attachment.size = imageSize;
    attachment.imageName = imageName;
    return [self yct_yyAttachmentWithFont:font attachment:attachment attachmentSize:attachmentSize];
}

@end
