//
//  YCTMacroDefine.h
//  YCT
//
//  Created by 木木木 on 2021/12/9.
//

#ifndef YCTMacroDefine_h
#define YCTMacroDefine_h

#ifdef DEBUG
#define NSLog(...) NSLog(__VA_ARGS__)
#else
#define NSLog(...)
#endif

///国际化
///获取组件的国际化语言宏 命名规范 SCXXXLocalizedString(key,table)
#define YCTLocalizedString(key) [YCTSanboxTool localizedStringForKey:key]
#define YCTLocalizedTableString(_key, _table) [YCTSanboxTool localizedStringForKey:_key table:_table]
#define YCT_CURRENT_LANGUAGE [YCTSanboxTool getCurrentLanguage]

/// 获取APP版本号
#define kLocalDisplayName [[[NSBundle mainBundle] localizedInfoDictionary] objectForKey:@"CFBundleDisplayName"]
#define kLocalVersion [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]

#define YCTSafeBottom [UIApplication sharedApplication].delegate.window.safeBottom

#define Iphone_Bounds   [UIScreen mainScreen].bounds
#define Iphone_Height   [[UIScreen mainScreen] bounds].size.height
#define Iphone_Width    [[UIScreen mainScreen] bounds].size.width
#define kAutoScaleX(obj) (([UIScreen mainScreen].bounds.size.width / 375) * obj)
#define kAutoScaleY(obj) (([UIScreen mainScreen].bounds.size.height / 667) * obj)

#define Iphone_NavigationBarHeight   64
#define Iphone_TabBarHeight    49

#define UIColorFromRGB(rgbValue)    [UIColor colorWithRed:((float)(((rgbValue) & 0xFF0000) >> 16))/255.0 \
    green:((float)(((rgbValue) & 0x00FF00) >> 8))/255.0 \
    blue:((float)((rgbValue) & 0x0000FF))/255.0 \
    alpha:1.0]

#define UIColorFromRGBA(rgbValue, alphaValue)   [UIColor colorWithRed:((float)(((rgbValue) & 0xFF0000) >> 16))/255.0 \
    green:((float)(((rgbValue) & 0x00FF00) >> 8))/255.0 \
    blue:((float)((rgbValue) & 0x0000FF))/255.0 \
    alpha:(alphaValue)]

#define onePx (1.0 / [UIScreen mainScreen].scale)
#define kStatusBarHeight [UIApplication sharedApplication].statusBarFrame.size.height
#define kNavigationBarHeight ((self.navigationController.navigationBar.bounds.size.height ?: 44) + kStatusBarHeight)


#define YCT_IS(obj, cls)       (obj != nil && [obj isKindOfClass:[cls class]])

#define YCT_IS_NULL(obj)                               (YCT_IS(obj, NSNull))
#define YCT_IS_STRING(obj)                               (YCT_IS(obj, NSString))
#define YCT_IS_ARRAY(obj)                                (YCT_IS(obj, NSArray))
#define YCT_IS_DICTIONARY(obj)                           (YCT_IS(obj, NSDictionary))

#define YCT_IS_VALID_STRING(obj)                       (YCT_IS_STRING(obj) && [obj length] && !YCT_IS_NULL(obj))
#define YCT_IS_VALID_ARRAY(obj)                        (YCT_IS_ARRAY(obj) && [obj count])
#define YCT_IS_VALID_DICTIONARY(obj)                   (YCT_IS_DICTIONARY(obj) && [obj count])

#define YCT_SAFE_STRING(obj) (YCT_IS_VALID_STRING(obj) ? obj : @"")

#define YCT_AS(obj, cls, var)  cls *var = nil; if (YCT_IS(obj, cls)) var = (cls *)obj;

#define YCT_SINGLETON_DEF \
+ (instancetype)sharedInstance;

#define YCT_SINGLETON_IMP \
+ (instancetype)sharedInstance \
{ \
static dispatch_once_t once; \
static id __singleton__; \
dispatch_once( &once, ^{ __singleton__ = [[[self class] alloc] init]; } ); \
return __singleton__; \
}




#ifdef DEBUG
#define kDeallocDebugTest   \
- (void)dealloc {   \
NSLog(@"%@ ☀️☀️☀️☀️☀️ %s", NSStringFromClass(self.class) ,__FUNCTION__);    \
}
#else
#define kDeallocDebugTest   \
- (void)dealloc {}
#endif

#endif /* YCTMacroDefine_h */
