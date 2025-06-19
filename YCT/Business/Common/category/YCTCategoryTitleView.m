//
//  YCTCategoryTitleView.m
//  YCT
//
//  Created by hua-cloud on 2021/12/11.
//

#import "YCTCategoryTitleView.h"

@implementation YCTCategoryTitleView

- (void)refreshCellModel:(JXCategoryBaseCellModel *)cellModel index:(NSInteger)index{
    [super refreshCellModel:cellModel index:index];
    if (self.UIDelegate && [self.UIDelegate respondsToSelector:@selector(selectedTitleColorWhenRefreshToIndex:)]) {
        JXCategoryTitleCellModel *model = (JXCategoryTitleCellModel *)cellModel;
        model.titleSelectedColor = [self.UIDelegate selectedTitleColorWhenRefreshToIndex:index];
    }
}

@end
