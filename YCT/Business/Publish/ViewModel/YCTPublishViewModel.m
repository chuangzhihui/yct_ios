//
//  YCTPublishViewModel.m
//  YCT
//
//  Created by hua-cloud on 2022/1/6.
//

#import "YCTPublishViewModel.h"
#import "YCTApiGetVideoUploadToken.h"
#import "TXUGCPublish.h"
#import "YCTApiPublishVideo.h"
#import "YCTApiGetVideoTags.h"
#import "YCTUGCWrapper.h"
#import "YCTApiApplyVideo.h"
#import <TXLiteAVSDK_UGC/TXLiteAVSDK.h>

@interface YCTPublishViewModel()<TXVideoPublishListener>

@property (nonatomic, strong) NSURLSessionTask * topicTask;
@property (nonatomic, copy) NSString * videoUrl;
@property (nonatomic, copy) NSString * coverUrl;
@property (nonatomic, assign) YCTPublishType publishType;
@end

@implementation YCTPublishViewModel
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.visibleType = YCTPublishVisibleTypePublic;
        self.submitTopicTags = @"";
        self.content = @"";
        self.locationId = @"";
        self.allowSave = YES;
        self.allowShare = YES;
        self.landscape = NO;
        [self bindModel];
    }
    return self;
}

- (void)bindModel{
    self.musicId = [YCTUGCWrapper sharedInstance].getEditingBgmId;
    RAC(self,visibleTitle) = [RACObserve(self, visibleType) map:^id _Nullable(id  _Nullable value) {
        if ([value integerValue] == YCTPublishVisibleTypePublic) {
            return YCTLocalizedTableString(@"publish.allVisible", @"Publish");
        }else if ([value integerValue] == YCTPublishVisibleTypeFriend){
            return YCTLocalizedTableString(@"publish.friendVisible", @"Publish");
        }else{
            return YCTLocalizedTableString(@"publish.privacy", @"Publish");
        }
    }];
    
    @weakify(self);
    [[RACObserve(self, draftVideModel) ignore:nil] subscribeNext:^(YCTPublishVideoModel *  _Nullable x) {
        @strongify(self);
        self.locationId = [NSString stringWithFormat:@"%ld",x.locationId];
        self.locationName = x.address;
        self.allowShare = x.allowShare;
        self.allowSave = x.allowSave;
        self.videoUrl = x.videoUrl;
        self.coverUrl = x.thumbUrl;
        self.musicId = x.musicId;
        self.goodsType = x.goodstype;
        self.landscape = x.hengping == 1;
    }];
}

- (void)publishWithType:(YCTPublishType)type{
    
    if([self.goodsType isEqualToString:@""] || self.goodsType==NULL){
        [[YCTHud sharedInstance] showToastHud:YCTLocalizedTableString(@"publish.goodsTypeP",@"Publish")];
        return;
    }
    self.publishType = type;
    if (self.publishType != YCTPublishTypePublishDraft) {
        [self uploadVideoAndPublish];
    }else{
        [self requestPublish];
    }
}

- (void)uploadVideoAndPublish{
    YCTApiGetVideoUploadToken * upToken = [[YCTApiGetVideoUploadToken alloc] init];
    @weakify(self);
    [upToken startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        @strongify(self);
        NSString *coverPath;
        NSLog(@"这里来了1111？");
        if (self.videoCoverImage) {
            coverPath = [NSTemporaryDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"videoPublicCover.png"]];
            NSData *data = UIImageJPEGRepresentation(self.videoCoverImage, 0.5);
            [data writeToFile:coverPath atomically:YES];
        }
        TXUGCPublish *videoPublish = [[TXUGCPublish alloc] initWithUserID:@""];
        videoPublish.delegate = self;
        TXPublishParam *publishParam = [[TXPublishParam alloc] init];
        publishParam.signature  = request.responseObject[@"data"][@"token"];
        publishParam.videoPath  = self.ugcResult.media.videoPath;
        publishParam.coverPath  = coverPath;
        NSLog(@"这里来了222？");
        [videoPublish publishVideo:publishParam];
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        [self.toastSubject sendNext:[upToken getError]];
    }];
}

