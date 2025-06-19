//
//  YCTApiVideoGetMusicsUseAiList.m
//  YCT
//
//  Created by 林涛 on 2025/4/6.
//

#import "YCTApiVideoGetMusicsUseAiList.h"

@implementation YCTApiVideoGetMusicsUseAiList{
    NSInteger _page;
    NSInteger _size;
    NSString *_taskId;
    
    NSInteger _type;
}

- (instancetype)initWithPage:(NSInteger)page{
   self = [super init];
   if (self) {
       _page = page;
       _size = 20;
       
       _type = 0;
   }
   return self;
}
- (instancetype)initWithTaskId:(NSString *)taskId{
   self = [super init];
   if (self) {
       _taskId = taskId;
       
       _type = 1;
   }
   return self;
}

- (NSString *)requestUrl {
    if (_type == 1) {
        return [NSString stringWithFormat:@"/index/user/deleteMusic/%@",_taskId];
    }
    return @"/index/user/getMusic";
}

- (YTKRequestMethod)requestMethod {
    if (_type == 1) {
        return YTKRequestMethodGET;
    }
   return YTKRequestMethodPOST;
}

- (Class)dataModelClass {
    if (_type == 1) {
        return nil;
    }
   return YCTBgmMusicModel.class;
}

- (NSDictionary *)yct_requestArgument {
    if (_type == 1) {
        return nil;
    }
    return @{
       @"page":@(_page),
       @"size":@(_size),
    };
}

@end
