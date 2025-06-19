//
//  YCTCatesModel.m
//  YCT
//
//  Created by 张大爷的 on 2022/10/10.
//

#import "YCTCatesModel.h"

@implementation YCTCatesModel
-(instancetype)initWithDic:(NSDictionary *)dic level:(int) level pid:(int)pid pname:(NSString *)pname ppid:(int)ppid ppname:(NSString *)ppname{
    self=[super init];
    if(self){
        NSString *name=[dic objectForKey:@"name"];
        if([name isEqual:[NSNull null]]){
            name=@"null";
        }
        self.level=level;
        self.pid=pid;
        self.pname=pname;
        self.ppid=ppid;
        self.ppname=ppname;
        self.name=name;
        self.cateId=[[dic objectForKey:@"id"] intValue];
    }
    return self;
}
@end
