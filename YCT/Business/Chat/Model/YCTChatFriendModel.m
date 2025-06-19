//
//  YCTChatFriendModel.m
//  YCT
//
//  Created by 木木木 on 2022/1/2.
//

#import "YCTChatFriendModel.h"

@implementation YCTChatFriendModel

+ (nullable NSArray<NSString *> *)modelPropertyBlacklist {
    return @[
        @"subText",
    ];
}

- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic {
    if (self.isOnline) {
        self.subText = YCTLocalizedTableString(@"chat.friends.online", @"Chat");
    } else if (self.lastOutTime > 0) {
        NSInteger days = [[NSDate date] apartDaysWithDate:[NSDate dateWithTimeIntervalSince1970:self.lastOutTime]];
        if (days == 0) {
            self.subText = YCTLocalizedTableString(@"chat.friends.offline", @"Chat");
        } else if (days == 1) {
            self.subText = YCTLocalizedTableString(@"chat.friends.yesterday_online", @"Chat");
        } else if (days == 2) {
            self.subText = YCTLocalizedTableString(@"chat.friends.2dayAgo_online", @"Chat");
        } else if (days == 3) {
            self.subText = YCTLocalizedTableString(@"chat.friends.3dayAgo_online", @"Chat");
        } else {
            self.subText = YCTLocalizedTableString(@"chat.friends.offline", @"Chat");
        }
    } else {
        self.subText = YCTLocalizedTableString(@"chat.friends.offline", @"Chat");
    }
    
    return YES;
}

@end
