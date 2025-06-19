//
//  YCTCarouselView.h
//  YCT
//
//  Created by 木木木 on 2021/12/13.
//

#import <UIKit/UIKit.h>
#import <iCarousel.h>

NS_ASSUME_NONNULL_BEGIN

@interface YCTCarouselView : UIView

@property (nonatomic, strong, readonly) iCarousel *carousel;

@property (nonatomic, copy) NSArray<NSString *> * _Nullable urls;
@property (nonatomic, copy) NSArray<NSString *> *imageNames;
@property (nonatomic, copy) NSString *placeholderName;

@property (nonatomic, assign) CGFloat cornerRadius;
@property (nonatomic, assign) CGFloat itemWidth;
@property (nonatomic, assign) CGFloat itemHeight;
@property (nonatomic, assign) CGFloat itemSpacing;
@property (nonatomic, assign) NSTimeInterval autoScrollTimeInterval;

@property (nonatomic, assign, readonly) NSInteger currentIndex;

@property (nonatomic, copy) void (^clickItem)(NSInteger index);

@property (nonatomic, copy) void (^carouselDidScroll)(NSInteger currentIndex, NSInteger totalCount);

- (void)reload;

@end

NS_ASSUME_NONNULL_END
