//
//  YCTMineQRCodeModel.h
//  YCT
//
//  Created by 木木木 on 2022/1/19.
//

#import "YCTBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface YCTQRCodeUserInfoModel : YCTBaseModel

@property (nonatomic, copy) NSString *userId;
@property (nonatomic, assign) YCTMineUserType userType;

@end

@interface YCTMineQRCodeModel : YCTBaseModel

@property (nonatomic, copy) NSString *qrcode;
@property (nonatomic, strong) YCTQRCodeUserInfoModel *user;

@end

NS_ASSUME_NONNULL_END
