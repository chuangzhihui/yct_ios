//
//  YCTPostListCell.h
//  YCT
//
//  Created by 木木木 on 2021/12/9.
//

#import <UIKit/UIKit.h>
#import "YCTSupplyDemandItemModel.h"
#import "YCTPostImagesView.h"

NS_ASSUME_NONNULL_BEGIN

@interface YCTPostListCell : UITableViewCell

@property (nonatomic, weak) IBOutlet YCTPostImagesView *imagesView;

@property (nonatomic, weak) IBOutlet UIView *bottomView;

@property (nonatomic, weak) IBOutlet UIView *goodstypeView;
@property (nonatomic, weak) IBOutlet UILabel *goodstypeTitleLabel;
@property (nonatomic, weak) IBOutlet UILabel *goodstypeLabel;

@property (nonatomic, strong) YCTSupplyDemandItemModel *model;

@property (nonatomic, copy) void(^imageClickBlock)(YCTPostListCell *viewCell, NSInteger index);

@property (nonatomic, copy) void(^avatarClickBlock)(YCTSupplyDemandItemModel *model);

- (void)updateWithModel:(YCTSupplyDemandItemModel *)model;

@end

NS_ASSUME_NONNULL_END
