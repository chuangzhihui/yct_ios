//
//  YCTApiGetMyGXList.h
//  YCT
//
//  Created by 木木木 on 2021/12/31.
//

#import "YCTPagedRequest.h"
#import "YCTMyGXListModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface YCTApiGetMyGXList : YCTPagedRequest

- (instancetype)initWithType:(YCTMyGXListType)type;

@end

NS_ASSUME_NONNULL_END
