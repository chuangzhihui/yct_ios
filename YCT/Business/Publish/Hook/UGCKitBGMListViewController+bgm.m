//
//  UGCKitBGMListViewController+bgm.m
//  YCT
//
//  Created by hua-cloud on 2022/1/6.
//

#import "UGCKitBGMListViewController+bgm.h"
#import "YCTApiVideoGetMusics.h"
#import "YCTApiVideoGetMusicsUseAiList.h"

#define BGM_LOCAL_PATH [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/bgm/bgm_list.json"]
@interface UGCKitBGMListViewController()
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, assign) NSArray<YCTBgmMusicModel *> * musics;
@property (nonatomic, assign) NSInteger aiPage;
@property (nonatomic, assign) NSArray<YCTBgmMusicModel *> * aiMusics;
@end

@implementation UGCKitBGMListViewController (bgm)

+(void)load{
    Method onBGMDownLoad = class_getInstanceMethod(self.class, NSSelectorFromString(@"onBGMDownLoad:"));
    Method yct_onBGMDownLoad = class_getInstanceMethod(self.class, @selector(yct_onBGMDownLoad:));
    method_exchangeImplementations(onBGMDownLoad, yct_onBGMDownLoad);
    
    Method viewDidLoad = class_getInstanceMethod(self.class, NSSelectorFromString(@"viewDidLoad"));
    Method yct_viewDidLoad = class_getInstanceMethod(self.class, @selector(yct_viewDidLoad));
    method_exchangeImplementations(viewDidLoad, yct_viewDidLoad);
    
    Method deleteAiBgmWithIndex = class_getInstanceMethod(self.class, NSSelectorFromString(@"deleteAiBgmWithIndex:taskId:"));
    Method yct_deleteAiBgmWithIndex = class_getInstanceMethod(self.class, @selector(yct_deleteAiBgmWithIndex:taskId:));
    method_exchangeImplementations(deleteAiBgmWithIndex, yct_deleteAiBgmWithIndex);
}

