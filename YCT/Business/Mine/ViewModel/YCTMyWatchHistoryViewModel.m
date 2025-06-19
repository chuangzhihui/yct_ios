//
//  YCTMyWatchHistoryViewModel.m
//  YCT
//
//  Created by 木木木 on 2021/12/31.
//

#import "YCTMyWatchHistoryViewModel.h"
#import "YCTBasePagedViewModel+Protected.h"

@interface YCTMyWatchHistoryViewModel ()
@property (weak, nonatomic) YCTApiClearWatchHistory *apiClearWatchHistory;
@end

@implementation YCTMyWatchHistoryViewModel

- (instancetype)init {
    self = [super init];
    if (self) {
        self.request = [[YCTApiMyWatchHistory alloc] init];
    }
    return self;
}

- (void)dealloc {
    [_apiClearWatchHistory stop];
}

- (void)requestClearHistory {
    [self.loadingSubject sendNext:@YES];
    YCTApiClearWatchHistory *api = [YCTApiClearWatchHistory new];
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        [self.modelsM removeAllObjects];
        self.models = self.modelsM.copy;
        [self.loadAllDataSubject sendNext:@YES];
        [self.loadingSubject sendNext:@NO];
    } failure:^(__kindof YCTBaseRequest * _Nonnull request) {
        [self.loadingSubject sendNext:@NO];
        [self.netWorkErrorSubject sendNext:request.getError];
    }];
    self.apiClearWatchHistory = api;
}

@end
