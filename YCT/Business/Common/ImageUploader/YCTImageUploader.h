//
//  YCTImageUploader.h
//  YCT
//
//  Created by 木木木 on 2022/1/5.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YCTImageUploaderOptionsMaker : NSObject
@property (nonatomic, assign) NSUInteger maxConcurrentTaskNumber;
@end

typedef void(^YCTImageUploaderCompletion)(NSDictionary *imageUrlDic);

@interface YCTImageUploader : NSObject

- (void)uploadImages:(NSArray * _Nullable)images
        optionsMaker:(void (^ _Nullable)(YCTImageUploaderOptionsMaker *))optionsMaker
          completion:(YCTImageUploaderCompletion _Nullable)completion;

@end

NS_ASSUME_NONNULL_END
