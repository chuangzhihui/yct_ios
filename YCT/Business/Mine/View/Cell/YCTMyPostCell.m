//
//  YCTMyPostCell.m
//  YCT
//
//  Created by 木木木 on 2021/12/14.
//

#import "YCTMyPostCell.h"
#import "YCTPostListTagsView.h"

@interface YCTMyPostCell ()

@property (weak, nonatomic) IBOutlet UIStackView *stackView;

@property (weak, nonatomic) IBOutlet UIView *statusView;
@property (weak, nonatomic) IBOutlet UIImageView *statusImageView;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *releaseInfoLabel;

@property (weak, nonatomic) IBOutlet YCTPostListTagsView *tagsView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tagsViewHeight;

@property (weak, nonatomic) IBOutlet UIView *contentLabelView;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imagesViewHeight;

@property (weak, nonatomic) IBOutlet UIView *siteView;
@property (weak, nonatomic) IBOutlet UIView *siteContainerView;
@property (weak, nonatomic) IBOutlet UILabel *siteLabel;

@property (weak, nonatomic) IBOutlet UIView *operationView;
@property (weak, nonatomic) IBOutlet UIButton *reEditButton;
@property (weak, nonatomic) IBOutlet UIButton *removeButton;

@property (weak, nonatomic) IBOutlet UIView *bottomView;

@end

@implementation YCTMyPostCell

- (void)awakeFromNib {
    [super awakeFromNib];

    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.stackView.backgroundColor = UIColor.whiteColor;
    self.statusView.backgroundColor = UIColor.whiteColor;
    self.tagsView.backgroundColor = UIColor.whiteColor;
    self.contentLabelView.backgroundColor = UIColor.whiteColor;
    self.siteView.backgroundColor = UIColor.whiteColor;
    self.siteContainerView.backgroundColor = UIColor.whiteColor;
    self.operationView.backgroundColor = UIColor.whiteColor;
    self.bottomView.backgroundColor = UIColor.tableBackgroundColor;
    
    self.statusLabel.textColor = UIColor.whiteColor;
    self.statusLabel.font = [UIFont PingFangSCBold:14];
    
    self.contentLabel.textColor = UIColor.mainTextColor;
    self.contentLabel.font = [UIFont PingFangSCBold:16];
    
    self.imagesView.backgroundColor = UIColor.whiteColor;
    
    self.siteLabel.textColor = UIColor.mainGrayTextColor;
    self.siteLabel.font = [UIFont PingFangSCMedium:12];
    self.siteContainerView.layer.borderColor = UIColor.separatorColor.CGColor;
    self.siteContainerView.layer.borderWidth = 1;
    self.siteContainerView.layer.cornerRadius = 13;
    
    [self.reEditButton setMainThemeStyleWithTitle:YCTLocalizedTableString(@"mine.post.reEdit", @"Mine") fontSize:16 cornerRadius:22 imageName:@"mine_post_reEdit"];
    [self.removeButton setGrayStyleWithTitle:YCTLocalizedTableString(@"mine.post.offTheShelf", @"Mine") fontSize:16 cornerRadius:22 imageName:@"mine_post_delete"];
    
    @weakify(self);
    self.imagesView.imagViewClickBlock = ^(NSUInteger index) {
        @strongify(self);
        !self.imageClickBlock ? : self.imageClickBlock(self, index);
    };
}

- (void)updateWithModel:(YCTMyGXListModel *)model {
    self.model = model;
    
    self.statusLabel.text = model.statusText;
    
    self.releaseInfoLabel.attributedText = model.releaseText;
    
    if (model.tagsLayout) {
        self.tagsView.hidden = NO;
        self.tagsView.tagTextLayout = model.tagsLayout;
        self.tagsViewHeight.constant = model.tagsLayout.textBoundingSize.height;
    } else {
        self.tagsView.hidden = YES;
    }
    
    self.statusImageView.image = [YCTMyGXListModel statusBgImage:model.status];
    if (model.status == YCTMyGXListTypeRemoved) {
        self.statusLabel.textColor = UIColor.mainGrayTextColor;
    } else {
        self.statusLabel.textColor = UIColor.whiteColor;
    }
    
    self.contentLabel.text = model.title;
    self.contentLabelView.hidden = model.title.length == 0;
    
    self.imagesViewHeight.constant = [YCTPostImagesView heightWithTotal:model.imgs.count];
    self.imagesView.hidden = (model.imgs.count == 0);
    [self.imagesView updateWithUrls:model.imgs];
    
    self.siteLabel.text = [NSString stringWithFormat:@"%@·%@", model.area, model.address];
    
    self.operationView.hidden = NO;
    self.reEditButton.hidden = NO;
    
    [self.removeButton setGrayStyleWithTitle:YCTLocalizedTableString(@"mine.post.offTheShelf", @"Mine") fontSize:16 cornerRadius:22 imageName:@"mine_post_delete"];
    
    if (model.status == YCTMyGXListTypeDisplay) {
        self.removeButton.hidden = NO;
    }
    else if (model.status == YCTMyGXListTypeAuditing) {
        self.reEditButton.hidden = YES;
        // 下架操作
        self.removeButton.hidden = NO;
        [self.removeButton setGrayStyleWithTitle:YCTLocalizedTableString(@"mine.post.delete", @"Mine") fontSize:16 cornerRadius:22 imageName:@"mine_post_delete"];
    }
    else if (model.status == YCTMyGXListTypeAuditFailed) {
        self.removeButton.hidden = YES;
    }
    else if (model.status == YCTMyGXListTypeRemoved) {
        // 下架操作
        self.removeButton.hidden = NO;
        [self.removeButton setGrayStyleWithTitle:YCTLocalizedTableString(@"mine.post.delete", @"Mine") fontSize:16 cornerRadius:22 imageName:@"mine_post_delete"];
    }
}

- (IBAction)reEditButtonClick:(id)sender {
    NSMutableDictionary *dic = @{}.mutableCopy;
    [dic setValue:self.model forKey:@"model"];
    [self responseChainWithEventName:k_even_reEdit_click userInfo:dic.copy];
}

- (IBAction)removeButtonClick:(id)sender {
    NSMutableDictionary *dic = @{}.mutableCopy;
    [dic setValue:self.model forKey:@"model"];
    
    if (self.model.status == YCTMyGXListTypeAuditing
        || self.model.status == YCTMyGXListTypeRemoved) {
        [self responseChainWithEventName:k_even_delete_click userInfo:dic.copy];
    }
    else {
        [self responseChainWithEventName:k_even_offshelf_click userInfo:dic.copy];
    }
    
    
}

@end
