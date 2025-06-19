//
//  YCTConversationCellData.h
//  YCT
//
//  Created by 木木木 on 2021/12/29.
//

#import "TUIConversationCellData.h"

NS_ASSUME_NONNULL_BEGIN

@interface YCTConversationCellData : TUIConversationCellData
@property (nonatomic, copy) NSString *timeString;
@property (nonatomic, copy) NSString *subTitleString;
@property (nonatomic, copy) NSString *imageName;
@end

NS_ASSUME_NONNULL_END
