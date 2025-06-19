//
//  YCTCommentViewModel.h
//  YCT
//
//  Created by hua-cloud on 2022/1/8.
//

#import "YCTBaseRequest.h"
#import "YCTApiGetCommentList.h"
#import "YCTApiPublishComment.h"
#import "YCTApiVideoZanComment.h"
NS_ASSUME_NONNULL_BEGIN

@interface YCTCommentItemViewModel : YCTBaseViewModel
@property (nonatomic, copy, readonly) NSString * avatarUrl;
@property (nonatomic, copy, readonly) NSString * nikeName;
@property (nonatomic, copy, readonly) NSString * content;
@property (nonatomic, copy, readonly) NSString * publishTime;
@property (nonatomic, copy, readonly) NSString * zanCount;
@property (nonatomic, copy, readonly) NSString * markTag;
@property (nonatomic, strong, readonly) UIColor * markTagColor;
@property (nonatomic, copy, readonly) NSString * replyNickName;
@property (nonatomic, strong)YCTCommentModel * commentModel;
@property (nonatomic, assign, readonly) BOOL isZaning;
@property (nonatomic, assign, readonly) BOOL isZan;
@property (nonatomic, assign, readonly) BOOL isMe;
@property (nonatomic, assign, readonly) BOOL fold;

@property (nonatomic, copy, readonly)NSArray<YCTCommentItemViewModel *> * subComment;

- (void)requestForSubComment;

- (void)requestForZan;

- (void)requestForBlackList;
@end

@interface YCTCommentViewModel : YCTBaseViewModel
@property (nonatomic, copy) NSArray<YCTCommentItemViewModel *> * comments;
@property (nonatomic, copy, readonly) NSArray<YCTCommentItemViewModel *> * commentViewModels;

@property (nonatomic, strong) YCTCommentItemViewModel * commentViewModel;
@property (nonatomic, strong) YCTCommentItemViewModel * subCommentViewModel;
@property (nonatomic, strong) RACSubject * endFooterRefreshSubject;
@property (nonatomic, assign) NSInteger commentCount;

- (instancetype)initWithVideoId:(NSString *)videoId commentCount:(NSInteger)commentCount;

- (void)refresh;

- (void)loadMore;

- (void)requestForPublishCommentWithContent:(NSString *)content;

@end

NS_ASSUME_NONNULL_END
