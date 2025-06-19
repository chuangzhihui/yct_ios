//
//  AiTagsModel.h
//  YCT
//
//  Created by 林涛 on 2025/3/25.
//

#import "YCTBaseModel.h"

NS_ASSUME_NONNULL_BEGIN



#pragma mark - children -
@interface Children: YCTBaseModel
@property (nonatomic ,assign)NSInteger  id;
@property (nonatomic ,copy)NSString * name;
@property (nonatomic ,copy)NSString * url;
@property (nonatomic ,assign)NSInteger  is_ai;
@property (nonatomic ,copy)NSString * price;
@property (nonatomic ,assign)NSInteger  type;
@property (nonatomic ,copy)NSArray<Children *> * children;
@end


#pragma mark - data -
@interface AiTagsModel : YCTBaseModel
@property (nonatomic ,assign)NSInteger  id;
@property (nonatomic ,copy)NSString * name;
@property (nonatomic ,copy)NSString * url;
@property (nonatomic ,assign)NSInteger  is_ai;
@property (nonatomic ,copy)NSString * price;
@property (nonatomic ,assign)NSInteger  type;
@property (nonatomic ,copy)NSArray<Children *> * children;

@end

NS_ASSUME_NONNULL_END
