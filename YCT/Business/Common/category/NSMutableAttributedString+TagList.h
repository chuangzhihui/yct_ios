//
//  NSMutableAttributedString+TagList.h
//  YCT
//
//  Created by 木木木 on 2021/12/10.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class YCTTagListStyleMaker;

typedef NSMutableAttributedString * _Nullable(^YCTTagListAttriStringAppend)(NSArray<NSString *> *tags, void(^make)(YCTTagListStyleMaker *make));

@interface YCTTagListStyleMaker : NSObject

@property (nonatomic, assign) CGFloat strokeWidth;
@property (nonatomic, strong) UIColor *strokeColor;
@property (nonatomic, assign) CGLineJoin lineJoin;
@property (nonatomic, assign) UIEdgeInsets insets;
@property (nonatomic, assign) CGFloat cornerRadius;
@property (nonatomic, strong) UIColor *fillColor;
@property (nonatomic, strong) UIFont *font;
@property (nonatomic, strong) UIColor *textColor;
@property (nonatomic, assign) CGFloat lineSpace;
@property (nonatomic, assign) CGFloat margin;
@property (nonatomic, assign) CGFloat maxWidth;
@property (nonatomic, assign) NSInteger maxRowCount;

@end

@interface NSMutableAttributedString (TagList)

@property (nonatomic, assign) CGFloat contentHeight;
@property (nonatomic, copy) YCTTagListAttriStringAppend append;

@end

NS_ASSUME_NONNULL_END
