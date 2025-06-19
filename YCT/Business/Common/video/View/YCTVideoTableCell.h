//
//  YCTVideoTableCell.h
//  YCT
//
//  Created by hua-cloud on 2021/12/12.
//

#import <UIKit/UIKit.h>
#import "YCTVideoViewModel.h"
#import "YCTVideoDefine.h"
NS_ASSUME_NONNULL_BEGIN
static NSString * const k_even_comment_click = @"k_even_comment_click";
static NSString * const k_even_avatar_click = @"k_even_avatar_click";
static NSString * const k_even_video_delete = @"k_even_video_delete";
static NSString * const k_even_video_fullScreen = @"k_even_video_fullScreen";
@interface YCTVideoTableCell : UITableViewCell
@property (assign, nonatomic) YCTVideoType type;
- (void)triggerTapGestureAction;
@property (weak, nonatomic) IBOutlet UIView *videoContainerView;

- (void)cellPrepareDisplayWithViewModel:(YCTVideoCellViewModel *)viewModel;

- (void)triggerForStopPlaying;

- (void)contentTransformWhenEndDragging;
- (void)contentTransformWhenDragging;
@end

NS_ASSUME_NONNULL_END
