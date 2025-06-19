//
//  YCTSystemMsgViewModel.m
//  YCT
//
//  Created by 木木木 on 2021/12/29.
//

#import "YCTSystemMsgViewModel.h"
#import "YYModel.h"

@interface YCTSystemMsgViewModel ()

@property (assign) BOOL isFirtLoad;
@property (assign) NSUInteger page;
@property (strong) NSMutableArray<YCTSystemMsgModel *> *modelsM;

@end

@implementation YCTSystemMsgViewModel

- (instancetype)init {
    self = [super init];
    if (self) {
        self.request = [[YCTApiSystemMsg alloc] init];
        self.request.size = self.size;
        self.isNoMoreData = NO;
        self.isFirtLoad = YES;
    }
    return self;
}

- (void)requestDataWithCompletion:(void (^)(BOOL isFirstLoad, BOOL isNoMoreData, NSArray<YCTSystemMsgModel *> *newData))succeedBlock
                        failBlock:(void (^)(NSString *error))failBlock {
    
    if (self.isLoadingData || self.isNoMoreData) {
        if (failBlock) {
            failBlock(@"正在更新中");
        }
        return;
    }
    self.isLoadingData = YES;
  
    [self.request startWithCompletionBlockWithSuccess:^(__kindof YCTBaseRequest * _Nonnull request) {
        
        self.isLoadingData = NO;
        
        NSMutableArray *newData = [NSMutableArray array];
        
        if (YCT_IS_ARRAY(request.responseDataModel)) {
            NSArray *data = request.responseDataModel;
            
            for (NSInteger k = data.count - 1; k >= 0; --k) {
                [newData addObject:data[k]];
            }
            NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, newData.count)];
            [self.modelsM insertObjects:newData atIndexes:indexSet];
            
            self.request.page = ++ self.page;
            
            if (newData.count == 0 || newData.count < [self size]) {
                self.isNoMoreData = YES;
            } else {
                self.isNoMoreData = NO;
            }
        }
        
        if (succeedBlock) {
            succeedBlock(self.isFirtLoad, self.isNoMoreData, newData.copy);
        }
        self.isFirtLoad = NO;
    } failure:^(__kindof YCTBaseRequest * _Nonnull request) {
        
        self.isLoadingData = NO;
        
        if (failBlock) {
            failBlock(request.getError);
        }
    }];
}

- (NSArray *)models {
    return self.modelsM.copy;
}

- (CGFloat)getCellHeightAtIndex:(NSUInteger)index {
    if (index < self.models.count) {
        YCTSystemMsgModel *model = self.models[index];
        return model.height;
    }
    return 0;
}

@end
