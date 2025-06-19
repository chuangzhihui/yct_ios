//
//  YCTMyPostCell.h
//  YCT
//
//  Created by 木木木 on 2021/12/14.
//

#import <UIKit/UIKit.h>
#import "YCTPostImagesView.h"
#import "YCTMyGXListModel.h"

NS_ASSUME_NONNULL_BEGIN

static NSString * const k_even_reEdit_click = @"k_even_reEdit_click";
static NSString * const k_even_offshelf_click = @"k_even_offshelf_click";
static NSString * const k_even_delete_click = @"k_even_delete_click";

@interface YCTMyPostCell : UITableViewCell

@property (nonatomic, weak) IBOutlet YCTPostImagesView *imagesView;

@property (nonatomic, strong) YCTMyGXListModel *model;

@property (nonatomic, copy) void(^imageClickBlock)(YCTMyPostCell *viewCell, NSInteger index);

- (void)updateWithModel:(YCTMyGXListModel *)model;

@end

NS_ASSUME_NONNULL_END
