//
//  YCTCommentViewModel.m
//  YCT
//
//  Created by hua-cloud on 2022/1/8.
//

#import "YCTCommentViewModel.h"
#import "NSString+Common.h"
#import "YCTApiBlacklist.h"
@interface YCTCommentItemViewModel()
@property (nonatomic, copy, readwrite) NSString * avatarUrl;
@property (nonatomic, copy, readwrite) NSString * nikeName;
@property (nonatomic, copy, readwrite) NSString * content;
@property (nonatomic, copy, readwrite) NSString * publishTime;
@property (nonatomic, copy, readwrite) NSString * zanCount;
@property (nonatomic, copy, readwrite) NSString * replyNickName;
@property (nonatomic, copy, readwrite) NSString * markTag;
@property (nonatomic, strong, readwrite) UIColor * markTagColor;

@property (nonatomic, assign, readwrite) BOOL isZaning;
@property (nonatomic, assign, readwrite) BOOL isZan;
@property (nonatomic, assign, readwrite) BOOL isMe;
@property (nonatomic, assign, readwrite) BOOL fold;

@property (nonatomic, copy, readwrite)NSArray<YCTCommentItemViewModel *> * subComment;


@property (nonatomic, copy) NSString * videoId;
@end

@implementation YCTCommentItemViewModel

- (instancetype)initWithModel:(YCTCommentModel *)model
{
    self = [super init];
    if (self) {
        self.commentModel = model;
        self.fold = YES;
        [self bindModel];
    }
    return self;
}

- (void)bindModel{
    self.fold = self.commentModel.sonNum > 0;
    self.avatarUrl = self.commentModel.avatar;
    self.nikeName = self.commentModel.nickName;
    self.content = self.commentModel.content;
    self.publishTime = [NSString publishTimeWithStamp:self.commentModel.atime];
    self.replyNickName = YCTString(self.commentModel.pnickNames, @"");
    self.isZan = self.commentModel.isZan == 1;
    self.markTag = self.commentModel.isMe == 1 ? YCTLocalizedTableString(@"comment.me", @"Home") : self.commentModel.isAuthor == 1 ? YCTLocalizedTableString(@"comment.author", @"Home") : @"";
    self.markTagColor = self.commentModel.isMe == 1 ? UIColor.mainThemeColor : self.commentModel.isAuthor == 1 ? UIColorFromRGB(0xFE2B54) : UIColor.clearColor;
    @weakify(self);
    [RACObserve(self.commentModel, zanNum) subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        self.zanCount = [NSString handledCountNumberIfMoreThanTenThousand:self.commentModel.zanNum];
    }];
    
    
}

- (void)requestForSubComment{
    YCTApiGetCommentList * api = [[YCTApiGetCommentList alloc] initSecondWithPid:self.commentModel.id];
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSLog(@"评论请求回调:%@",request.responseString);
        NSMutableArray * temp = @[].mutableCopy;
        NSArray<YCTCommentModel *> * resultArray = YCTArray(api.responseDataModel, @[]);
        [resultArray enumerateObjectsUsingBlock:^(YCTCommentModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            YCTCommentItemViewModel * viewModel = [[YCTCommentItemViewModel alloc] initWithModel:obj];
            [temp addObject:viewModel];
        }];
        self.fold = NO;
        self.subComment = temp.copy;
        
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        [[YCTHud sharedInstance] showToastHud:[api getError]];
    }];
}


- (void)requestForZan{
    self.isZaning = YES;
    YCTApiVideoZanComment * api = [[YCTApiVideoZanComment alloc] initWithCommentId:self.commentModel.id];
    @weakify(self);
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        @strongify(self);
        self.isZan = !self.isZan;
        self.commentModel.zanNum = MAX(0, (self.commentModel.zanNum  + (self.isZan ? 1 : -1)));
        self.isZaning = NO;
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        self.isZaning = NO;
    }];
}

- (void)requestForBlackList{
    [self.loadingSubject sendNext:@(YES)];
    YCTApiHandleBlacklist * api = [[YCTApiHandleBlacklist alloc] initWithType:YCTHandleBlacklistTypeAdd userId:self.commentModel.userId];
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        [self.loadingSubject sendNext:@(NO)];
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        [self.toastSubject sendNext:[api getError]];
    }];
}

