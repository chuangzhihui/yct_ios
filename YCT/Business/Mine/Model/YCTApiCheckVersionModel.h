//
//  YCTApiCheckVersionModel.h
//  YCT
//
//  Created by 张大爷的 on 2024/6/23.
//

#import "YCTBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface YCTApiCheckVersionModel : YCTBaseModel
@property int version;
@property (copy, nonatomic) NSString *url_ios;
@end

NS_ASSUME_NONNULL_END
