//
//  NSString+Common.h
//  YCT
//
//  Created by 木木木 on 2021/12/25.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (Common)

- (NSUInteger)characterLength;

+ (NSString *)handledText:(NSString *)text limitCharLength:(NSUInteger)length;
+ (void)handleText:(NSString *)text limitCharLength:(NSUInteger)length completion:(void (^)(BOOL isBeyondLength, NSString * _Nullable result))completion;

+ (NSString *)handledCountNumberIfMoreThanTenThousand:(NSInteger)count;

+ (NSString *)publishTimeWithStamp:(NSString *)stamp;
@end

NS_ASSUME_NONNULL_END
