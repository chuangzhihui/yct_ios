//
//  CompanyInfoTableViewCell.h
//  YCT
//
//  Created by 张大爷的 on 2022/7/11.
//

#import <UIKit/UIKit.h>
#import "YYCopyLabel.h"
NS_ASSUME_NONNULL_BEGIN

@interface CompanyInfoTableViewCell : UITableViewCell
@property(nonatomic,strong)UIView *content;
@property(nonatomic,strong)UILabel *xinyong;
@property(nonatomic,strong)YYCopyLabel *xinyongVal;
@property(nonatomic,strong)UILabel *leixing;
@property(nonatomic,strong)YYCopyLabel *leixingVal;
@property(nonatomic,strong)UILabel *riqi;
@property(nonatomic,strong)YYCopyLabel *riqiVal;
@property(nonatomic,strong)UILabel *faren;
@property(nonatomic,strong)YYCopyLabel *farenVal;
@property(nonatomic,strong)UILabel *ziben;
@property(nonatomic,strong)YYCopyLabel *zibenVal;
@property(nonatomic,strong)UIView *line1;
@property(nonatomic,strong)UILabel *diqu;
@property(nonatomic,strong)YYCopyLabel *diquVal;
@property(nonatomic,strong)UILabel *dizhi;
@property(nonatomic,strong)YYCopyLabel *dizhiVal;
@property(nonatomic,strong)UILabel *jieshao;
@property(nonatomic,strong)YYCopyLabel *jieshaoVal;
@property(nonatomic,strong)UIView *line2;
@property(nonatomic,strong)UILabel *contact;
@property(nonatomic,strong)YYCopyLabel *contactVal;
@property(nonatomic,strong)UILabel *mobile;
@property(nonatomic,strong)YYCopyLabel *mobileVal;
@property(nonatomic,strong)UILabel *email;
@property(nonatomic,strong)YYCopyLabel *emailVal;
@property(nonatomic,strong)UILabel *website;
@property(nonatomic,strong)YYCopyLabel *websiteVal;
@end

NS_ASSUME_NONNULL_END
