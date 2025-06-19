//
//  AiClassificationPageVC.h
//  YCT
//
//  Created by 林涛 on 2025/3/25.
//

#import "YCTBaseViewController.h"
#import "AiTagsModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface AiClassificationPageVC : YCTBaseViewController

@property (nonatomic, strong) NSMutableArray<AiTagsModel *> *dataArr;

@end

NS_ASSUME_NONNULL_END
