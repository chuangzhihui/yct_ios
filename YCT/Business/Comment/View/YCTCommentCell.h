//
//  YCTCommentCell.h
//  YCT
//
//  Created by hua-cloud on 2021/12/19.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YCTCommentCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *avatar;
@property (weak, nonatomic) IBOutlet UILabel *nickName;
@property (weak, nonatomic) IBOutlet UIImageView *replyIcon;
@property (weak, nonatomic) IBOutlet UILabel *replyNickName;
@property (weak, nonatomic) IBOutlet UILabel *content;
@property (weak, nonatomic) IBOutlet UIButton *likeButton;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *isZaning;
@property (weak, nonatomic) IBOutlet UIStackView *likeContainer;
@property (weak, nonatomic) IBOutlet UILabel *likeCount;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UIButton *replyButton;
@property (nonatomic, copy) dispatch_block_t tapGesHandler;
@property (nonatomic, copy) dispatch_block_t avatarTapGesHandler;
@property (nonatomic, copy) dispatch_block_t longGesHandler;
@end

NS_ASSUME_NONNULL_END
