//
//  YCTApiPublishVideo.h
//  YCT
//
//  Created by hua-cloud on 2022/1/7.
//

#import "YCTBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface YCTApiPublishVideo : YCTBaseRequest

- (instancetype)initWithTagTexts:(NSString *)tagTexts
                         musicId:(NSString *)musicId
                        videoUrl:(NSString *)videoUrl
                        thumbUrl:(NSString *)thumbUrl
                           title:(NSString *)title
                      locationId:(NSInteger )locationId
                          status:(NSString *)status
                       allowSave:(BOOL)allowSave
                      allowShare:(BOOL)allowShare
                       videoTime:(NSString *)videoTime
                          isEdit:(BOOL)isEdit
                         videoId:(NSInteger)videoId
                       goodstype:(NSString *)goodstype
                        hengping:(NSInteger)hengping
                        type:(int)type;
@end

NS_ASSUME_NONNULL_END
