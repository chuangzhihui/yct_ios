//
//  YCTPhoneAreaModel.h
//  YCT
//
//  Created by 木木木 on 2022/1/8.
//

#import "YCTBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface YCTPhoneAreaModel : YCTBaseModel
@property (nonatomic, assign) NSUInteger *phoneAreaId;
@property (nonatomic, copy) NSString *no;
@property (nonatomic, copy) NSString *name;
@end

NS_ASSUME_NONNULL_END
