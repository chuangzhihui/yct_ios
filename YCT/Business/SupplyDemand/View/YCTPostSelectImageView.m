//
//  YCTPostSelectImageView.m
//  YCT
//
//  Created by 木木木 on 2021/12/23.
//

#import "YCTPostSelectImageView.h"

#define kMargin 15
#define kTop 0
#define kSpacing 10
#define kImageCount 4
#define kTagIndex 100

@interface YCTPostSelectImagePlaceHolder : UIView
@property (nonatomic, strong) UIImageView *photoImageView;
@property (nonatomic, strong) UILabel *countLabel;
@end

@interface YCTPostSelectImageItemView : UIView
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIButton *deleteButton;
@end

@interface YCTPostSelectImageView ()
@property (nonatomic, strong) YCTPostSelectImagePlaceHolder *placeHolder;
@property (nonatomic, copy) NSArray<YCTPostSelectImageItemView *> *items;
@property (nonatomic, assign, readwrite) NSUInteger currentCount;
@end

@implementation YCTPostSelectImageView

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
    self.currentCount = 0;
    
    self.placeHolder = [YCTPostSelectImagePlaceHolder new];
    [self addSubview:self.placeHolder];
    
    NSMutableArray *_items = @[].mutableCopy;
    for (int i = 0; i < kImageCount; i ++) {
        YCTPostSelectImageItemView *item = [YCTPostSelectImageItemView new];
        item.tag = i + kTagIndex;
        item.deleteButton.tag = i + kTagIndex;
        [item.deleteButton addTarget:self action:@selector(deleteImageClick:) forControlEvents:(UIControlEventTouchUpInside)];
        [self addSubview:item];
        [_items addObject:item];
    }
    self.items = _items.copy;
    
    @weakify(self);
    [self.placeHolder addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
        @strongify(self);
        if (self.selectImageBlock) {
            self.selectImageBlock();
        }
    }]];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (self.items.count == 0) {
        return;
    }
    
    CGFloat itemWidth = ceil((self.bounds.size.width - kMargin * 2 - kSpacing * (kImageCount - 1)) / kImageCount);
    CGFloat itemHeight = itemWidth;
    
    self.placeHolder.frame = CGRectZero;
    self.placeHolder.hidden = YES;
    
    for (int i = 0; i < kImageCount; i ++) {
        self.items[i].frame = (CGRect){
            kMargin + itemWidth * i + kSpacing * i,
            kTop,
            itemWidth,
            itemHeight
        };
        self.items[i].hidden = (i >= self.currentCount);
        
        if (self.currentCount == i) {
            self.placeHolder.frame = self.items[i].frame;
            self.placeHolder.hidden = NO;
        }
    }
}

- (void)deleteImageClick:(UIButton *)sender {
    int index = (int)(sender.tag - kTagIndex);
    if (self.deleteImageBlock) {
        self.deleteImageBlock(index);
    }
}

- (void)setImageModels:(NSArray<YCTImageModel *> *)imageModels {
    _imageModels = imageModels;
    
    for (int i = 0; i < kImageCount; i ++) {
        self.items[i].imageView.image = nil;
        [self.items[i].imageView cancelLoadImage];
    }
    
    for (int i = 0; i < imageModels.count; i ++) {
        YCTImageModel *model = imageModels[i];
        if (model.image) {
            self.items[i].imageView.image = model.image;
        } else if (model.imageUrl) {
            [self.items[i].imageView loadImageGraduallyWithURL:[NSURL URLWithString:model.imageUrl]];
        }
    }
    
    self.currentCount = imageModels.count;
    
    [self setNeedsLayout];
}

+ (CGFloat)standardHeight {
    CGFloat itemWidth = ceil((Iphone_Width - kMargin * 2 - kSpacing * (kImageCount - 1)) / kImageCount);
    return itemWidth + kTop * 2;
}

@end

@implementation YCTPostSelectImagePlaceHolder

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColor.grayButtonBgColor;
        self.layer.cornerRadius = 3;
        self.layer.masksToBounds = NO;
        
        self.photoImageView = ({
            UIImageView *view = [[UIImageView alloc] init];
            view.image = [UIImage imageNamed:@"post_addImage"];
            view.bounds = (CGRect){
                0, 0,
                CGSizeMake(24, 24)
            };
            view;
        });
        [self addSubview:self.photoImageView];
        
        self.countLabel = ({
            UILabel *view = [[UILabel alloc] init];
            view.text = @"0/4";
            view.font = [UIFont PingFangSCMedium:12];
            view.textColor = UIColor.mainGrayTextColor;
            view.textAlignment = NSTextAlignmentCenter;
            view.bounds = (CGRect){
                0, 0,
                CGSizeMake(40, 20)
            };
            view;
        });
        [self addSubview:self.countLabel];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.photoImageView.center = CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2 - 9);
    self.countLabel.center = CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2 + 15);
}

@end

@implementation YCTPostSelectImageItemView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColor.grayButtonBgColor;
        self.layer.cornerRadius = 3;
        self.layer.masksToBounds = NO;
        
        self.imageView = ({
            UIImageView *view = [[UIImageView alloc] init];
            view.contentMode = UIViewContentModeScaleAspectFit;
            view;
        });
        [self addSubview:self.imageView];
        
        self.deleteButton = ({
            UIButton *view = [UIButton buttonWithType:(UIButtonTypeCustom)];
            [view setImage:[UIImage imageNamed:@"post_addImage_delete"] forState:(UIControlStateNormal)];
            view;
        });
        [self addSubview:self.deleteButton];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.imageView.frame = self.bounds;
    self.deleteButton.frame = (CGRect){
        self.bounds.size.width - 16, 0,
        CGSizeMake(16, 16)
    };
}

@end
