//
//  YCTApiPublishVideo.m
//  YCT
//
//  Created by hua-cloud on 2022/1/7.
//

#import "YCTApiPublishVideo.h"

@implementation YCTApiPublishVideo{
    NSString * _tagTexts;
    NSString * _musicId;
    NSString * _videoUrl;
    NSString * _thumbUrl;
    NSString * _title;
    NSInteger _locationId;
    NSString * _status;
    NSString * _videoTime;
    NSInteger _videoId;
    bool _allowSave;
    bool _allowShare;
    bool _isEdit;
    NSInteger _id;
    NSString * _goodstype;
    NSInteger _hengping;
    int _type;
 }

- (instancetype)initWithTagTexts:(NSString *)tagTexts
                         musicId:(NSString *)musicId
                        videoUrl:(NSString *)videoUrl
                        thumbUrl:(NSString *)thumbUrl
                           title:(NSString *)title
                      locationId:(NSInteger )locationId
                          status:(NSString *)status
                       allowSave:(BOOL)allowSave
                      allowShare:(BOOL)allowShare
                       videoTime:(NSString *)videoTime
                          isEdit:(BOOL)isEdit
                         videoId:(NSInteger)videoId
                       goodstype:(NSString *)goodstype
                        hengping:(NSInteger)hengping
                            type:(int)type{
    self = [super init];
    NSLog(@"tagTexts:%@  musicId:%@   videoUrl:%@   thumbUrl:%@  title:%@   locationId:%ld  status:%@  allowSave:%d  allowShare:%d  videoTime:%@  isEdit:%d  videoId:%ld   goodstype:%@  hengping:%ld",tagTexts,musicId,videoUrl,thumbUrl,title,locationId,status,allowSave?1:0,allowShare?1:0,videoTime,isEdit?1:0,videoId,goodstype,hengping);
    if (self) {
        _tagTexts = tagTexts;
        _musicId = musicId;
        _videoUrl = videoUrl;
        _thumbUrl = thumbUrl;
        _title = title;
        _locationId = locationId;
        _status = status;
        _videoTime = videoTime;
        _allowSave = allowSave;
        _allowShare = allowShare;
        _isEdit = isEdit;
        _videoId = videoId;
        _id = videoId;
        _type=type;
        _goodstype = goodstype;
        _hengping = hengping;
    }
    return self;
 }

 - (NSString *)requestUrl {
     return _isEdit ? @"/index/video/editVideo" : @"/index/video/publishVideo";
 }

 - (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
 }

 - (NSDictionary *)yct_requestArgument {
     if (_isEdit) {
         return @{
             @"tagTexts": _tagTexts,
             @"musicId": _musicId,
             @"videoUrl": _videoUrl,
             @"thumbUrl": _thumbUrl,
             @"title" :_title,
             @"locationId": @(_locationId),
             @"status": _status,
             @"videoTime":_videoTime,
             @"allowSave": _allowSave ? @"1":@"0",
             @"allowShare": _allowShare ? @"1":@"0",
             @"id": @(_id),
             @"goodstype":_goodstype,
             @"hengping":@(_hengping),
             @"type":@(_type),
         };
     }
     NSDictionary *dic=@{
         @"tagTexts": _tagTexts,
         @"musicId": _musicId,
         @"videoUrl": _videoUrl,
         @"thumbUrl": _thumbUrl,
         @"title" :_title,
         @"locationId": @(_locationId),
         @"status": _status,
         @"videoTime":_videoTime,
         @"allowSave": _allowSave ? @"1":@"0",
         @"allowShare": _allowShare ? @"1":@"0",
         @"goodstype":_goodstype,
         @"hengping":@(_hengping),
         @"type":@(_type),
     };
     NSLog(@"这里报错了？：%@",dic);
     return dic;
 }


@end
