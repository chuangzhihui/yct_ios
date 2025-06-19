//
//  YCTPublishVideoModel.h
//  YCT
//
//  Created by hua-cloud on 2022/1/21.
//

#import "YCTBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface YCTPublishVideoModel : YCTBaseModel
@property (nonatomic , assign) NSInteger               id;
@property (nonatomic , copy) NSString              * videoUrl;
@property (nonatomic , copy) NSString              * thumbUrl;
@property (nonatomic , copy) NSString              * title;
@property (nonatomic , copy) NSString              * address;
@property (nonatomic , assign) NSInteger              locationId;
@property (nonatomic , assign) NSInteger              status;
@property (nonatomic , assign) NSInteger              allowSave;
@property (nonatomic , assign) NSInteger              allowShare;
@property (nonatomic , copy) NSString              *  musicId;
@property (nonatomic , strong) NSArray <NSString *>              * tags;
@property (nonatomic , assign) NSInteger              videoTime;
@property (nonatomic , assign) NSString               *goodstype;
@property (nonatomic , assign) NSInteger              hengping;
@end

NS_ASSUME_NONNULL_END
