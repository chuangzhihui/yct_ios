//
//  YCTPostImagesView.m
//  YCT
//
//  Created by 木木木 on 2021/12/31.
//

#import "YCTPostImagesView.h"

#define kMargin 15
#define KSpacing 7

#define kHWScale (177.0/345.0)

@interface YCTPostImagesView ()
@property (strong, nonatomic) NSMutableArray<UIImageView *> *imagesArray;
@end

@implementation YCTPostImagesView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViews];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    _imagesArray = @[].mutableCopy;
    for (NSUInteger index = 0; index < 4; index ++) {
        UIImageView *imageView = [UIImageView new];
        imageView.clipsToBounds = YES;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.backgroundColor = [UIColor whiteColor];
        imageView.layer.cornerRadius = 5;
        imageView.userInteractionEnabled = YES;
        imageView.tag = index;
        [imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewClick:)]];
        [_imagesArray addObject:imageView];
        [self addSubview:imageView];
    }
}

- (void)updateWithUrls:(NSArray<NSString *> *)urls {
    NSUInteger total = urls.count;
    [_imagesArray enumerateObjectsUsingBlock:^(UIImageView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx < total) {
            [obj loadImageGraduallyWithURL:[NSURL URLWithString:urls[idx]]];
            [self layoutImageView:obj atIndex:idx total:total];
            obj.hidden = NO;
        } else {
            [obj cancelLoadImage];
            obj.frame = CGRectZero;
            obj.hidden = YES;
        }
    }];
}

- (UIImageView *)imageViewAtIndex:(NSUInteger)index {
    if (index < _imagesArray.count) {
        return _imagesArray[index];
    }
    return nil;
}

- (void)layoutImageView:(UIImageView *)imageView
                atIndex:(NSUInteger)index
                  total:(NSUInteger)total {
    if (total == 1) {
        imageView.frame = CGRectMake(kMargin,
                                     0,
                                     Iphone_Width - 2 * kMargin,
                                     ceil((Iphone_Width - 2 * kMargin) * kHWScale));
    } else if (total == 2) {
        CGFloat size = ceil((Iphone_Width - 2 * kMargin - KSpacing) / 2);
        imageView.frame = CGRectMake(kMargin + index * (size + KSpacing),
                                     0,
                                     size,
                                     size);
    } else if (total == 3) {
        CGFloat size = ceil((Iphone_Width - 2 * kMargin - KSpacing * 2) / 3);
        imageView.frame = CGRectMake(kMargin + index * (size + KSpacing),
                                     0,
                                     size,
                                     size);
    } else {
        CGFloat size = ceil((Iphone_Width - 2 * kMargin - KSpacing) / 2);
        imageView.frame = CGRectMake(kMargin + (index % 2) * (size + KSpacing),
                                     (index > 1 ? 0 : 1) * (size + KSpacing),
                                     size,
                                     size);
    }
}

- (void)imageViewClick:(UITapGestureRecognizer *)tap {
    !self.imagViewClickBlock ?: self.imagViewClickBlock(tap.view.tag);
}

+ (CGFloat)heightWithTotal:(NSUInteger)total {
    if (total == 0) {
        return 0;
    } else if (total == 1) {
        return ceil((Iphone_Width - 2 * kMargin) * kHWScale);
    } else if (total == 2) {
        return ceil((Iphone_Width - 2 * kMargin - KSpacing) / 2);
    } else if (total == 3) {
        return ceil((Iphone_Width - 2 * kMargin - KSpacing * 2) / 3);
    } else {
        return ceil((Iphone_Width - 2 * kMargin - KSpacing) / 2) * 2 + KSpacing;
    }
}

@end
