//
//  YCTChatVideoCellData.m
//  YCT
//
//  Created by 木木木 on 2022/1/8.
//

#import "YCTChatVideoCellData.h"

@implementation YCTChatVideoCellData

+ (YCTChatVideoCellData *)getCellData:(V2TIMMessage *)message {
   NSDictionary *param = [NSJSONSerialization JSONObjectWithData:message.customElem.data options:NSJSONReadingAllowFragments error:nil];
    YCTChatVideoCellData *cellData = [[YCTChatVideoCellData alloc] initWithDirection:message.isSelf ? MsgDirectionOutgoing : MsgDirectionIncoming];
    cellData.videoUrl = param[@"videoUrl"];
    cellData.thumbUrl = param[@"thumbUrl"];
    cellData.userId = param[@"userId"];
    cellData.nickName = param[@"nickName"];
    cellData.videoId = param[@"videoid"];
    cellData.remark = param[@"remark"];
    return cellData;
}

+ (NSString *)getDisplayString:(V2TIMMessage *)message {
    return [NSString stringWithFormat:@"[%@]", YCTLocalizedTableString(@"chat.sharedVideo", @"Chat")];
}

- (CGSize)contentSize {
    CGSize size = CGSizeMake(165, 264);
    return size;
}

@end
