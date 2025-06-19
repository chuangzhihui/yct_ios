//
//  YCTPageControl.m
//  YCT
//
//  Created by 木木木 on 2022/1/10.
//

#import "YCTPageControl.h"

@implementation YCTPageControl

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initialize];
    }
    return self;
}

- (void)initialize {
    self.backgroundColor = [UIColor clearColor];
    _otherMultiple = 4;
    _currentMultiple = 4;
    _numberOfPages = 0;
    _currentPage = 0;
    _controlSize = 3;
    _controlSpacing = 4;
    _otherColor = [UIColor.whiteColor colorWithAlphaComponent:0.4];
    _currentColor = [UIColor orangeColor];
    _type = YCTPageControlMiddle;
}

- (void)setOtherColor:(UIColor *)otherColor {
    if (![self isTheSameColor:otherColor anotherColor:_otherColor]) {
        _otherColor = otherColor;
        [self createPointView];
    }
}

- (void)setCurrentColor:(UIColor *)currentColor {
    if (![self isTheSameColor:currentColor anotherColor:_currentColor]) {
        _currentColor = currentColor;
        [self createPointView];
    }
}

- (void)setControlSize:(NSInteger)controlSize {
    if (_controlSize != controlSize) {
        _controlSize = controlSize;
        [self createPointView];
    }
}

- (void)setOtherMultiple:(NSInteger)otherMultiple {
    if (otherMultiple != _otherMultiple) {
        _otherMultiple = otherMultiple;
        [self createPointView];
    }
}

- (void)setCurrentMultiple:(NSInteger)currentMultiple {
    if (currentMultiple != _currentMultiple) {
        _currentMultiple = currentMultiple;
        [self createPointView];
    }
}

- (void)setControlSpacing:(NSInteger)controlSpacing {
    if (_controlSpacing != controlSpacing) {
        _controlSpacing = controlSpacing;
        [self createPointView];
    }
}

- (void)setType:(YCTPageControlType)type {
    if (_type != type) {
        _type = type;
        [self createPointView];
    }
}

- (void)setNumberOfPages:(NSInteger)page {
    if (_numberOfPages != page) {
        _numberOfPages = page;
        [self createPointView];
    }
}

- (void)setCurrentPage:(NSInteger)currentPage {
    if ([self.delegate respondsToSelector:@selector(yct_PageControlClick:index:)]) {
        [self.delegate yct_PageControlClick:self index:currentPage];
    }
    
    if (_currentPage != currentPage) {
        [self exchangeCurrentView:_currentPage new:currentPage];
        _currentPage = currentPage;
    }
}

- (void)layoutPageControl {
    [self createPointView];
}

- (void)clearView {
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
}

- (void)createPointView {
    [self clearView];
    if (_numberOfPages <= 0) {
        return;
    }
    
    /// 居中控件
    CGFloat startX = 0;
    CGFloat startY = 0;
    CGFloat mainWidth = (_numberOfPages - 1) * _controlSize * _otherMultiple + (_numberOfPages - 1) * _controlSpacing + _controlSize * _currentMultiple;
    if (self.frame.size.width < mainWidth) {
        startX = 0;
    } else {
        if (_type == YCTPageControlLeft) {
            startX = 10;
        } else if (_type == YCTPageControlMiddle) {
            startX = (self.frame.size.width - mainWidth) / 2;
        } else if (_type == YCTPageControlRight) {
            startX = self.frame.size.width - mainWidth - 10;
        }
    }
    if (self.frame.size.height < _controlSize) {
        startY = 0;
    } else {
        startY = (self.frame.size.height-_controlSize) / 2;
    }
    
    for (int page = 0; page < _numberOfPages; page ++) {
        if (page == _currentPage) {
            UIView *currPointView = [[UIView alloc] initWithFrame:CGRectMake(startX, startY, _controlSize * _currentMultiple, _controlSize)];
            currPointView.layer.cornerRadius = _controlSize / 2;
            currPointView.tag = page + 1000;
            currPointView.backgroundColor = _currentColor;
            currPointView.userInteractionEnabled = YES;
            UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickAction:)];
            [currPointView addGestureRecognizer:tapGesture];
            [self addSubview:currPointView];
            startX = CGRectGetMaxX(currPointView.frame) +_controlSpacing;
        } else {
            UIView *otherPointView = [[UIView alloc] initWithFrame:CGRectMake(startX, startY, _controlSize * _otherMultiple, _controlSize)];
            otherPointView.backgroundColor = _otherColor;
            otherPointView.tag = page + 1000;
            otherPointView.layer.cornerRadius = _controlSize / 2;
            otherPointView.userInteractionEnabled = YES;
            UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickAction:)];
            [otherPointView addGestureRecognizer:tapGesture];
            [self addSubview:otherPointView];
            startX = CGRectGetMaxX(otherPointView.frame) + _controlSpacing;
        }
    }
}

- (void)exchangeCurrentView:(NSInteger)old new:(NSInteger)new {
    UIView *oldSelect = [self viewWithTag:1000 + old];
    CGRect mpSelect = oldSelect.frame;
    
    UIView *newSeltect = [self viewWithTag:1000 + new];
    CGRect newTemp = newSeltect.frame;
    
    oldSelect.backgroundColor = _otherColor;
    newSeltect.backgroundColor = _currentColor;
    
    [UIView animateWithDuration:0.3 animations:^{
        CGFloat lx = mpSelect.origin.x;
        if (new < old) {
            lx += self.controlSize * (self.currentMultiple - self.otherMultiple);
        }
        oldSelect.frame = CGRectMake(lx, mpSelect.origin.y, self.controlSize * self.otherMultiple, self.controlSize);
        
        CGFloat mx = newTemp.origin.x;
        if (new>old) {
            mx -= self.controlSize * (self.currentMultiple - self.otherMultiple);
        }
        newSeltect.frame = CGRectMake(mx, newTemp.origin.y, self.controlSize * self.currentMultiple, self.controlSize);
        
        /// 左边的时候到右边 越过点击
        if (new - old > 1) {
            for(NSInteger t = old + 1; t < new; t ++) {
                UIView *ms = [self viewWithTag:1000 + t];
                ms.frame = CGRectMake(ms.frame.origin.x - self.controlSize * (self.currentMultiple - self.otherMultiple), ms.frame.origin.y, self.controlSize * self.otherMultiple, self.controlSize);
            }
        }
        /// 右边选中到左边的时候 越过点击
        if (new - old < -1) {
            for (NSInteger t = new + 1; t < old; t ++) {
                UIView *ms = [self viewWithTag:1000 + t];
                ms.frame = CGRectMake(ms.frame.origin.x + self.controlSize * (self.currentMultiple - self.otherMultiple), ms.frame.origin.y, self.controlSize * self.otherMultiple, self.controlSize);
            }
        }
    }];
}

- (void)clickAction:(UITapGestureRecognizer *)recognizer {
    NSInteger index = recognizer.view.tag - 1000;
    [self setCurrentPage:index];
}

- (BOOL)isTheSameColor:(UIColor *)color1 anotherColor:(UIColor *)color2 {
    return CGColorEqualToColor(color1.CGColor, color2.CGColor);
}

@end
