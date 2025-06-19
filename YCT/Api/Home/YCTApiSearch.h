//
//  YCTApiSearchVideo.h
//  YCT
//
//  Created by hua-cloud on 2022/1/12.
//

#import "YCTBaseRequest.h"
#import "YCTComprehensiveSearchModel.h"
NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger,YCTApiSearchType){
    YCTApiSearchTypeComprehensive,
    YCTApiSearchTypeVideo,
    YCTApiSearchTypeUser
};

@interface YCTApiSearch : YCTBaseRequest

- (instancetype)initWithLocationId:(NSString *)locationId
                           keyword:(NSString *)keyword
                              page:(NSInteger)page
                              type:(YCTApiSearchType)type;
@end

NS_ASSUME_NONNULL_END
