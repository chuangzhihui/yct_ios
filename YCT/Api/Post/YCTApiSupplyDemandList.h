//
//  YCTApiSupplyDemandList.h
//  YCT
//
//  Created by 木木木 on 2022/1/14.
//

#import "YCTPagedRequest.h"
#import "YCTSupplyDemandItemModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface YCTApiSupplyDemandList : YCTPagedRequest


@property (nonatomic, copy) NSString *keywords;
@property (nonatomic, copy) NSString *locationId;
@property int type;
@end

NS_ASSUME_NONNULL_END
