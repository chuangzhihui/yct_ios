//
//  YCTDefaltValue.h
//  YCT
//
//  Created by hua-cloud on 2022/1/8.
//

#import <Foundation/Foundation.h>


NS_ASSUME_NONNULL_BEGIN

extern BOOL YCTBool(id value, BOOL defaultValue);
extern NSInteger YCTInteger(id value, NSInteger defaultValue);
extern double YCTDouble(id value, double defaultValue);
extern NSString * YCTString(id value, NSString * _Nullable defaultValue);
extern NSArray * YCTArray(id value, NSArray * _Nullable defaultValue);
extern NSDictionary * YCTDictionary(id value, NSDictionary * _Nullable defaultValue);

NS_ASSUME_NONNULL_END

