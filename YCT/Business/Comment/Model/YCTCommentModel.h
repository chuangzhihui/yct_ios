//
//  YCTCommentModel.h
//  YCT
//
//  Created by hua-cloud on 2022/1/8.
//

#import "YCTBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface YCTCommentModel : YCTBaseModel
@property (nonatomic , copy) NSString              * avatar;
@property (nonatomic , copy) NSString              * id;
@property (nonatomic , copy) NSString              * content;
@property (nonatomic , assign) NSInteger              zanNum;
@property (nonatomic , assign) NSInteger              isMe;
@property (nonatomic , assign) NSInteger              isAuthor;
@property (nonatomic , copy) NSString              * nickName;
@property (nonatomic , copy) NSString              * atime;
@property (nonatomic , assign) NSInteger              isZan;
@property (nonatomic , copy) NSString              * pnickNames;
@property (nonatomic , assign) NSInteger             sonNum;
@property (nonatomic , copy) NSString              * userId;
@end

NS_ASSUME_NONNULL_END
