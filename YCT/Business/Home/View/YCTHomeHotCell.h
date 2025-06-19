//
//  YCTHomeHotCell.h
//  YCT
//
//  Created by hua-cloud on 2021/12/12.
//

#import <UIKit/UIKit.h>
#import "YCTHomeHotSubViewModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface YCTHomeHotCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *leftIcon;
@property (weak, nonatomic) IBOutlet UIImageView *avatarIcon;
@property (weak, nonatomic) IBOutlet UILabel *rankNum;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *rightTitle;
@property (weak, nonatomic) IBOutlet UIImageView *titleIcon;
@property (weak, nonatomic) IBOutlet UIImageView *hotImage;

- (void)prepareDisplayWith:(YCTHomeHotListItemViewModel *)viewModel;
@end

NS_ASSUME_NONNULL_END
