//
//  YCTShareModel.h
//  YCT
//
//  Created by 木木木 on 2021/12/19.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_OPTIONS(NSUInteger, YCTShareType) {
    YCTSharePrivateMessage =    1 << 0,
    YCTShareWeChatTimeLine =    1 << 1,
    YCTShareWeChat =            1 << 2,
    YCTShareDownloadSave =      1 << 3,
    YCTShareCollect =           1 << 4,
    YCTShareReport =            1 << 5,
    YCTShareLike =              1 << 6,
    YCTShareDislike =           1 << 7,
    YCTShareBlacklist =         1 << 8,
    YCTShareCollected =         1 << 9,
    YCTShareLiked =             1 << 10,
    YCTShareUser =              1 << 11,
    YCTShareZalo =              1 << 12,
    YCTShareRemark =            1 << 13,
    YCTShareFB =              1 << 14,
};

@interface YCTShareItem : NSObject

@property (assign, nonatomic) YCTShareType shareType;
@property (copy, nonatomic) NSString *shareTitle;
@property (copy, nonatomic) NSString *imageName;

+ (YCTShareType)allTypes;

@end

NS_ASSUME_NONNULL_END
