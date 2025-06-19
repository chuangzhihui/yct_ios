//
//  YCTGXTag.h
//  YCT
//
//  Created by 木木木 on 2021/12/27.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

// 1供应 2需求
typedef NS_ENUM(NSUInteger, YCTPostType) {
    YCTPostTypeSupply = 1,
    YCTPostTypeDemand = 2,
};

@interface YCTGXTag : NSObject

@property (copy, nonatomic) NSString *tagText;

@end

NS_ASSUME_NONNULL_END
