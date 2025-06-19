//
//  YCTRequestConfig.h
//  YCT
//
//  Created by hua-cloud on 2021/12/25.
//

#import <Foundation/Foundation.h>
#import "YCTRequestConfigDelegate.h"


#define BaseUrl @"https://yct.vnppp.net"
//#define BaseUrl @"http://192.168.31.230:8081"
//#define BaseUrl @"https://ylhz.honghukeji.net:10443"


NS_ASSUME_NONNULL_BEGIN

@interface YCTRequestConfig : NSObject<YCTRequestConfigDelegate>

@end

NS_ASSUME_NONNULL_END
