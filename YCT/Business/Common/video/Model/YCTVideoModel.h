//
//  YCTHomeVideoModel.h
//  YCT
//
//  Created by hua-cloud on 2021/12/28.
//

#import "YCTBaseModel.h"

NS_ASSUME_NONNULL_BEGIN



@interface YCTVideoModel : YCTBaseModel

@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *userId;
/// 点赞数量
@property (nonatomic, assign) NSInteger zanNum;
/// 评论数量
@property (nonatomic, assign) NSInteger commentNum;
/// 发布地址
@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSString *title;
/// 音乐文件
@property (nonatomic, copy) NSString *musicDesc;
@property (nonatomic, copy) NSString *musicImg;
/// 视频地址
@property (nonatomic, copy) NSString *videoUrl;
/// 缩略图地址
@property (nonatomic, copy) NSString *thumbUrl;
/// 头像
@property (nonatomic, copy) NSString *avatar;
@property (nonatomic, copy) NSString *nickName;
/// 是否点赞过这个视频
@property (nonatomic, assign) NSInteger isZan;
/// 是否是作者的粉丝
@property (nonatomic, assign) NSInteger isFans;
@property (nonatomic, assign) bool isCollection;
@property (nonatomic, assign) bool allowSave;
@property (nonatomic, assign) bool allowShare;
/// 是否是自己的作品
@property (nonatomic, assign) NSInteger isSelf;
@property (nonatomic, assign) NSInteger isTop;
@property (nonatomic, copy) NSString * playNum;
@property (nonatomic, assign) NSInteger locationId;
@property (nonatomic, copy) NSString * videoTime;
@property (nonatomic, assign) NSInteger hengping;
@end

@interface YCTVideoDataModel : YCTBaseModel
@property (nonatomic, assign) NSInteger totalPage;
@property (nonatomic, copy) NSArray<YCTVideoModel *> * datas;
@end
NS_ASSUME_NONNULL_END
