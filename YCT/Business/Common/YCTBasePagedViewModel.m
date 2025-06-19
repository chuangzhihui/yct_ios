//
//  YCTBasePagedViewModel.m
//  YCT
//
//  Created by 木木木 on 2021/12/29.
//

#import "YCTBasePagedViewModel.h"

@interface YCTBasePagedViewModel ()
@property (assign) NSUInteger page;
@property (assign) NSUInteger pageSize;//每页展示多少条
@property (strong) NSMutableArray<__kindof YCTBaseModel *> *modelsM;
@property (copy, readwrite) NSArray<__kindof YCTBaseModel *> *models;
@property (strong, readwrite) RACSubject *hasMoreDataSubject;
@end

@implementation YCTBasePagedViewModel

- (instancetype)init {
    self = [super init];
    if (self) {
        self.page = 1;
        self.pageSize=20;
        self.modelsM = @[].mutableCopy;
        self.hasMoreDataSubject = [RACSubject subject];
    }
    return self;
}

- (void)dealloc {
    [self.request stop];
}

- (void)requestData {
    self.pageSize=20;
    [self requestDataWithRefresh:NO reset:NO];
}
- (void)requestAllData {
    self.pageSize=100000;
    [self requestDataWithRefresh:NO reset:NO];
}

- (void)resetRequestData {
    self.pageSize=20;
    [self requestDataWithRefresh:YES reset:YES];
}

- (void)refreshRequestData {
    self.pageSize=20;
    [self requestDataWithRefresh:YES reset:NO];
}

- (void)requestDataWithRefresh:(BOOL)refresh reset:(BOOL)reset {
    if (self.request.page == 0) {
        self.request.page = 1;
    }
    NSUInteger oldPage = self.page;
    if (refresh) {
        NSLog(@"刷新");
        self.request.page = self.page = 1;
    } else {
        [self.loadingSubject sendNext:@YES];
    }
    self.request.size = self.size;
    [self.request stop];
    [self.request startWithCompletionBlockWithSuccess:^(__kindof YCTBaseRequest * _Nonnull request) {
        NSLog(@"好友请求回调:%@——————page:%ld",request.responseString,self.page);
        if (refresh) {
            [self.modelsM removeAllObjects];
            self.models = self.modelsM.copy;
        }
        if (YCT_IS_ARRAY(request.responseDataModel)) {
            [self handleNewPageData:request.responseDataModel];
            NSArray *newData = request.responseDataModel;
            [self.modelsM addObjectsFromArray:newData];
            self.models = self.modelsM.copy;
            self.request.page = ++ self.page;
            if (newData.count == 0 || newData.count < [self size]) {
                [self.hasMoreDataSubject sendNext:@NO];
            } else {
                [self.hasMoreDataSubject sendNext:@YES];
            }
        } else {
            [self.hasMoreDataSubject sendNext:@YES];
        }
        [self.loadAllDataSubject sendNext:@YES];
        [self.loadingSubject sendNext:@NO];
    } failure:^(__kindof YCTBaseRequest * _Nonnull request) {
        
        if (refresh) {
            if (reset) {
                [self.modelsM removeAllObjects];
                self.models = self.modelsM.copy;
            } else {
                self.request.page = self.page = oldPage;
            }
        }
        
        [self.loadingSubject sendNext:@NO];
        [self.hasMoreDataSubject sendNext:@YES];
        [self.netWorkErrorSubject sendNext:request.getError];
    }];
}

- (void)handleNewPageData:(NSArray<YCTBaseModel *> *)data {
    
}

- (NSUInteger)size {
    return self.pageSize;
}

@end
