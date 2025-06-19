//
//  CompanyAuditModel.h
//  YCT
//
//  Created by 林涛 on 2025/4/1.
//

#import "YCTBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface CompanyAuditModel : YCTBaseModel
@property (nonatomic, copy) NSString *nickName;
@property (nonatomic, assign) BOOL isPay;
@end

NS_ASSUME_NONNULL_END
