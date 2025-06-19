//
//  YCTApiAuthPay.h
//  YCT
//
//  Created by 张大爷的 on 2024/6/22.
//

#import "YCTBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

typedef enum ApiAuthPayType : NSUInteger {
    ApiAuthPayTypeDefault = 0, // 默认
    ApiAuthPayTypeAiOther, // ai支付
} ApiAuthPayType;

@interface YCTApiAuthPay : YCTBaseRequest
@property (nonatomic, assign) NSInteger lookType; // 传type=1的时候返回200显示我的ai, 传type=2就走支付逻辑
@property (nonatomic, copy) NSString *type;//支付类型 1支付宝 2PayPal
@property (nonatomic, assign) ApiAuthPayType usrType;//
@property (nonatomic, strong) NSString *price;
@property (nonatomic, assign) NSInteger aiID;
- (instancetype)initWithType:(NSString *)type;
- (instancetype)initWithType:(NSString *)cate usrType:(ApiAuthPayType)usrType price:(nullable NSString *)price aiID:(NSInteger)aiID;
- (instancetype)initWithUsrType:(ApiAuthPayType)usrType aiID:(NSInteger)aiID;
@end

NS_ASSUME_NONNULL_END
