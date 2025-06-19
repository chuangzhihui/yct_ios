//
//  YCTApiSearchUser.h
//  YCT
//
//  Created by 木木木 on 2022/1/2.
//

#import "YCTPagedRequest.h"
#import "YCTCommonUserModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface YCTApiSearchUser : YCTPagedRequest

@property (nonatomic, copy) NSString *keyWords;

@end

NS_ASSUME_NONNULL_END
