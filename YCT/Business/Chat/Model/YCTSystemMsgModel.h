//
//  YCTSystemMsgModel.h
//  YCT
//
//  Created by 木木木 on 2021/12/29.
//

#import "YCTBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface YCTSystemMsgContentModel : YCTBaseModel
/// 内容子标题
@property (nonatomic, copy) NSString *title;
/// 内容子内容
@property (nonatomic, copy) NSString *content;
@end

@interface YCTSystemMsgModel : YCTBaseModel
/// 标题
@property (nonatomic, copy) NSString *title;
/// 时间
@property (nonatomic, assign) NSTimeInterval atime;
///内容数组
@property (nonatomic, strong) NSArray<YCTSystemMsgContentModel *> *content;
/// 内容
@property (nonatomic, copy) NSString *contents;
/// 时间字符串
@property (nonatomic, copy) NSString *timeStr;

@property (strong, nonatomic) NSAttributedString *contentString;
@property (nonatomic, assign) CGRect bubbleFrame;
@property (nonatomic, assign) CGRect titleFrame;
@property (nonatomic, assign) CGRect timeFrame;
@property (nonatomic, assign) CGRect contentFrame;
@property (nonatomic, assign) CGFloat height;

@end

NS_ASSUME_NONNULL_END
