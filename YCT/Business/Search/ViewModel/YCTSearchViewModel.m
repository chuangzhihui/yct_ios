//
//  YCTSearchViewModel.m
//  YCT
//
//  Created by hua-cloud on 2022/1/11.
//

#import "YCTSearchViewModel.h"
#import "YCTApiWantSearch.h"
#import "YCTApiHotSearch.h"
#import "YCTApiCateSearch.h"
static NSString * const k_store_search_history_keyword = @"k_store_search_history_keyword";

@interface YCTSearchResultViewModel ()
@property (nonatomic, copy, readwrite) NSArray<YCTSearchUserModel *> * users;
@property (nonatomic, copy, readwrite) NSArray<YCTVideoModel *> * hotVideos;
@property (nonatomic, copy, readwrite) NSArray<YCTVideoModel *> * videos;
@property (nonatomic, copy, readwrite) NSArray<YCTVideoModel *> * recommendVideos;

@property (nonatomic, copy, readwrite) NSString * hotTitle;
@property (nonatomic, copy, readwrite) NSString * userTitle;
@property (nonatomic, copy, readwrite) NSString * videoTitle;
@property (nonatomic, copy, readwrite) NSString * recommendTitle;

@property (nonatomic, strong, readwrite) RACSubject * nodataSubject;
@property (nonatomic, strong, readwrite) RACSubject * reloadSubject;
@property (nonatomic, assign) NSInteger page;

@property (nonatomic, copy) NSString * keyword;
@property (nonatomic, assign) YCTSearchResultType type;

@end

@implementation YCTSearchResultViewModel
- (instancetype)initWithType:(YCTSearchResultType)type keyword:(NSString *)keyword locationId:(NSString *)locationId
{
    self = [super init];
    if (self) {
        self.type = type;
        self.keyword = keyword;
        self.locationId = YCTString(locationId, @"0");
        self.page = 1;
        [self setup];
    }
    return self;
}

- (void)setup{
    if (self.type == YCTSearchResultTypeAll) {
        [self searchForSynthesize];
    }else if(self.type == YCTSearchResultTypeUser){
        [self searchForUserList];
    }else{
        [self searchForVideoList];
    }
}

#pragma mark - requestMethod

- (void)loadMore{
    if (self.type == YCTSearchResultTypeUser) {
        [self searchForUserList];
    }else if (self.type == YCTSearchResultTypeVideo){
        [self searchForVideoList];
    }
}

- (void)searchForSynthesize{
    NSLog(@"搜索全部");
    if (self.page == 1) {
        [self.loadingSubject sendNext:@(YES)];
    }
    YCTApiSearch * api = [[YCTApiSearch alloc] initWithLocationId:self.locationId
                                                          keyword:self.keyword
                                                             page:self.page
                                                             type:YCTApiSearchTypeComprehensive];
    @weakify(self);
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        @strongify(self);
        YCTComprehensiveSearchModel * model = [api.responseDataModel isKindOfClass:[YCTComprehensiveSearchModel class]] ? api.responseDataModel : nil;
        self.users = YCTArray(model.companyInfo, @[]).copy;
        self.hotVideos = YCTArray(model.hotVideos, @[]).copy;
        self.videos = YCTArray(model.videos, @[]).copy;
        self.recommendVideos = YCTArray(model.tjVideos, @[]).copy;
       
        self.hotTitle = [NSString stringWithFormat:@"·%@",self.keyword];
        self.userTitle = YCTLocalizedTableString(@"search.vender", @"Home");
        self.videoTitle = YCTLocalizedTableString(@"search.production", @"Home");
        self.recommendTitle = YCTLocalizedTableString(@"search.recommend", @"Home");
        
        if (!YCT_IS_VALID_ARRAY(self.users) && !YCT_IS_VALID_ARRAY(self.hotVideos) &&  !YCT_IS_VALID_ARRAY(self.videos)) {
            [self.nodataSubject sendNext:@""];
        }
        [self.loadingSubject sendNext:@(NO)];
        [self.reloadSubject sendNext:@(YES)];
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        
    }];
}

