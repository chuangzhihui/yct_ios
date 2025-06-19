//
//  YCTSearchUserModel.h
//  YCT
//
//  Created by 木木木 on 2022/1/2.
//

#import "YCTBaseModel.h"
#import "YCTCommonUserModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface YCTSearchUserModel : YCTCommonUserModel

///粉丝数
@property (nonatomic, copy) NSString *fansNum;
///播放数
@property (nonatomic, copy) NSString *playNum;

@end

NS_ASSUME_NONNULL_END
