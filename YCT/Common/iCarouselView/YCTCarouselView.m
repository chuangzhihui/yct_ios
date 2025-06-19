//
//  YCTCarouselView.m
//  YCT
//
//  Created by 木木木 on 2021/12/13.
//

#import "YCTCarouselView.h"
#import "YCTPageControl.h"
#import "YCTProxy.h"

@interface YCTCarouselView ()<iCarouselDelegate, iCarouselDataSource>
@property (strong, nonatomic) YCTPageControl *pageControl;
@property (strong, nonatomic, readwrite) iCarousel *carousel;
@property (strong, nonatomic) NSTimer *timer;
@end

@implementation YCTCarouselView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self setup];
    }
    return self;
}

- (void)setup {
    self.carousel = ({
        iCarousel *carousel = [[iCarousel alloc] initWithFrame:(CGRect){0, 0, self.frame.size}];
        carousel.delegate = self;
        carousel.dataSource = self;
        carousel.backgroundColor = UIColor.clearColor;
        carousel.bounces = NO;
        carousel.pagingEnabled = YES;
        carousel.clipsToBounds = YES;
        carousel.type = iCarouselTypeLinear;
        carousel;
    });
    [self addSubview:self.carousel];
    
    self.pageControl = ({
        YCTPageControl *pageContol = [[YCTPageControl alloc] init];
        pageContol.currentColor = UIColorFromRGB(0xFE1389);
        pageContol.type = YCTPageControlRight;
        pageContol;
    });
    [self addSubview:self.pageControl];
}

- (void)layoutSubviews {
    self.carousel.frame = self.bounds;
    CGRect pageControlRect = (CGRect){
        self.itemSpacing + 6,
        self.bounds.size.height - 9,
        self.bounds.size.width - (self.itemSpacing + 6) * 2,
        3
    };
    if (!CGRectEqualToRect(self.pageControl.frame, pageControlRect)) {
        self.pageControl.frame = pageControlRect;
        [self.pageControl layoutPageControl];
    }
}

#pragma mark - Public

- (void)reload {
    [self setNeedsLayout];
    [self.carousel reloadData];
}

#pragma mark - Private

- (void)stopTimer {
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
}

- (void)startTimer {
    if (self.autoScrollTimeInterval <= 0) {
        return;
    }
    _timer = [NSTimer scheduledTimerWithTimeInterval:self.autoScrollTimeInterval target:[YCTProxy proxyWithTarget:self] selector:@selector(autoScroll) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
}

- (void)autoScroll {
    [self.carousel scrollByOffset:1 duration:0.4];
}

#pragma mark - Getter

- (NSInteger)currentIndex {
    return self.carousel.currentItemIndex;
}

#pragma mark - Setter

- (void)setUrls:(NSArray<NSString *> *)urls {
    if (_urls.count == 0 && urls.count == 0) {
        return;
    }
    if (!_urls || ![_urls isEqual:urls]) {
        _urls = urls;
        _imageNames = nil;
        [self.carousel reloadData];
    
        self.pageControl.numberOfPages = _urls.count;
        self.pageControl.hidden = _urls.count == 0;
        
        if (_urls.count > 0) {
            self.pageControl.currentPage = 0;
            [self.carousel scrollToItemAtIndex:0 animated:NO];
        }
    }
}

- (void)setImageNames:(NSArray<NSString *> *)imageNames {
    if (![_imageNames isEqual:imageNames]) {
        _imageNames = imageNames;
        _urls = nil;
        [self.carousel reloadData];
        
        if (_imageNames.count > 0) {
            [self.carousel scrollToItemAtIndex:0 animated:NO];
        }
    }
}

- (void)setAutoScrollTimeInterval:(NSTimeInterval)autoScrollTimeInterval {
    if (_autoScrollTimeInterval != autoScrollTimeInterval) {
        _autoScrollTimeInterval = autoScrollTimeInterval;
        if (autoScrollTimeInterval > 0) {
            [self startTimer];
        } else {
            [self stopTimer];
        }
    }
}

#pragma mark - iCarouselDataSource

- (NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel {
    if (_urls) {
        return _urls.count;
    } else if (_imageNames) {
        return _imageNames.count;
    } else {
        return 0;
    }
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view {
    UIImageView *imageView = (UIImageView *)view;
    if (!imageView) {
        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, _itemWidth, _itemHeight)];
        imageView.layer.cornerRadius = _cornerRadius;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        imageView.backgroundColor = UIColor.whiteColor;
    }
    
    if (self.urls) {
        [imageView loadImageGraduallyWithURL:[NSURL URLWithString:self.urls[index]] placeholderImageName:self.placeholderName];
    } else if (self.imageNames) {
        imageView.image = [UIImage imageNamed:self.imageNames[index]];
    } else if (self.placeholderName) {
        imageView.image = [UIImage imageNamed:self.placeholderName];
    }
    
    return imageView;
}

#pragma mark - iCarouselDelegate

- (void)carousel:(iCarousel *)carousel didSelectItemAtIndex:(NSInteger)index {
    if (self.clickItem) {
        self.clickItem(index);
    }
}

- (void)carouselWillBeginDragging:(iCarousel *)carousel {
    [self stopTimer];
}

- (void)carouselDidEndDragging:(iCarousel *)carousel willDecelerate:(BOOL)decelerate {
    [self startTimer];
}

- (void)carouselDidEndScrollingAnimation:(iCarousel *)carousel {
    
}

- (void)carouselDidScroll:(iCarousel *)carousel {
    
}

- (void)carouselCurrentItemIndexDidChange:(iCarousel *)carousel {
    if (self.carouselDidScroll) {
        self.carouselDidScroll(carousel.currentItemIndex, carousel.numberOfItems);
    }
    if (carousel.currentItemIndex < self.pageControl.numberOfPages) {
        self.pageControl.currentPage = carousel.currentItemIndex;
    }
}

- (CGFloat)carousel:(iCarousel *)carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value {
    switch (option) {
        case iCarouselOptionWrap:
            if (carousel.numberOfItems <= 1) {
                return NO;
            } else {
                return YES;
            }
            break;
        case iCarouselOptionSpacing: {
            if (_itemWidth != 0) {
                return _itemSpacing / _itemWidth + 1;
            }
            return value;
        }
            break;
        default:
            return value;
    }
}

- (void)willMoveToWindow:(UIWindow *)newWindow {
    if (newWindow) {
        [self startTimer];
    } else {
        [self stopTimer];
    }
}

@end

