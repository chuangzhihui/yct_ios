//
//  YCTLocationManager.h
//  YCT
//
//  Created by 木木木 on 2022/4/6.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class YCTLocationResultModel;

typedef void(^YCTLocationCompletion)(YCTLocationResultModel * _Nullable model,  NSError * _Nullable error);

@interface YCTLocationManager : NSObject

YCT_SINGLETON_DEF

- (void)checkPrivacyAgree;
- (void)requestLocationWithCompletion:(YCTLocationCompletion)completion;

@end

@interface YCTLocationResultModel : NSObject
@property (nonatomic, copy) NSString *formattedAddress;
@property (nonatomic, copy) NSString *POIName;
@property (nonatomic, copy) NSString *AOIName;
@end

NS_ASSUME_NONNULL_END
