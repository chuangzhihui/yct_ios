//
//  NSAttributedString+YCTAttachment.h
//  YCT
//
//  Created by 木木木 on 2021/12/14.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YCTTextImageViewAttachment : YYTextAttachment
@property (nonatomic, copy) NSString *imageName;
@property (nonatomic, assign) CGSize size;
@property (nonatomic, strong) UIColor *bgColor;
@end

@interface NSAttributedString (YCTAttachment)

+ (NSMutableAttributedString *)yct_yyAttachmentWithFont:(UIFont *)font
                                             attachment:(YCTTextImageViewAttachment *)attachment
                                         attachmentSize:(CGSize)attachmentSize;

+ (NSMutableAttributedString *)yct_yyAttachmentWithFont:(UIFont *)font
                                              imageName:(NSString *)imageName
                                              imageSize:(CGSize)imageSize
                                         attachmentSize:(CGSize)attachmentSize;

@end

NS_ASSUME_NONNULL_END
