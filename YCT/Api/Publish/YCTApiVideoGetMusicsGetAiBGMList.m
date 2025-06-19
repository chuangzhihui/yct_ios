//
//  YCTApiVideoGetMusicsGetAiBGMList.m
//  YCT
//
//  Created by 林涛 on 2025/4/3.
//

#import "YCTApiVideoGetMusicsGetAiBGMList.h"

@implementation YCTApiVideoGetMusicsGetAiBGMList{
    NSInteger _page;
    NSInteger _size;
    NSString *_taskId;
}

- (instancetype)initWithPage:(NSInteger)page taskId:(NSString *)taskId{
   self = [super init];
   if (self) {
       _page = page;
       _size = 20;
       _taskId = taskId;
   }
   return self;
}
- (NSString *)requestUrl {
    return @"/index/user/getAiMusic";
}

- (YTKRequestMethod)requestMethod {
   return YTKRequestMethodPOST;
}

- (Class)dataModelClass {
   return YCTBgmMusicModel.class;
}

- (NSDictionary *)yct_requestArgument {
    return @{
//       @"page":@(_page),
//       @"size":@(_size),
       @"taskId":_taskId,
    };
}
@end
