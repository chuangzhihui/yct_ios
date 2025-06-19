//
//  NSString+Regex.m
//  YCT
//
//  Created by 木木木 on 2021/12/25.
//

#import "NSString+Regex.h"

NSString *const KHRELetterNumber = @"[^a-zA-Z0-9]";
NSString *const KHRENumber = @"[^0-9]";
NSString *const KHREChineseLetter = @"[^a-zA-Z\u4e00-\u9fa5]";
NSString *const KHREChineseNumberLetter = @"[^a-zA-Z0-9\u4e00-\u9fa5]";

NSString *const KHREFullNumber = @"[0-9]{0,7}([.]{1}[0-9]{0,2}){0,1}";
NSString *const KHREPhoneNumber = @"1[0-9]{10}";

@implementation NSString (Regex)

- (BOOL)isValidNumber {
    NSString *regex = KHREFullNumber;
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [pred evaluateWithObject:self];
}

- (BOOL)isValidPhoneNumber {
    NSString *regex = KHREPhoneNumber;
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [pred evaluateWithObject:self];
}

- (BOOL)isLetterOrNum {
    if (self.length == 0) return NO;
    NSString *regex = @"[a-zA-Z0-9]*";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [pred evaluateWithObject:self];
}

- (BOOL)isEmptyString {
    if (!self || [[self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] isEqualToString:@""]) {
        return YES;
    }
    else {
        return NO;
    }
}

+ (BOOL)isEmptyWith:(NSString *)string {
    if (!string || [string isEmptyString]) {
        return YES;
    }
    return NO;
}

+ (NSString *)filterSpaceWithText:(NSString *)text {
    return [text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

+ (NSString *)filterEmojiWithText:(NSString *)text {
    NSMutableString *originText = [NSMutableString stringWithString:text];
    [originText enumerateSubstringsInRange:NSMakeRange(0, [originText length]) options:NSStringEnumerationByComposedCharacterSequences usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
        BOOL containsEmoji = NO;
        const unichar hs = [substring characterAtIndex:0];
        // surrogate pair
        if (0xd800 <= hs && hs <= 0xdbff) {
            if (substring.length > 1) {
                const unichar ls = [substring characterAtIndex:1];
                const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                if (0x1d000 <= uc && uc <= 0x1f9c0) {
                    containsEmoji = YES;
                }
            }
        }
        else if (substring.length > 1) {
            const unichar ls = [substring characterAtIndex:1];
            if (ls == 0x20e3 || ls == 0xfe0f || ls == 0xd83c) {
                containsEmoji = YES;
            }
        }
        else {
            // non surrogate
            if (0x2100 <= hs && hs <= 0x27ff) {
                containsEmoji = YES;
            }
            else if (0x2B05 <= hs && hs <= 0x2b07) {
                containsEmoji = YES;
            }
            else if (0x2934 <= hs && hs <= 0x2935) {
                containsEmoji = YES;
            }
            else if (0x3297 <= hs && hs <= 0x3299) {
                containsEmoji = YES;
            }
            else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50) {
                containsEmoji = YES;
            }
        }

        if (containsEmoji) {
            [originText deleteCharactersInRange:substringRange];
        }
    }];
    return originText;
}

- (BOOL)emo_containsEmoji {
    __block BOOL containsEmoji = NO;
    
    [self enumerateSubstringsInRange:NSMakeRange(0,
                                                 [self length])
                             options:NSStringEnumerationByComposedCharacterSequences
                          usingBlock:^(NSString *substring,
                                       NSRange substringRange,
                                       NSRange enclosingRange,
                                       BOOL *stop) {
         const unichar hs = [substring characterAtIndex:0];
         // surrogate pair
         if (0xd800 <= hs && hs <= 0xdbff) {
             if (substring.length > 1) {
                 const unichar ls = [substring characterAtIndex:1];
                 const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                 if (0x1d000 <= uc && uc <= 0x1f9c0) {
                     containsEmoji = YES;
                 }
             }
         }
         else if (substring.length > 1) {
             const unichar ls = [substring characterAtIndex:1];
             if (ls == 0x20e3 || ls == 0xfe0f || ls == 0xd83c) {
                 containsEmoji = YES;
             }
         }
         else {
             // non surrogate
             if (0x2100 <= hs && hs <= 0x27ff) {
                 containsEmoji = YES;
             }
             else if (0x2B05 <= hs && hs <= 0x2b07) {
                 containsEmoji = YES;
             }
             else if (0x2934 <= hs && hs <= 0x2935) {
                 containsEmoji = YES;
             }
             else if (0x3297 <= hs && hs <= 0x3299) {
                 containsEmoji = YES;
             }
             else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50) {
                 containsEmoji = YES;
             }
         }
         
         if (containsEmoji) {
             *stop = YES;
         }
     }];
    
    return containsEmoji;
}

+ (NSString *)filterCharactor:(NSString *)string withRegex:(NSString *)regexStr {
    if (!string) {
        return @"";
    }
    NSString *filterText = string;
    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regexStr options:NSRegularExpressionCaseInsensitive error:&error];
    NSString *result = [regex stringByReplacingMatchesInString:filterText options:NSMatchingReportCompletion range:NSMakeRange(0, filterText.length) withTemplate:@""];
    return result;
}

+ (NSString *)filterLetterNumber:(NSString *)string {
    return [self filterCharactor:string withRegex:KHRELetterNumber];
}

+ (NSString *)filterNumber:(NSString *)string {
    return [self filterCharactor:string withRegex:KHRENumber];
}

+ (NSString *)filterChineseLetter:(NSString *)string {
    return [self filterCharactor:string withRegex:KHREChineseLetter];
}

+ (NSString *)filterChineseNumberLetter:(NSString *)string {
    return [self filterCharactor:string withRegex:KHREChineseNumberLetter];
}

@end
