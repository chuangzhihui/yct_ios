//
//  YCTMineGetLocationViewModel.h
//  YCT
//
//  Created by 木木木 on 2021/12/26.
//

#import <Foundation/Foundation.h>
#import "YCTMintGetLocationModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface YCTMineGetLocationViewModel : YCTBaseViewModel

- (instancetype)initWithPid:(NSString *)pid;

- (void)requestData;

@property (readonly) NSDictionary<NSString *, NSArray<YCTMintGetLocationModel *> *> *dataDict;

@property (readonly) NSArray *groupList;

@end

NS_ASSUME_NONNULL_END
