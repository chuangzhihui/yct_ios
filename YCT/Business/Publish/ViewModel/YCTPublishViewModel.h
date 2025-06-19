//
//  YCTPublishViewModel.h
//  YCT
//
//  Created by hua-cloud on 2022/1/6.
//

#import "YCTBaseViewModel.h"
#import "YCTVideoModel.h"
#import "YCTPublishVideoModel.h"
#import <UGCKit/UGCKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSInteger, YCTPublishType) {
    YCTPublishTypeSaveDraft,//保存到草稿箱
    YCTPublishTypePublishDraft,//发布草稿箱视频
    YCTPublishTypePublish//发布视频
};

typedef NS_ENUM(NSInteger, YCTPublishVisibleType) {
    YCTPublishVisibleTypePublic = 0,
    YCTPublishVisibleTypeFriend = 1,
    YCTPublishVisibleTypeSelf = 2,
};
@interface YCTPublishViewModel : YCTBaseViewModel

@property (nonatomic, strong) UGCKitResult * ugcResult;
@property (nonatomic, strong) YCTPublishVideoModel * draftVideModel;
@property (nonatomic, strong) UIImage * videoCoverImage;
@property (nonatomic, copy) NSString * content;
@property (nonatomic, copy) NSString * locationId;
@property (nonatomic, copy) NSString * locationName;
@property (nonatomic, copy) NSString * visibleTitle;
@property (nonatomic, copy) NSString * submitTopicTags;
@property (nonatomic, copy) NSString * musicId;
@property (nonatomic, copy) NSString * goodsType;
@property (nonatomic, assign) YCTPublishVisibleType visibleType;
@property (nonatomic, assign) bool allowSave;
@property (nonatomic, assign) bool allowShare;
@property (nonatomic, assign) bool landscape;

@property (nonatomic, copy) NSArray * topicTags;

@property (nonatomic, strong) RACSubject * publishCompletion;
@property (nonatomic, strong) RACSubject * saveDraftCompletion;

- (void)publishWithType:(YCTPublishType)type;
- (void)requestForTopicTagWithText:(NSString *)text;
@end

NS_ASSUME_NONNULL_END
