//
//  YCTAttentionCellData.m
//  YCT
//
//  Created by 木木木 on 2021/12/21.
//

#import "YCTAttentionCellData.h"

@implementation YCTAttentionCellData

+ (TUIMessageCellData *)getCellData:(V2TIMMessage *)message {
   NSDictionary *param = [NSJSONSerialization JSONObjectWithData:message.customElem.data options:NSJSONReadingAllowFragments error:nil];
    YCTAttentionCellData *cellData = [[YCTAttentionCellData alloc] initWithDirection:message.isSelf ? MsgDirectionOutgoing : MsgDirectionIncoming];
    cellData.followUserName = param[@"followUserName"];
    cellData.followAvatarUrl = param[@"followAvatarUrl"];
    cellData.followUserId = param[@"followUserId"];
    return cellData;
}

+ (NSString *)getDisplayString:(V2TIMMessage *)message {
    NSDictionary *param = [NSJSONSerialization JSONObjectWithData:message.customElem.data options:NSJSONReadingAllowFragments error:nil];
    return [NSString stringWithFormat:@"[%@]", param[@"followUserName"]];
}

- (CGSize)contentSize {
    // 260 (text + 130)
    //
    CGRect rect = [self.followUserName boundingRectWithSize:CGSizeMake(130, 40) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{ NSFontAttributeName : [UIFont systemFontOfSize:16 weight:(UIFontWeightBold)] } context:nil];
    CGSize size = CGSizeMake(MAX(260, ceilf(rect.size.width) + 14), 50);
    return size;
}

@end
