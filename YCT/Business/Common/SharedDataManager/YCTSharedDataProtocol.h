//
//  YCTSharedDataProtocol.h
//  YCT
//
//  Created by 木木木 on 2022/1/13.
//

#import <Foundation/Foundation.h>

@protocol YCTSharedDataProtocol <NSObject>

@property (nonatomic, copy, readonly) NSString *id;
@property (nonatomic, copy, readonly) NSString *dataType;

@end