- (void)requestPublish{
    [[YCTHud sharedInstance] showLoadingHud];
    TXVideoInfo * info = [TXVideoInfoReader getVideoInfoWithAsset:self.ugcResult.media.videoAsset];
    self.musicId = self.musicId ? : [YCTUGCWrapper sharedInstance].getEditingBgmId;
    NSString * videoTime = [NSString stringWithFormat:@"%ld",self.draftVideModel ? self.draftVideModel.videoTime : (NSInteger)info.duration];
    NSLog(@"videotime:%@",videoTime);
    int type=[YCTUserDataManager sharedInstance].user_type;
    YCTApiPublishVideo * api = [[YCTApiPublishVideo alloc] initWithTagTexts:self.submitTopicTags ? : @""
                                                                    musicId:YCTString(self.musicId, @"0")
                                                                   videoUrl:self.videoUrl
                                                                   thumbUrl:self.coverUrl
                                                                      title:self.content
                                                                 locationId:[self.locationId integerValue]
                                                                     status:self.publishType == YCTPublishTypePublish || self.publishType == YCTPublishTypePublishDraft ? @"1" : @"0"
                                                                  allowSave:self.allowSave
                                                                 allowShare:self.allowShare
                                                                  videoTime:videoTime
                                                                     isEdit:self.publishType == YCTPublishTypePublishDraft
                                                                    videoId:self.draftVideModel.id
                                                                  goodstype:self.goodsType
                                                                   hengping:self.landscape ? 1 : 0
                                                                       type:type];
   
    @weakify(self);
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        @strongify(self);
        [[YCTHud sharedInstance] hideHud];
        NSLog(@"type:%ld----YCTPublishTypePublish:%ld----YCTPublishTypeSaveDraft:%ld",(long)self.publishType,(long)YCTPublishTypePublish,(long)YCTPublishTypeSaveDraft);
        if(self.publishType == YCTPublishTypePublish){
            [self.publishCompletion sendNext:@""];
        }else if(self.publishType == YCTPublishTypeSaveDraft){
            [self.saveDraftCompletion sendNext:@""];
        }else{
            [self.publishCompletion sendNext:@""];
//            [self requestForPublishDraft];
        }
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSLog(@"发布回调:%@",request.responseString);
        [[YCTHud sharedInstance] showFailedHud:[api getError]];
    }];
}

- (void)requestForPublishDraft{
    YCTApiApplyVideo * api = [[YCTApiApplyVideo alloc] initWithVideoId:self.draftVideModel.id];
    @weakify(self);
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        @strongify(self);
        [self.publishCompletion sendNext:@""];
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSLog(@"报错了？%@",request.responseString);
        [[YCTHud sharedInstance] showFailedHud:[api getError]];
    }];
}


- (void)requestForTopicTagWithText:(NSString *)text{
    if (self.topicTask) {
        [self.topicTask cancel];
    }
    YCTApiGetVideoTags * api = [[YCTApiGetVideoTags alloc] initWithTagText:text];
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSMutableArray * array = @[].mutableCopy;
        if (text.length > 1) [array addObject:text];
        NSArray * temp = YCT_IS_VALID_ARRAY(request.responseObject[@"data"]) ? [request.responseObject[@"data"] valueForKey:@"tagText"] : @[];
        [array addObjectsFromArray:temp];
        self.topicTags = array.copy;
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
            
    }];
    self.topicTask = api.requestTask;
}

#pragma mark - TXVideoPublishListener
- (void)onPublishProgress:(NSInteger)uploadBytes totalBytes:(NSInteger)totalBytes {
    dispatch_async(dispatch_get_main_queue(), ^{
        [[YCTHud sharedInstance] showLoadingHud];
    });
}

- (void)onPublishComplete:(TXPublishResult*)result {
    NSLog(@"onPublishComplete [%d/%@]", result.retCode, result.retCode == 0? result.videoURL: result.descMsg);
    dispatch_async(dispatch_get_main_queue(), ^{
        if (result.retCode == 0) {
            self.videoUrl = result.videoURL;
            self.coverUrl = result.coverURL;
            NSLog(@"这里来了？");
            [self requestPublish];
        }else{
            [[YCTHud sharedInstance] showFailedHud:YCTLocalizedString(@"request.error")];
        }
    });
}
-(void)onPublishEvent:(NSDictionary *)evt{
    NSLog(@"上传evt:%@",evt);
}
#pragma mark - getter
- (RACSubject *)publishCompletion{
    if (!_publishCompletion) {
        _publishCompletion = [RACSubject subject];
    }
    return _publishCompletion;
}

- (RACSubject *)saveDraftCompletion{
    if (!_saveDraftCompletion) {
        _saveDraftCompletion = [RACSubject subject];
    }
    return _saveDraftCompletion;
}
@end