- (void)setPage:(NSInteger)page{
    objc_setAssociatedObject(self, @selector(setPage:), @(page), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSInteger)page{
    return [objc_getAssociatedObject(self, @selector(setPage:)) integerValue];
}
- (void)setAiPage:(NSInteger)aiPage {
    objc_setAssociatedObject(self, @selector(setAiPage:), @(aiPage), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (NSInteger)aiPage {
    return [objc_getAssociatedObject(self, @selector(setAiPage:)) integerValue];
}

- (void)setMusics:(NSArray<YCTBgmMusicModel *> *)musics{
    objc_setAssociatedObject(self, @selector(setMusics:), musics, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (NSArray<YCTBgmMusicModel *> *)musics{
    return objc_getAssociatedObject(self, @selector(setMusics:));
}

- (void)setAiMusics:(NSArray<YCTBgmMusicModel *> *)aiMusics {
    objc_setAssociatedObject(self, @selector(setAiMusics:), aiMusics, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (NSArray<YCTBgmMusicModel *> *)aiMusics {
    return objc_getAssociatedObject(self, @selector(setAiMusics:));
}

- (void)yct_viewDidLoad{
    [self yct_viewDidLoad];
    @weakify(self);
    self.tableView.mj_header = [YCTRefreshHeader headerWithRefreshingBlock:^{
        @strongify(self);
        if (self.switchVw.index == 1) {
            self.page = 1;
        } else {
            self.aiPage = 1;
        }
        [self loadBGMList];
    }];
    
    self.tableView.mj_footer = [YCTRefreshFooter footerWithRefreshingBlock:^{
        @strongify(self);
        [self loadBGMList];
    }];
}



- (void)requestForMusicWithCompletion:(void(^)(NSArray * array))completion{
    self.page = self.page < 1 ? 1 : self.page;
    YCTApiVideoGetMusics * api = [[YCTApiVideoGetMusics alloc] initWithPage:self.page];
    @weakify(self);
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        @strongify(self);
        NSMutableArray<YCTBgmMusicModel *> * temp = self.musics ? self.musics.mutableCopy : @[].mutableCopy;
        NSArray * resultModels = api.responseDataModel;
        if (self.page == 1) [temp removeAllObjects];
        [temp addObjectsFromArray:resultModels];
        self.page += 1;
        self.musics = temp.copy;
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        !completion ? : completion(request.responseObject[@"data"]);
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        
    }];
}

- (void)requestForAiMusicWithCompletion:(void(^)(NSArray * array))completion{
    self.aiPage = self.aiPage < 1 ? 1 : self.aiPage;
    YCTApiVideoGetMusicsUseAiList * api = [[YCTApiVideoGetMusicsUseAiList alloc] initWithPage:self.aiPage];
    @weakify(self);
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        @strongify(self);
        NSMutableArray *temp = self.aiMusicArr ? self.aiMusicArr.mutableCopy : @[].mutableCopy;
        NSArray * resultModels = request.responseObject[@"data"];
        if (self.aiPage == 1) [temp removeAllObjects];
        [temp addObjectsFromArray:resultModels];
        self.aiPage += 1;
        self.aiMusicArr = temp.copy;
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        !completion ? : completion(self.aiMusicArr);
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        
    }];
}

- (void)deleteForAiMusicWithIndex:(NSInteger)index taskId:(NSString *)taskId completion:(void(^)(NSArray * array))completion{
    [[YCTHud sharedInstance] showLoadingHud];
    YCTApiVideoGetMusicsUseAiList * api = [[YCTApiVideoGetMusicsUseAiList alloc] initWithTaskId:taskId];
    @weakify(self);
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        @strongify(self);
//        [self.aiMusicArr removeObjectAtIndex:index];
        [[YCTHud sharedInstance] hideHud];
        !completion ? : completion(self.aiMusicArr);
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSLog(@"请求主页数据失败：%@",request.requestUrl);
        NSLog(@"请求主页数据失败：%@",request.responseString);
        [[YCTHud sharedInstance] showFailedHud:@"删除失败"];
    }];
}

//reload
- (void)loadBGMList{
    if (self.switchVw.index == 1) {
        @weakify(self);
        [self requestForMusicWithCompletion:^(NSArray *array) {
            @strongify(self);
            UGCKitBGMHelper * bgmHelper = [UGCKitBGMHelper sharedInstance];
            [self setValue:bgmHelper forKey:@"bgmHelper"];
            [bgmHelper setDelegate:self];
            [bgmHelper initBGMListWithJsonDictArray:array];
        }];
    } else {
//        @weakify(self);
        [self requestForAiMusicWithCompletion:^(NSArray *array) {
//            @strongify(self);
            UGCKitBGMHelper * bgmHelper = [UGCKitBGMHelper sharedInstance];
//            [self setValue:bgmHelper forKey:@"bgmHelper"];
//            [bgmHelper setDelegate:self];
            [bgmHelper initBGMAiListWithJsonDictArray:array];
        }];
    }
    
}

- (void)yct_onBGMDownLoad:(UITableViewCell *)cell{
    [self yct_onBGMDownLoad:cell];
    
//    TCBGMElement* ele = bgmDict[bgmKeys[indexPath.row]];
//    if([ele isValid] && [[NSFileManager defaultManager] fileExistsAtPath:[NSHomeDirectory() stringByAppendingPathComponent:[ele localUrl]]]){
// 
//    }
}

- (void)yct_deleteAiBgmWithIndex:(NSInteger)index taskId:(NSString *)taskId {
    @weakify(self);
    [self deleteForAiMusicWithIndex:index taskId:taskId completion:^(NSArray *array) {
        @strongify(self);
//        UGCKitBGMHelper * bgmHelper = [UGCKitBGMHelper sharedInstance];
//        [bgmHelper initBGMAiListWithJsonDictArray:array];
        [self yct_deleteAiBgmWithIndex:index taskId:taskId];
    }];
}

@end
