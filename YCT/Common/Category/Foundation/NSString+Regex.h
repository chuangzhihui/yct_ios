//
//  NSString+Regex.h
//  YCT
//
//  Created by 木木木 on 2021/12/25.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (Regex)

- (BOOL)emo_containsEmoji;
+ (BOOL)isEmptyWith:(NSString *)string;

- (BOOL)isValidNumber;// 整数或则小数
- (BOOL)isValidPhoneNumber;
- (BOOL)isLetterOrNum;

+ (NSString *)filterSpaceWithText:(NSString *)text;
+ (NSString *)filterEmojiWithText:(NSString *)text;

+ (NSString *)filterCharactor:(NSString *)string withRegex:(NSString *)regexStr;
+ (NSString *)filterLetterNumber:(NSString *)string;
+ (NSString *)filterNumber:(NSString *)string;
+ (NSString *)filterChineseLetter:(NSString *)string;
+ (NSString *)filterChineseNumberLetter:(NSString *)string;

@end

NS_ASSUME_NONNULL_END