#pragma mark - getter
- (NSArray<YCTCommentItemViewModel *> *)subComment{
    if (!_subComment) {
        _subComment = @[];
    }
    return _subComment;
}
@end

@interface YCTCommentViewModel ()
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, copy) NSString * videoId;
@property (nonatomic, copy, readwrite) NSArray<YCTCommentItemViewModel *> * commentViewModels;
@property (nonatomic, copy) NSArray<YCTCommentModel *> * commentModels;

@end

@implementation YCTCommentViewModel
- (instancetype)initWithVideoId:(NSString *)videoId commentCount:(NSInteger)commentCount{
    if (self = [super init]) {
        self.videoId = videoId;
        self.commentCount = commentCount;
        [self bindModel];
        [self refresh];
    }
    return self;
}


- (void)bindModel{
    @weakify(self);
    [[RACObserve(self, commentModels) skip:1] subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        [self reformData];
    }];
}

- (void)reformData{
    NSMutableArray * commentArray = self.commentViewModels.mutableCopy;
    if (self.page == 1) {
        [commentArray removeAllObjects];
    }
       
    [self.commentModels enumerateObjectsUsingBlock:^(YCTCommentModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
       
        YCTCommentItemViewModel * viewModel = [[YCTCommentItemViewModel alloc] initWithModel:obj];
      
        [commentArray addObject:viewModel];
    }];
        
        //新增计算评论数
    int num=0;
    for(int i=0;i<commentArray.count;i++){
        YCTCommentItemViewModel * viewModel =commentArray[i];
        num+=viewModel.commentModel.sonNum;
    }
    self.commentCount=commentArray.count+num;
        //end
        
    self.commentViewModels = commentArray.copy;
}

- (void)refresh{
    self.page = 1;
    [self requestForCommentList];
}

- (void)loadMore{
    [self requestForCommentList];
}

- (void)requestForCommentList{
    if (self.page == 1) {
        [self.loadingSubject sendNext:@(YES)];
    }
    YCTApiGetCommentList * api = [[YCTApiGetCommentList alloc] initWithPage:self.page videoId:self.videoId];
    @weakify(self);
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSLog(@"刷新评论请求回调:%@",request.responseString);
        @strongify(self);
        [self.loadingSubject sendNext:@(NO)];
        NSMutableArray * temp = self.commentModels.mutableCopy;
        if (self.page == 1) {
            [temp removeAllObjects];
        }
        NSArray * models = YCTArray(api.responseDataModel,@[]);
        [temp addObjectsFromArray:models];
        self.commentModels = temp.copy;
        [self.endFooterRefreshSubject sendNext:@(models.count < 20)];
        [self reformData];
        self.page ++;
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        [self.loadingSubject sendNext:@(NO)];
    }];
}

- (void)setCommentViewModel:(YCTCommentItemViewModel *)commentViewModel{
    _commentViewModel = commentViewModel;
    self.subCommentViewModel = nil;
}

- (void)requestForPublishCommentWithContent:(NSString *)content{
    YCTCommentItemViewModel * current = self.subCommentViewModel ? : self.commentViewModel;
    YCTApiPublishComment * api = [[YCTApiPublishComment alloc] initWithVideoId:self.videoId pid:current.commentModel.id ? : @"0" content:content];
    @weakify(self);
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        @strongify(self);
        NSLog(@"评论请求回调:%@",request.responseString);
        if (self.commentViewModel) {
            [self.commentViewModel requestForSubComment];
        }else{
            [self refresh];
        }
        [[YCTHud sharedInstance] showToastHud:YCTLocalizedTableString(@"comment.success", @"Home")];
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        [self.loadingSubject sendNext:[api getError]];
    }];
}

#pragma mark - getter
- (NSArray<YCTCommentModel *> *)commentModels{
    if (!_commentModels) {
        _commentModels = [NSArray array];
    }
    return _commentModels;
}

- (NSArray<YCTCommentItemViewModel *> *)commentViewModels{
    if (!_commentViewModels) {
        _commentViewModels = @[];
    }
    return _commentViewModels;
}

- (RACSubject *)endFooterRefreshSubject{
    if (!_endFooterRefreshSubject) {
        _endFooterRefreshSubject = [RACSubject subject];
    }
    return _endFooterRefreshSubject;
}
@end
