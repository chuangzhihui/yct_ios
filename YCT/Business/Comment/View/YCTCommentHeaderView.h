//
//  YCTCommentHeaderView.h
//  YCT
//
//  Created by hua-cloud on 2021/12/19.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YCTCommentHeaderView : UITableViewHeaderFooterView<UIGestureRecognizerDelegate>
@property (nonatomic, strong) UIImageView * avatar;
@property (nonatomic, strong) UILabel * nickName;
@property (nonatomic, strong) UILabel * markTag;
@property (nonatomic, strong) UILabel * content;
@property (nonatomic, strong) UILabel * timeLabel;
@property (nonatomic, strong) UIButton * reply;
@property (nonatomic, strong) UIButton * likeButton;
@property (nonatomic, strong) UILabel * likeCount;
@property (strong, nonatomic) UIStackView *likeContainer;
@property (strong, nonatomic) UIActivityIndicatorView *isZaning;
@property (nonatomic, copy) dispatch_block_t longGesHandler;
@property (nonatomic, copy) dispatch_block_t avatarTapGesHandler;
@property (nonatomic, copy) dispatch_block_t tapGesHandler;

+ (CGFloat)heightWithContentText:(NSString *)contentText;
@end

NS_ASSUME_NONNULL_END
