//
//  YCTShareModel.m
//  YCT
//
//  Created by 木木木 on 2021/12/19.
//

#import "YCTShareModel.h"

@implementation YCTShareItem

+ (YCTShareType)allTypes {
    return YCTSharePrivateMessage
        | YCTShareWeChatTimeLine
        | YCTShareWeChat
        | YCTShareDownloadSave
        | YCTShareCollect
        | YCTShareReport
        | YCTShareLike
        | YCTShareDislike
        | YCTShareCollected
        | YCTShareLiked
        | YCTShareBlacklist;
}

@end
