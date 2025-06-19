//
//  YCTCommentPopView.h
//  YCT
//
//  Created by hua-cloud on 2022/1/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSInteger,YCTCommentPopViewSelectedType) {
    YCTCommentPopViewSelectedTypeReply,
    YCTCommentPopViewSelectedTypeCopy,
    YCTCommentPopViewSelectedTypeReport,
    YCTCommentPopViewSelectedTypeBlock
};
@interface YCTCommentPopView : UIView

@property (nonatomic, copy) void(^handlerClick)(YCTCommentPopViewSelectedType type);
@end

NS_ASSUME_NONNULL_END
