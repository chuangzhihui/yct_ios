//
//  YCTSearchViewModel.h
//  YCT
//
//  Created by hua-cloud on 2022/1/11.
//

#import "YCTBaseViewModel.h"
#import "YCTVideoModel.h"
#import "YCTSearchUserModel.h"
#import "YCTApiSearch.h"
#import "YCTCatesModel.h"
NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSInteger,YCTSearchResultType) {
    YCTSearchResultTypeAll = 0,
    YCTSearchResultTypeVideo,
    YCTSearchResultTypeUser,
};

@interface YCTSearchResultViewModel : YCTBaseViewModel
@property (nonatomic, copy) NSString * locationId;
@property (nonatomic, copy, readonly) NSArray<YCTSearchUserModel *> * users;
@property (nonatomic, copy, readonly) NSArray<YCTVideoModel *> * hotVideos;
@property (nonatomic, copy, readonly) NSArray<YCTVideoModel *> * videos;
@property (nonatomic, copy, readonly) NSArray<YCTVideoModel *> * recommendVideos;

@property (nonatomic, copy, readonly) NSString * hotTitle;
@property (nonatomic, copy, readonly) NSString * userTitle;
@property (nonatomic, copy, readonly) NSString * videoTitle;
@property (nonatomic, copy, readonly) NSString * recommendTitle;

@property (nonatomic, strong, readonly) RACSubject * nodataSubject;
@property (nonatomic, strong, readonly) RACSubject * reloadSubject;
- (instancetype)initWithType:(YCTSearchResultType)type keyword:(NSString *)keyword locationId:(NSString *)locationId;

- (void)loadMore;
@end

@interface YCTSearchViewModel : YCTBaseViewModel

@property (nonatomic, copy, readonly) NSArray<NSString *> * historyKeys;
@property (nonatomic, copy) NSArray<NSString *> * wantSearchKeys;
@property (nonatomic, copy) NSArray<NSString *> * hotSearchKeys;
@property (nonatomic, copy) NSArray<YCTCatesModel *> * cateKeys;
@property (nonatomic, copy, readonly) NSArray * guessKeys;
@property (nonatomic, assign) BOOL isHistoryFold;
@property (nonatomic, copy) NSString * locationId;
@property (nonatomic, copy) NSString * locationName;

- (void)requestForWantSearch;
- (void)searchWithKeyword:(NSString *)keyword;
- (void)clearHistoryKeys;

@end

NS_ASSUME_NONNULL_END
