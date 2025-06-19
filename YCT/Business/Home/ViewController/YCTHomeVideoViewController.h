//
//  YCTHomeVideoViewController.h
//  YCT
//
//  Created by hua-cloud on 2021/12/12.
//

#import "YCTBaseViewController.h"
#import <JXCategoryView/JXCategoryView.h>

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSInteger, YCTHomeVideoType) {
    YCTHomeVideoTypeRecommand,
    YCTHomeVideoTypeFocus
};
@interface YCTHomeVideoViewController : YCTBaseViewController<JXCategoryListContentViewDelegate>
@property (nonatomic, assign) NSInteger user_type;//1企业 2普通
- (instancetype)initWithType:(YCTHomeVideoType)type;
-(void)refresh;
@end

NS_ASSUME_NONNULL_END
