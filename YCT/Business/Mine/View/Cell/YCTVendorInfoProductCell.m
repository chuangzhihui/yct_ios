//
//  YCTVendorInfoProductCell.m
//  YCT
//
//  Created by 木木木 on 2022/5/8.
//

#import "YCTVendorInfoProductCell.h"

@implementation YCTVendorInfoAddProductCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView.backgroundColor = UIColor.grayButtonBgColor;
        self.contentView.layer.cornerRadius = 10;
        self.contentView.clipsToBounds = YES;
        
        UIImageView *photoImageView = [[UIImageView alloc] init];
        photoImageView.image = [UIImage imageNamed:@"login.photo"];
        [self.contentView addSubview:photoImageView];
        [photoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(24, 24));
            make.centerX.mas_equalTo(0);
            make.centerY.mas_equalTo(-10);
        }];
        
        UILabel *photoLabel = [[UILabel alloc] init];
        photoLabel.text = YCTLocalizedTableString(@"mine.updateVendorInfo.addProduct", @"Mine");
        photoLabel.textColor = UIColor.mainGrayTextColor;
        photoLabel.font = [UIFont PingFangSCMedium:12];
        [self.contentView addSubview:photoLabel];
        [photoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(photoImageView.mas_bottom).mas_offset(4);
            make.centerX.mas_equalTo(0);
        }];
        
        @weakify(self);
        [self.contentView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
            @strongify(self);
            !self.addBlock ?: self.addBlock();
        }]];
    }
    return self;
}

@end

@interface YCTVendorInfoProductCell ()
@property (nonatomic, strong) UIButton *deleteButton;
@end

@implementation YCTVendorInfoProductCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView.backgroundColor = UIColor.grayButtonBgColor;
        self.contentView.layer.cornerRadius = 10;
        self.contentView.clipsToBounds = YES;
        
        self.productImageView = [[UIImageView alloc] init];
        self.productImageView.contentMode = UIViewContentModeScaleAspectFill;
        self.productImageView.clipsToBounds = YES;
        [self.contentView addSubview:self.productImageView];
        [self.productImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(0);
        }];
        
        UIButton *deleteButton = [[UIButton alloc] init];
        deleteButton.backgroundColor = UIColorFromRGBA(0x000000, 0.2);
        [deleteButton setTitle:YCTLocalizedString(@"Delete") forState:(UIControlStateNormal)];
        [deleteButton setTitleColor:UIColor.whiteColor forState:(UIControlStateNormal)];
        deleteButton.titleLabel.font = [UIFont PingFangSCMedium:12];
        deleteButton.layer.cornerRadius = 3;
        deleteButton.clipsToBounds = YES;
        [deleteButton addTarget:self action:@selector(deleteProduct:) forControlEvents:(UIControlEventTouchUpInside)];
        self.deleteButton = deleteButton;
        [self.contentView addSubview:self.deleteButton];
        [self.deleteButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(10);
            make.right.mas_equalTo(-10);
            make.size.mas_equalTo(CGSizeMake(50, 24));
        }];
    }
    return self;
}

- (void)deleteProduct:(UIButton *)sender {
    if (self.deleteBlock) {
        self.deleteBlock(self.indexPath);
    }
}

- (void)setDeleteButtonHidden:(BOOL)isHidden {
    self.deleteButton.hidden = isHidden;
}

@end
