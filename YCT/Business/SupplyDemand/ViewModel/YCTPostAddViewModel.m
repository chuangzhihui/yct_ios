//
//  YCTPostAddViewModel.m
//  YCT
//
//  Created by 木木木 on 2021/12/27.
//

#import "YCTPostAddViewModel.h"
#import "YCTApiGXTags.h"
#import "YCTApiPublishGX.h"
#import "YCTApiUpdateGX.h"

@interface YCTPostAddViewModel ()
@property (nonatomic, strong, readwrite) RACSubject *loadTagsSubject;
@property (nonatomic, copy, readwrite) NSArray<YCTGXTag *> *tags;

@property (nonatomic, assign) YCTPostType type;
@property (nonatomic, strong) YCTMyGXListModel *model;

@property (nonatomic, copy) NSArray *imgs;
@end

@implementation YCTPostAddViewModel

- (instancetype)init {
    self = [super init];
    if (self) {
        self.loadTagsSubject = [RACSubject subject];
        self.imageModelUtil = [YCTImageModelUtil new];
    }
    return self;
}

- (instancetype)initWithType:(YCTPostType)type {
    self = [self init];
    if (self) {
        self.type = type;
    }
    return self;
}

- (instancetype)initWithModel:(YCTMyGXListModel *)model {
    self = [self init];
    if (self) {
        self.type = model.type;
        self.model = model;
    }
    return self;
}

- (void)requestTags {
    [self.loadingSubject sendNext:@(YES)];
    YCTApiGXTags *api = [[YCTApiGXTags alloc] initWithType:_type];
    [api startWithCompletionBlockWithSuccess:^(__kindof YCTBaseRequest * _Nonnull request) {
        if (YCT_IS_ARRAY(request.responseDataModel)) {
            self.tags = request.responseDataModel;
        }
        [self.loadTagsSubject sendNext:@(YES)];
        [self.loadingSubject sendNext:@(NO)];
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        [self.loadTagsSubject sendNext:@(YES)];
        [self.loadingSubject sendNext:@(NO)];
    }];
}

- (void)submitPost {
    [self.loadingSubject sendNext:@(YES)];
    if (self.imageModelUtil.count > 0) {
        @weakify(self);
        [self.imageModelUtil fetchImageUrlWithCompletion:^(NSArray * _Nullable imageUrls) {
            @strongify(self);
            self.imgs = imageUrls.copy;
            if (self.model) {
                [self requestUpdateSubmitPost];
            } else {
                [self requestNewSubmitPost];
            }
        }];
    } else {
        if (self.model) {
            [self requestUpdateSubmitPost];
        } else {
            [self requestNewSubmitPost];
        }
    }
}

- (void)requestUpdateSubmitPost {
    YCTApiUpdateGX *api = [[YCTApiUpdateGX alloc] initWithGXId:self.model.identifier title:self.title imgs:self.imgs mobile:self.mobile address:self.address locationId:self.locationId goodstype:self.goodstype tagTexts:self.tagTexts];
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        [self.loadAllDataSubject sendNext:@(YES)];
        [self.loadingSubject sendNext:@(NO)];
    } failure:^(YCTApiPublishGX * _Nonnull request) {
        [self.netWorkErrorSubject sendNext:request.getError];
    }];
}

- (void)requestNewSubmitPost {
    YCTApiPublishGX *api = [[YCTApiPublishGX alloc] initWithType:self.type title:self.title imgs:self.imgs mobile:self.mobile address:self.address locationId:self.locationId goodstype:self.goodstype tagTexts:self.tagTexts];
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        [self.loadAllDataSubject sendNext:@(YES)];
        [self.loadingSubject sendNext:@(NO)];
    } failure:^(YCTApiPublishGX * _Nonnull request) {
        [self.netWorkErrorSubject sendNext:request.getError];
    }];
}

@end
