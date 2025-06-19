//
//  YCTUpdateVendorInfoHeaderView.h
//  YCT
//
//  Created by 木木木 on 2022/5/8.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YCTUpdateVendorInfoHeaderView : UIView

@property (nonatomic, weak) IBOutlet UIImageView *bgImageView;

@property (nonatomic, weak) IBOutlet UIView *topContentView;
@property (nonatomic, weak) IBOutlet UILabel *companyNameLabel;
@property (nonatomic, weak) IBOutlet UIButton *followButton;

@property (nonatomic, weak) IBOutlet UIView *infoContentView;
@property (nonatomic, weak) IBOutlet UILabel *briefLabel;
@property (nonatomic, weak) IBOutlet UILabel *contactNameLabel;
@property (nonatomic, weak) IBOutlet UILabel *contactNumberLabel;
@property (nonatomic, weak) IBOutlet UILabel *emailLabel;

@property (nonatomic, weak) IBOutlet UILabel *productTitleLabel;

- (void)updateContentHeight;

@property (nonatomic, assign) CGFloat contentHeight;

@end

NS_ASSUME_NONNULL_END
