//
//  YCTCateViewCell.h
//  YCT
//
//  Created by 张大爷的 on 2022/10/10.
//

#import <UIKit/UIKit.h>
#import "YCTCatesModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface YCTCateViewCell : UITableViewCell
@property(nonatomic,strong)UILabel *title;
@property(nonatomic,strong)UIView *shuxian;
-(void)setCellUI:(YCTCatesModel *)model;
-(void)setCellUIForHomeSearch:(YCTCatesModel *)model;

@end

NS_ASSUME_NONNULL_END
