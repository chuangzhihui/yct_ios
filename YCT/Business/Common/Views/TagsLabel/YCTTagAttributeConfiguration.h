//
//  YCTTagAttributeConfiguration.h
//  YCT
//
//  Created by 木木木 on 2021/12/15.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, YCTTagDisplayType) {
    YCTTagDisplayTypeNormal,
    YCTTagDisplayTypeOperation,
};

@interface YCTTagAttributeConfiguration : NSObject

@property (nonatomic) YCTTagDisplayType displayType;
@property (nonatomic) UICollectionViewScrollDirection scrollDirection;

@property (nonatomic) CGFloat borderWidth;
@property (nonatomic) CGFloat cornerRadius;
@property (strong, nonatomic) UIColor *borderColor;

@property (strong, nonatomic) UIColor *normalBackgroundColor;
@property (strong, nonatomic) UIColor *selectedBackgroundColor;

@property (strong, nonatomic) UIFont *titleFont;
@property (strong, nonatomic) UIColor *textColor;
@property (strong, nonatomic) UIColor *selectedTextColor;
@property (nonatomic) CGFloat margin;

@property (nonatomic) CGFloat minimumLineSpacing;
@property (nonatomic) CGFloat minimumInteritemSpacing;
@property (nonatomic) CGSize itemSize;
@property (nonatomic) UIEdgeInsets sectionInset;

@end
