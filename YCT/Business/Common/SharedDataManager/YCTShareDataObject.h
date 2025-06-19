//
//  YCTShareDataObject.h
//  YCT
//
//  Created by 木木木 on 2022/1/13.
//

#import <Foundation/Foundation.h>
#import "YCTSharedDataProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface YCTShareDataObject : NSObject

@property (nonatomic, copy) NSString *type;

- (void)addObject:(id<YCTSharedDataProtocol>)obj;
- (void)sendValue:(id)value keyPath:(NSString *)keyPath type:(NSString *)type id:(NSString *)id;

@end

NS_ASSUME_NONNULL_END
