//
//  YCTComprehensiveSearchModel.h
//  YCT
//
//  Created by hua-cloud on 2022/1/12.
//

#import "YCTBaseModel.h"
#import "YCTVideoModel.h"
#import "YCTSearchUserModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface YCTComprehensiveSearchModel : YCTBaseModel
@property (nonatomic , strong) NSArray <YCTSearchUserModel *>         * companyInfo;
@property (nonatomic , strong) NSArray <YCTVideoModel *>              * videos;
@property (nonatomic , strong) NSArray <YCTVideoModel *>              * hotVideos;
@property (nonatomic , strong) NSArray <YCTVideoModel *>              * tjVideos;
@end

NS_ASSUME_NONNULL_END
