//
//  YCTBezierPathTool.h
//  YCT
//
//  Created by 木木木 on 2021/12/15.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YCTBezierPathTool : NSObject

@property (nonatomic, assign) float radius;
@property (nonatomic, assign) float radius_TopLeft;
@property (nonatomic, assign) float radius_TopRight;
@property (nonatomic, assign) float radius_BottomLeft;
@property (nonatomic, assign) float radius_BottomRight;

@property (nonatomic, assign) CGPoint hLeftUpPoint;
@property (nonatomic, assign) CGPoint hRightUpPoint;
@property (nonatomic, assign) CGPoint hLeftDownPoint;
@property (nonatomic, assign) CGPoint vLeftUpPoint;
@property (nonatomic, assign) CGPoint vRightDownPoint;
@property (nonatomic, assign) CGPoint centerLeftUp;
@property (nonatomic, assign) CGPoint centerRightUp;
@property (nonatomic, assign) CGPoint centerLeftDown;
@property (nonatomic, assign) CGPoint centerRightDown;

@property (nonatomic, assign) CGSize rectSize;
@property (nonatomic, strong) UIColor *fillColor;

- (instancetype)initWithRadius:(float)radius rectSize:(CGSize)rectSize fillColor:(UIColor *)fillColor;

- (instancetype)initWithRadius_TopLeft:(float)radius_TL
                       radius_TopRight:(float)radius_TR
                     radius_BottomLeft:(float)radius_BL
                    radius_BottomRight:(float)radius_BR
                              rectSize:(CGSize)rectSize
                             fillColor:(UIColor *)fillColor;

- (void)configCornerBezierPath:(UIBezierPath *)bezierPath;

- (void)configAllCornerPoint;

- (void)configTopLeftPoint;

- (void)configTopRightPoint;

- (void)configBottomLeftPoint;

- (void)configBottomRightPoint;

@end

NS_ASSUME_NONNULL_END
