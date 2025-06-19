//
//  AiClassificationListVC.h
//  YCT
//
//  Created by 林涛 on 2025/3/25.
//

#import "YCTBaseViewController.h"
#import <JXCategoryView/JXCategoryView.h>
#import "AiTagsModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface AiClassificationListVC : YCTBaseViewController<JXCategoryListContentViewDelegate>
@property (nonatomic, strong) NSArray<Children *> *dataArr;
@property (nonatomic, strong) AiTagsModel *dataModel;
@end

NS_ASSUME_NONNULL_END
