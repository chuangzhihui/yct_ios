//
//  YCTInteractionMsgViewModel.m
//  YCT
//
//  Created by 木木木 on 2022/1/3.
//

#import "YCTInteractionMsgViewModel.h"
#import "YCTBasePagedViewModel+Protected.h"
#import "YYModel.h"

@implementation YCTInteractionMsgViewModel

- (instancetype)init {
    self = [super init];
    if (self) {
        self.request = [[YCTApiInteractionMsg alloc] init];
    }
    return self;
}

- (CGFloat)getCellHeightAtIndex:(NSUInteger)index {
    if (index < self.models.count) {
        YCTInteractionMsgModel *model = self.models[index];
        return model.height;
    }
    return 0;
}

@end
