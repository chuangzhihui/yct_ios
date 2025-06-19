//
//  YCTGuideViewController.h
//  YCT
//
//  Created by hua-cloud on 2021/12/10.
//

#import "YCTBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@protocol YCTGuideViewControllerDelegate <NSObject>

- (void)guideDidSelectLanguage:(NSString *)language;

@end

@interface YCTGuideViewController : YCTBaseViewController

@property (weak, nonatomic) id<YCTGuideViewControllerDelegate> delegate;

@property (strong, nonatomic) dispatch_block_t completion;

+ (BOOL)checkNeedShow;
@end

NS_ASSUME_NONNULL_END
