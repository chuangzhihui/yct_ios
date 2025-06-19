//
//  CompanyBasicInfo.h
//  YCT
//
//  Created by 张大爷的 on 2022/7/9.
//

#import <UIKit/UIKit.h>
#import "CompanyBasicInfoLine.h"
NS_ASSUME_NONNULL_BEGIN

@interface CompanyBasicInfo : UIView
@property(nonatomic,strong)CompanyBasicInfoLine *companyNameLine;
@property(nonatomic,strong)CompanyBasicInfoLine *companyDescLine;
@property(nonatomic,strong)CompanyBasicInfoLine *mainProduct;
@property(nonatomic,strong)CompanyBasicInfoLine *industry;
@end

NS_ASSUME_NONNULL_END
