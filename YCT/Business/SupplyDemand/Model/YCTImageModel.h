//
//  YCTImageModel.h
//  YCT
//
//  Created by 木木木 on 2022/1/11.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YCTImageModel : NSObject
@property (nonatomic, copy) NSString *imageUrl;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, copy, readonly) NSString *imageHash;
@end

NS_ASSUME_NONNULL_END
