//
//  NSString+Common.m
//  YCT
//
//  Created by 木木木 on 2021/12/25.
//

#import "NSString+Common.h"

@implementation NSString (Common)

- (NSUInteger)characterLength {
    __block NSUInteger total = 0;
    [self enumerateSubstringsInRange:NSMakeRange(0, self.length) options:NSStringEnumerationByComposedCharacterSequences usingBlock:^(NSString * _Nullable substring, NSRange substringRange, NSRange enclosingRange, BOOL * _Nonnull stop) {
        total++;
    }];
    return total;
}

static void LimitedChars(NSMutableArray *characters, NSString *text, NSUInteger length) {
    [text enumerateSubstringsInRange:NSMakeRange(0, text.length) options:NSStringEnumerationByComposedCharacterSequences usingBlock:^(NSString * _Nullable substring, NSRange substringRange, NSRange enclosingRange, BOOL * _Nonnull stop) {
        if (characters.count < length) {
            [characters addObject:substring];
        } else {
            *stop = true;
        }
    }];
}

+ (NSString *)handledText:(NSString *)text limitCharLength:(NSUInteger)length {
    NSUInteger charTotal = [text characterLength];
    if (charTotal > length) {
        NSMutableArray *characters = [NSMutableArray array];
        LimitedChars(characters, text, length);
        return [characters componentsJoinedByString:@""];
    } else {
        return text;
    }
}

+ (void)handleText:(NSString *)text limitCharLength:(NSUInteger)length completion:(void (^)(BOOL isBeyondLength, NSString * _Nullable result))completion {
    if (!completion) {
        return;
    }
    NSUInteger charTotal = [text characterLength];
    if (charTotal > length) {
        NSMutableArray *characters = [NSMutableArray array];
        LimitedChars(characters, text, length);
        completion(YES, [characters componentsJoinedByString:@""]);
    } else {
        completion(NO, nil);
    }
}

+ (NSString *)handledCountNumberIfMoreThanTenThousand:(NSInteger)count{
    if (count > 9999) {
        return [NSString stringWithFormat:@"%.1fW",count/10000.f];
    }
    return @(count).stringValue;
}

+ (NSString *)publishTimeWithStamp:(NSString *)stamp{
    NSDate *timeDate = [NSDate dateWithTimeIntervalSince1970:[stamp integerValue]];
    NSDate *currentDate = [NSDate date];
    NSTimeInterval timeInterval = [currentDate timeIntervalSinceDate:timeDate];
    NSDateFormatter * resultformatter = [[NSDateFormatter alloc] init];
    long temp = 0;
    NSString *result;
    if (timeInterval/60 < 1) {
        result = [NSString stringWithFormat:@"%@",YCTLocalizedString(@"time.aMomentAgo")];
    }
    else if((temp = timeInterval/60) <60){
        result = [NSString stringWithFormat:@"%ld%@",temp,YCTLocalizedString(@"time.minutesAgo")];
    }
    else if((temp = temp/60) <24){
        result = [NSString stringWithFormat:@"%ld%@",temp,YCTLocalizedString(@"time.hoursAgo")];
    }
    else if((temp = temp/24) <30){
        result = [NSString stringWithFormat:@"%ld%@",temp,YCTLocalizedString(@"time.daysAgo")];
    }
    else if((temp = temp/30) <12){
        [resultformatter setDateFormat:@"MM-dd"];
        result = [resultformatter stringFromDate:timeDate];
    }
    else{
        [resultformatter setDateFormat:@"yyyy-MM-dd"];
        result = [resultformatter stringFromDate:timeDate];
    }
    return result;
}
@end
