//
//  SetBannerTableViewCell.h
//  YCT
//
//  Created by 张大爷的 on 2022/7/11.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SetBannerTableViewCell : UITableViewCell
@property(nonatomic,strong)UIImageView *img;
@property(nonatomic,strong)UIButton *delBtn;
@property(nonatomic,strong)UIButton *setTop;
@property CGFloat height;
-(void)setImgSize:(NSURL *)imgUrl;
-(void)setUpUi;
@end

NS_ASSUME_NONNULL_END