- (void)searchForVideoList{
    NSLog(@"搜索视频");
    if (self.page == 1) {
        [self.loadingSubject sendNext:@(YES)];
    }
    YCTApiSearch * api = [[YCTApiSearch alloc] initWithLocationId:self.locationId
                                                          keyword:self.keyword
                                                             page:self.page
                                                             type:YCTApiSearchTypeVideo];
    @weakify(self);
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSLog(@"搜索视频回调：%@",request.responseString);
        @strongify(self);
        if (self.page == 1) {
            [self resetModel];
        }
        NSMutableArray * temp = self.videos.mutableCopy;
       
        NSArray * resultArray = YCTArray(api.responseDataModel, @[]).copy;
        [temp addObjectsFromArray:resultArray];
        self.videos = temp.copy;
        self.page ++;
        if (!YCT_IS_VALID_ARRAY(self.videos)) {
            [self.nodataSubject sendNext:@""];
        }
        [self.loadingSubject sendNext:@(NO)];
        [self.reloadSubject sendNext:@(resultArray.count < 20)];
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        [self.loadingSubject sendNext:@(NO)];
    }];
}

- (void)searchForUserList{
    NSLog(@"搜索用户");
    if (self.page == 1) {
        [self.loadingSubject sendNext:@(YES)];
    }
    YCTApiSearch * api = [[YCTApiSearch alloc] initWithLocationId:self.locationId
                                                          keyword:self.keyword
                                                             page:self.page
                                                             type:YCTApiSearchTypeUser];
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        if (self.page == 1) {
            [self resetModel];
        }
        NSMutableArray * temp = self.users.mutableCopy;
        NSArray * resultArray = YCTArray(api.responseDataModel, @[]).copy;
        [temp addObjectsFromArray:resultArray];
        self.users = temp.copy;
        self.page ++;
        if (!YCT_IS_VALID_ARRAY(self.users)) {
            [self.nodataSubject sendNext:@""];
        }
        [self.loadingSubject sendNext:@(NO)];
        [self.reloadSubject sendNext:@(resultArray.count < 20)];
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        [self.loadingSubject sendNext:@(NO)];
    }];
}

- (void)resetModel{
    self.users = @[];
    self.hotVideos = @[];
    self.videos = @[];
    self.recommendVideos = @[];
}
#pragma mark - getter
- (NSArray<YCTSearchUserModel *> *)users{
    if (!_users) {
        _users = @[];
    }
    return _users;
}

- (NSArray<YCTVideoModel *> *)hotVideos{
    if (!_hotVideos) {
        _hotVideos = @[];
    }
    return _hotVideos;
}

- (NSArray<YCTVideoModel *> *)videos{
    if (!_videos) {
        _videos = @[];
    }
    return _videos;
}

- (NSArray<YCTVideoModel *> *)recommendVideos{
    if (!_recommendVideos) {
        _recommendVideos = @[];
    }
    return _recommendVideos;
}

- (RACSubject *)reloadSubject{
    if (!_reloadSubject) {
        _reloadSubject = [RACSubject subject];
    }
    return _reloadSubject;
}

- (RACSubject *)nodataSubject{
    if (!_nodataSubject) {
        _nodataSubject = [RACSubject subject];
    }
    return _nodataSubject;
}
@end

@interface YCTSearchViewModel ()

@property (nonatomic, copy, readwrite) NSArray<NSString *> * historyKeys;
@property (nonatomic, copy, readwrite) NSArray * guessKeys;

@end

