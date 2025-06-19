//
//  YCTTagAttributeConfiguration.m
//  YCT
//
//  Created by 木木木 on 2021/12/15.
//

#import "YCTTagAttributeConfiguration.h"

@implementation YCTTagAttributeConfiguration

- (instancetype)init {
    self = [super init];
    if (self) {
        self.displayType = YCTTagDisplayTypeNormal;
        self.displayType = YCTTagDisplayTypeOperation;
        self.scrollDirection = UICollectionViewScrollDirectionVertical;
        self.borderWidth = 0;
        self.cornerRadius = 15;
        self.normalBackgroundColor = UIColorFromRGB(0xF8F8F8);
        self.selectedBackgroundColor = UIColorFromRGB(0x00C6FF);
        self.titleFont = [UIFont systemFontOfSize:14 weight:(UIFontWeightMedium)];
        self.textColor = UIColorFromRGB(0x999999);
        self.selectedTextColor = UIColor.whiteColor;
        self.margin = 12;
        self.itemSize = CGSizeMake(100, 29);
        self.minimumInteritemSpacing = 8;
        self.minimumLineSpacing = 15;
        self.sectionInset = UIEdgeInsetsMake(15, 15, 15, 15);
    }
    return self;
}

@end
