//
//  YCTHomeHotSubViewModel.m
//  YCT
//
//  Created by hua-cloud on 2021/12/12.
//

#import "YCTHomeHotSubViewModel.h"



@interface YCTHomeHotListItemViewModel()
@property (nonatomic, assign, readwrite) BOOL rankIconHidden;
@property (nonatomic, assign, readwrite) BOOL titleIconHidden;
@property (nonatomic, assign, readwrite) BOOL rankNumHidden;

@property (nonatomic, strong, readwrite) UIImage * rankImage;
@property (nonatomic, strong, readwrite) UIImage * titleIconImage;
@property (nonatomic, copy, readwrite) NSString * rankNum;
@property (nonatomic, copy, readwrite) NSString * title;
@property (nonatomic, copy, readwrite) NSString * hotNum;
@property (nonatomic, copy, readwrite) NSString * avatar;



@property (nonatomic, assign) NSInteger index;
@property (nonatomic, assign) bool hasTop;

@end


@implementation YCTHomeHotListItemViewModel
- (instancetype)initWithHotModel:(YCTTagsModel *)model index:(NSInteger)index hasTop:(BOOL)hasTop{
    if (self = [super init]) {
        self.index = index;
        self.hasTop = hasTop;
        self.hotModel = model;
        self.isCo = NO;
        [self setup];
    }
    return self;
}

- (instancetype)initWithCoModel:(YCTSearchUserModel *)model index:(NSInteger)index hasTop:(BOOL)hasTop{
    if (self = [super init]) {
        self.index = index;
        self.hasTop = hasTop;
        self.coModel = model;
        self.isCo = YES;
        self.userId = model.userId;
        [self setup];
    }
    return self;
}

- (void)setup{
    self.rankImage = ({
        NSInteger iconIndex = self.hasTop ? self.index : self.index + 1;
        UIImage * image = iconIndex <= 3 ? [UIImage imageNamed:[NSString stringWithFormat:@"home_rank_%ld",iconIndex]] : nil;
        image;
    });
    self.titleIconImage = nil;
    self.rankNum = [NSString stringWithFormat:@"%ld",self.hasTop ? self.index : self.index + 1];
    if (self.hotModel) {
//        self.title = self.hotModel.tagText.length > 1 ? [self.hotModel.tagText substringWithRange:NSMakeRange(1, self.hotModel.tagText.length - 1)] : self.hotModel.tagText;
        self.title=self.hotModel.tagText;
        self.hotNum = [NSString handledCountNumberIfMoreThanTenThousand:self.hotModel.playNum];
    }else{
        self.title = self.coModel.nickName;
        self.avatar = self.coModel.avatar;
        self.hotNum = [NSString handledCountNumberIfMoreThanTenThousand:[self.coModel.playNum integerValue]];
    }
}


@end

@interface YCTHomeHotSubViewModel()

@property (nonatomic, copy, readwrite) NSArray<YCTHomeHotListItemViewModel *> * cellViewModels;
@property (nonatomic, assign) BOOL hasTop;
@property (nonatomic, assign) YCTHotTagType type;
@end

@implementation YCTHomeHotSubViewModel

- (instancetype)initWithType:(YCTHotTagType)type{
    if (self = [super init]) {
        self.type = type;
        [self setup];
    }
    return self;
}

- (void)setup{
    if (self.type == YCTHotTagTypeHot) {
        [self requestForHot];
    }else{
        [self requestForCo];
    }
}

#pragma mark - requestMethod
- (void)requestForCo{
    NSMutableArray * array = @[].mutableCopy;
    YCTApiGetHotCompanyList * hotCo = [[YCTApiGetHotCompanyList alloc] init];
    @weakify(self);
    [hotCo startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        @strongify(self);
        NSArray * result = YCTArray(hotCo.responseDataModel, @[]);
        [result enumerateObjectsUsingBlock:^(YCTSearchUserModel *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            YCTHomeHotListItemViewModel * item = [[YCTHomeHotListItemViewModel alloc] initWithCoModel:obj index:self.hasTop ? idx + 1 : idx hasTop:self.hasTop];
            [array addObject:item];
        }];
        self.cellViewModels = array.copy;
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        
    }];
}

- (void)requestForHot{
    NSMutableArray * array = @[].mutableCopy;
    YCTApiGetHotTopTag * topTag = [[YCTApiGetHotTopTag alloc] init];
    @weakify(self);
    [topTag startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        @strongify(self);
        NSString * tag = YCTString(request.responseObject[@"data"][@"tag"], @"");
        if (YCT_IS_VALID_STRING(tag)) {
            self.hasTop = YES;
            YCTTagsModel * top = [[YCTTagsModel alloc] init];
            top.tagText = tag;
            YCTHomeHotListItemViewModel * item = [[YCTHomeHotListItemViewModel alloc] initWithHotModel:top index:0 hasTop:YES];
            [array addObject:item];
        }
        [self requestForHotListWithArray:array];
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        
    }];
}

- (void)requestForHotListWithArray:(NSMutableArray *)array{
    YCTApiGetHotList * api = [[YCTApiGetHotList alloc] init];
    @weakify(self);
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        @strongify(self);
        NSArray * result = YCTArray(api.responseDataModel, @[]);
       
        [result enumerateObjectsUsingBlock:^(YCTTagsModel *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSLog(@"热搜%@____%@",request.responseString,obj.tagText);
            YCTHomeHotListItemViewModel * item = [[YCTHomeHotListItemViewModel alloc] initWithHotModel:obj index:self.hasTop ? idx + 1 : idx hasTop:self.hasTop];
            NSLog(@"txt:%@",item.title);
            [array addObject:item];
        }];
        self.cellViewModels = array.copy;
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        
    }];
}
@end