@implementation YCTSearchViewModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup{
    self.isHistoryFold = YES;
    NSArray * historyKeywords = YCTArray([[YCTKeyValueStorage defaultStorage] objectForKey:k_store_search_history_keyword ofClass:[NSArray class]], @[]).copy;
    self.historyKeys = historyKeywords.copy;
    [self requestForHotSearch];
    [self requestForCateSearch];
    [self requestForWantSearch];
   
    [RACObserve([YCTUserDataManager sharedInstance], locationId) subscribeNext:^(id  _Nullable x) {
        self.locationId = x;
    }];
    
    [RACObserve([YCTUserDataManager sharedInstance], locationCity) subscribeNext:^(id  _Nullable x) {
        self.locationName = x ? x : YCTLocalizedTableString(@"search.selectedArea", @"Home");
    }];
}

#pragma mark - requestMethod
- (void)searchWithKeyword:(NSString *)keyword{
    if(![keyword isEqual:@""]){
        NSMutableArray * historyKeywords = YCTArray([[YCTKeyValueStorage defaultStorage] objectForKey:k_store_search_history_keyword ofClass:[NSArray class]], @[]).mutableCopy;
        if([historyKeywords containsObject:keyword]){
            [historyKeywords removeObject:keyword];
        }
        [historyKeywords insertObject:keyword atIndex:0];
        [[YCTKeyValueStorage defaultStorage] setObject:historyKeywords.copy forKey:k_store_search_history_keyword];
        self.historyKeys = historyKeywords.copy;
    }
    
}

- (void)clearHistoryKeys{
    NSMutableArray * historyKeywords = YCTArray([[YCTKeyValueStorage defaultStorage] objectForKey:k_store_search_history_keyword ofClass:[NSArray class]], @[]).mutableCopy;
    [historyKeywords removeAllObjects];
    [[YCTKeyValueStorage defaultStorage] setObject:historyKeywords.copy forKey:k_store_search_history_keyword];
    self.historyKeys = historyKeywords.copy;
}

- (void)requestForWantSearch{
    YCTApiWantSearch * api = [[YCTApiWantSearch alloc] init];
    @weakify(self);
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        @strongify(self);
        NSArray * wantSearchKeys = [request.responseObject valueForKeyPath:@"data.keyWord"];
        self.wantSearchKeys = wantSearchKeys.copy;
        NSLog(@"wantsearch:%@",wantSearchKeys);
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
            
    }];
}
-(void)requestForHotSearch{
    YCTApiHotSearch * api = [[YCTApiHotSearch alloc] init];
    @weakify(self);
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        @strongify(self);
        NSArray * hotSearchKeys = [request.responseObject valueForKeyPath:@"data.tagText"];
        NSLog(@"hotsearch:%@",hotSearchKeys);
    
        self.hotSearchKeys = hotSearchKeys.copy;
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
            
    }];
}
-(void)requestForCateSearch{
    YCTApiCateSearch * api = [[YCTApiCateSearch alloc] init];
    @weakify(self);
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        @strongify(self);
        NSMutableArray<YCTCatesModel *>*models=[NSMutableArray array];
        NSDictionary *res=request.responseObject;
        int code=[[res objectForKey:@"code"] intValue];
        if(code!=1){
            return;
        }
        NSArray *data=[res objectForKey:@"data"];
        for(int i=0;i<data.count;i++){
            NSDictionary *item=data[i];
            YCTCatesModel *m1=[[YCTCatesModel alloc] initWithDic:item level:1 pid:0 pname:@"" ppid:0 ppname:@""];
            [models addObject:m1];
        }
        self.cateKeys = models.copy;
//        NSArray * cateSearchKeys = [request.responseObject valueForKeyPath:@"data.name"];
//        NSMutableArray<NSString *>*keys=[NSMutableArray array];
//        for(int i=0;i<cateSearchKeys.count;i++){
//            NSString *key=cateSearchKeys[i];
//            if([key isEqual:[NSNull null]]){
//                key=@"null";
//            }
//            [keys addObject:key];
//        }
//        NSLog(@"cateSearchKeys:%@",cateSearchKeys);
//
//        self.cateKeys = keys.copy;
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
            
    }];
}
@end
